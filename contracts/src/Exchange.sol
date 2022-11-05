// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "solmate/utils/ReentrancyGuard.sol";
import "openzeppelin-contracts/utils/Strings.sol";
import "openzeppelin-contracts/utils/cryptography/SignatureChecker.sol";
import "solmate/tokens/ERC721.sol";

interface IIndex {
    function getPrice() external view returns (uint256);
}

interface IIndexFactory {
    function isValid(address index) external view returns (bool);
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

    event SoldOption(
        uint256 indexed id,
        address indexed buyer,
        address indexed seller,
        OptionInfo option
    );

    event RequestedOption(
        uint256 indexed id,
        OptionInfo option
    );

    event CancelledOption(
        uint256 indexed id,
        address indexed canceller,
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
    IIndexFactory factory;

    /*//////////////////////////////////////////////////////////////
                                 STORAGE
    //////////////////////////////////////////////////////////////*/

    struct RequestInfo {
        address _index;      // Index address
        bool    _type;       // Type of option: true if put or false if call
        uint256 _strike;     // Strike price
        uint256 _expiry;     // Expiration date (in UNIX seconds) of option
        address _token;      // Option collateral token address
    }

    struct OfferInfo {
        uint256 _id;         // ID of option offering to
        uint256 _premium;    // Premium offer
    }

    struct OptionInfo {
        uint256 _id;         // ID of option
        address _index;      // Index address
        bool    _type;       // Type of option: true if put or false if call
        uint256 _strike;     // Strike price
        uint256 _premium;    // Premium return
        uint256 _expiry;     // expiration in unix timestamp
        address _token;      // token collateral
        uint256 _timestamp;  // Expiration date (in UNIX seconds) of option
        address _buyer;      // Address who initially buys the option (different to the address that can excercise the option -> NFT holder)
        address _seller;     // Address who sells the option
    }
    
    mapping(uint256 => OptionInfo) public options;
    mapping(address => bool) public valid_collaterals;

    uint256 public optionId;
    
    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(address[] memory _collaterals, address _factory) ERC721("Exchange Option", "OPTION") {
        for (uint i = 0; i < _collaterals.length; i++) {
            valid_collaterals[_collaterals[i]] = true;
        }

        factory = IIndexFactory(_factory);
    }

    /*//////////////////////////////////////////////////////////////
                             PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    /**
    * @notice Creates a ROF (request-for-quote) for a given option,
    * @param _request The request option made by the sender.
    **/
    function requestOption(RequestInfo memory _request) external nonReentrant returns (OptionInfo memory) {
        require(factory.isValid(_request._index), "Index is not valid.");
        require(block.timestamp < _request._expiry, "Option is expired.");
        require(valid_collaterals[_request._token], "Token collateral address is not approved.");

        // This allowance is a filter to prevent spamming the front-end
        IERC20 collateral = IERC20(_request._token);
        uint256 allowance = collateral.allowance(msg.sender, address(this));
        require(allowance == uint256(2**256-1), "Allowance must be to the maximum spending possible (to pay any premium after acepting)");

        optionId++;

        OptionInfo memory option = OptionInfo({
            _id: optionId,
            _index: _request._index,
            _type:    _request._type,
            _strike: _request._strike,
            _premium: 2**256-1,
            _expiry: _request._expiry,
            _token: _request._token,
            _timestamp: 0,
            _buyer: msg.sender,
            _seller: address(0)
        });

        options[optionId] = option;
        
        emit RequestedOption(optionId, option);

        return option;
    }

    /**
    * @notice Creates an option sell offer,
    * @param _offer offer struct containing premium and ID of targetted option.
    **/
    function createOffer(OfferInfo memory _offer) external nonReentrant returns (OptionInfo memory) {
        OptionInfo memory option = getOption(_offer._id);

        require(option._timestamp == 0);
        require(_offer._premium < option._premium);
        
        // This allowance is a filter to prevent spamming the front-end
        IERC20 collateral = IERC20(option._token);
        uint256 allowance = collateral.allowance(msg.sender, address(this));
        require(allowance >= option._strike, "Allowance must be equal or greater than the option strike.");

        option._seller = msg.sender;
        option._premium = _offer._premium;

        return option;
    }

    /**
    * @notice Accepts the current option parameters,
    * @param _id ID of option to accept and mint.
    **/
    function acceptOption(uint256 _id) external nonReentrant returns (OptionInfo memory) {
        OptionInfo memory option = getOption(_id);

        require(msg.sender == option._buyer);
        require(option._timestamp == 0);
    
        IERC20 collateral = IERC20(option._token);
        uint256 buyer_allowance = collateral.allowance(option._buyer, address(this));
        uint256 seller_allowance = collateral.allowance(option._seller, address(this));

        require(buyer_allowance >= option._premium, "Option buyer allowance must be equal or greater than the option premium.");
        require(seller_allowance >= option._strike, "Option seller Allowance must be equal or greater than the option strike.");

        bool seller_payment = collateral.transferFrom(option._buyer, option._seller, option._premium);
        require(seller_payment, "Seller premium payment transfer failed.");

        bool receive_payment = collateral.transferFrom(option._seller, option._buyer, option._strike);
        require(receive_payment, "Receive collateral transfer failed.");

        option._timestamp = block.timestamp;

        _safeMint(option._buyer, option._id);
        
        emit SoldOption(option._id, option._buyer, option._seller, option);

        return option;
    }

    /**
    * @notice Cancel an option that hasn't been sold, which can be called by both the current pending seller or buyer,
    * @param _id of the option to cancell.
    **/
    function cancelOption(uint256 _id) external nonReentrant returns (bool) {
        OptionInfo memory option = getOption(_id);
        require(option._timestamp == 0);
        require(msg.sender == option._buyer && msg.sender == option._seller);

        delete options[_id];

        emit CancelledOption(option._id, msg.sender, option);

        return true;
    }

    /**
    * @notice Exercise an option after it reaches maturity,
    * @param _id id of the option 
    **/
    function exerciseOption(uint256 _id) external nonReentrant returns (bool) {
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
