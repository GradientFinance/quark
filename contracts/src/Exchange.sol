// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "solmate/utils/ReentrancyGuard.sol";
import "openzeppelin-contracts/utils/Strings.sol";
import "openzeppelin-contracts/utils/cryptography/SignatureChecker.sol";
import "solmate/tokens/ERC721.sol";

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
        address _buyer;      // token collateral
        address _seller;     // token collateral
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

    constructor() ERC721("Exchange Option", "OPTION") {
    }

    /*//////////////////////////////////////////////////////////////
                             PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/

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
                _offer._token,
                _offer._buyer,
                _offer._seller
            );
    }

    function getEncodedSignature(Signature memory _signature) internal pure returns (bytes memory) {
        return abi.encodePacked(_signature.signer, _signature.nonce, _signature.expiry);
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
