// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "solmate/utils/ReentrancyGuard.sol";
import "openzeppelin-contracts/utils/Strings.sol";
import "openzeppelin-contracts/utils/cryptography/SignatureChecker.sol";
import "solmate/tokens/ERC721.sol";

interface IIndex {
    function getPrice() external view returns (uint256);
}

interface IERC20 {
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

/**
 * @title ...
 * @author cairoeth <cairoeth@protonmail.com>
 * @notice ...
 **/
contract Exchange is ERC721, ReentrancyGuard {
    using Strings for uint256;

    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event NewOption(
        uint256 indexed id,
        address indexed buyer,
        address indexed seller,
        OptionInfo option
    );

    event ExercisedOption(
        uint256 indexed id,
        OptionInfo option
    );
    
    /*//////////////////////////////////////////////////////////////
                         MISCELLANEOUS CONSTANTS
    //////////////////////////////////////////////////////////////*/

    string public constant baseURI = "https://link/";

    /*//////////////////////////////////////////////////////////////
                                 STORAGE
    //////////////////////////////////////////////////////////////*/

    struct Signature {
        uint256 nonce;
        uint256 expiry;
        address signer;
        bytes signature;
    }

    struct OfferInfo {
        address _index;      // address of index
        bool    _type;       // True if put or false if call
        uint256 _strike;     // strike price
        uint256 _premium;    // premium return
        uint256 _expiry;     // duration of option
        address _token;      // token collateral
    }

    struct OptionInfo {
        uint256 _id;         // id of request
        address _index;      // address of index
        bool    _type;       // True if put or false if call
        uint256 _strike;     // strike price
        uint256 _premium;    // premium return
        uint256 _expiry;     // expiration in unix timestamp
        address _token;      // token collateral
        uint256 _timestamp;  // time when request was sent
        address _buyer;      // option buyer address
        address _seller;     // option seller address
    }
    
    mapping(uint256 => OptionInfo) public options;
    mapping(address => bool) public valid_collaterals;
    mapping(address => mapping(uint256 => bool)) internal nonce_used_before;

    uint256 public optionId;
    
    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(address[] memory collaterals) ERC721("Exchange Option", "OPTION") {
        for (uint i = 0; i < collaterals.length; i++) {
            valid_collaterals[collaterals[i]] = true;
        }
    }

    /*//////////////////////////////////////////////////////////////
                             PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
    * @notice Creates a ROF (request-for-quote) for a given option,
    * @param _offer The offer made by the lender,
    * @param _signature lenders signature
    **/
    function acceptOffer(OfferInfo memory _offer, Signature memory _signature) external nonReentrant returns (OptionInfo memory) {
        // TODO: check that index is valid
        require(valid_collaterals[_offer._token], "Token collateral address is not approved.");
        require(_offer._premium <= _offer._strike, "Premium must be equal or less than the strike.");
        require(!nonce_used_before[_signature.signer][_signature.nonce], "Option buyer nonce invalid");

        nonce_used_before[_signature.signer][_signature.nonce] = true;
        require(isSignatureValid(_offer, _signature), "Option seller signature is invalid");

        IERC20 collateral = IERC20(_offer._token);
        uint256 buyer_allowance = collateral.allowance(msg.sender, address(this));
        uint256 seller_allowance = collateral.allowance(_signature.signer, address(this));

        require(buyer_allowance >= _offer._premium, "Option buyer allowance must be equal or greater than the option premium.");
        require(seller_allowance >= _offer._strike, "Option seller Allowance must be equal or greater than the option strike.");

        bool seller_payment = collateral.transferFrom(msg.sender, _signature.signer, _offer._premium);
        require(seller_payment, "Seller premoum payment transfer failed.");

        bool receive_payment = collateral.transferFrom(_signature.signer, address(this), _offer._strike);
        require(receive_payment, "Receive collateral transfer failed.");

        ++optionId;

        OptionInfo memory option = OptionInfo({
            _id: optionId,
            _index: _offer._index,
            _type: _offer._type,
            _strike: _offer._strike,
            _premium: _offer._premium,
            _expiry: _offer._expiry,
            _token: _offer._token,
            _timestamp: block.timestamp,
            _buyer: msg.sender,
            _seller: _signature.signer
        });
        
        options[optionId] = option;

        _safeMint(option._buyer, option._id);
        
        emit NewOption(option._id, option._buyer, option._seller, option);

        return option;
    }

    /**
    * @notice Cancel an option that hasn't been sold,
    * @param _nonce nonce to mark as used.
    **/
    function cancel(uint256 _nonce) external {
        require(!nonce_used_before[msg.sender][_nonce], 'Nonce invalid, option buyer has either cancelled/begun this option, or reused a nonce when signing.');
        nonce_used_before[msg.sender][_nonce] = true;
    }

    /**
    * @notice Exercise an option after it reaches maturity,
    * @param _id id of the option 
    **/
    function exercise(uint256 _id) external nonReentrant returns (bool) {
        OptionInfo memory option = getOption(_id);
        
        require(_ownerOf[_id] != address(0), "Option does not exist or is not filled.");
        require(block.timestamp > option._expiry, "Option not expired.");
    
        IIndex index = IIndex(option._index);
        IERC20 collateral = IERC20(option._token);

        address receiver = _ownerOf[_id];
        uint256 price = index.getPrice();

        _burn(_id);
        
        // Price decreased or equal to strike.
        if (price <= option._strike) {
            uint256 payback_holder = option._strike - price;
            uint256 payback_seller = option._strike - payback_holder;

            // Paying option filler.
            bool payment_seller = collateral.transferFrom(address(this), option._seller, payback_seller);
            require(payment_seller, "Filler payback transfer failed.");

            // Option is put, hence profitable.
            if (option._type) {
                bool payment_holder = collateral.transferFrom(address(this), receiver, payback_holder);
                require(payment_holder, "Holder payback transfer failed.");
            }
            // Option is call, hence not profitable.
            else {
                delete options[_id];
            }
        } 
        // Price increased compared to strike.
        else {
            uint256 payback_holder = price - option._strike;
            uint256 payback_seller = option._strike - payback_holder;

            // Paying option filler.
            bool payment_seller = collateral.transferFrom(address(this), option._seller, payback_seller);
            require(payment_seller, "Filler payback transfer failed.");

            // Option is put, hence not profitable.
            if (option._type) {
                delete options[_id];
            }
            // Option is call, hence profitable.
            else {
                // Paying option holder.
                bool payment_holder = collateral.transferFrom(address(this), receiver, payback_holder);
                require(payment_holder, "Holder payback transfer failed.");
            }
        }

        emit ExercisedOption(_id, option);

        return true;
    }

    /*//////////////////////////////////////////////////////////////
                           INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function isSignatureValid(OfferInfo memory _offer, Signature memory _signature) internal view returns (bool) {
        require(block.timestamp <= _signature.expiry, "Option seller signature has expired");
        require(_signature.signer != address(0));

        uint8 chainId;

        assembly {
            chainId := chainid()
        }

        bytes32 message = keccak256(
            abi.encodePacked(getEncodedOffer(_offer), getEncodedSignature(_signature), address(this), chainId)
        );

        return
            SignatureChecker.isValidSignatureNow(
                _signature.signer,
                ECDSA.toEthSignedMessageHash(message),
                _signature.signature
            );
    }

    function getEncodedOffer(OfferInfo memory _offer) internal pure returns (bytes memory) {
        return
            abi.encodePacked(
                _offer._type,
                _offer._strike,
                _offer._premium,
                _offer._expiry,
                _offer._token
            );
    }

    function getEncodedSignature(Signature memory _signature) internal pure returns (bytes memory) {
        return abi.encodePacked(_signature.signer, _signature.nonce, _signature.expiry);
    }
    
    /*//////////////////////////////////////////////////////////////
                                HELPERS
    //////////////////////////////////////////////////////////////*/

    /**
    * @notice Returns the option info struct for a given id,
    * @param _id  id of the struct to fetch.
    **/
    function getOption(uint256 _id) public view returns (OptionInfo memory) {
        OptionInfo memory _option = options[_id];

        return _option;
    }

    /**
    * @notice Returns the URL of a token's metadata.
    * @param _tokenId Token ID
    **/
    function tokenURI(uint256 _tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(_ownerOf[_tokenId] != address(0), "Non-existent token URI");
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, _tokenId.toString()))
                : "";
    }

    receive() external payable {}
}
