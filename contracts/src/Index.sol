// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import './interfaces/IIndexFactory.sol';
import "prb-math/PRBMathSD59x18.sol";
import "./uma/OptimisticOracleV2Interface.sol";
import "openzeppelin-contracts/utils/Strings.sol";

contract Index {
    using Strings for uint256;
    using Strings for string[];
    using PRBMathSD59x18 for int256;

    /*//////////////////////////////////////////////////////////////
                                 STORAGE
    //////////////////////////////////////////////////////////////*/

    // Index paramaters
    address public immutable exchange;
    int256[] public coefficients;
    int256 public intercept;
    uint8 public accuracy;
    string[] public attributes;
    address public immutable collection;
    address public immutable uma;
    address public immutable denomination;
    string public name;
    uint256 public manipulation;
    bool public opensource;
    
    uint256 public volume;
    uint256 public count;
    int256[] public index;
    int256[][] public sales; // price is first slot. following slots are NFT chars
    int256 public lastest_price;

    /*//////////////////////////////////////////////////////////////
                             UMA CONSTANTS
    //////////////////////////////////////////////////////////////*/

    // Store the optimistic oracle address
    OptimisticOracleV2Interface oracle;

    // Use the token price identifier to return the lastest sale.
    bytes32 identifier = bytes32("TOKEN_PRICE");
    // Store the ancillary data request.
    bytes ancillaryData;
    // Store the request time so we can re-use it later.
    uint256 requestTime = 0;

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor() {
        (exchange, coefficients, intercept, accuracy, attributes, collection, uma, denomination, name, manipulation, opensource) = IIndexFactory(msg.sender).getParameters();

        // Define the Optimistic oracle with the given UMA address.
        oracle = OptimisticOracleV2Interface(uma);

        // Define the ancillary data.
        ancillaryData = bytes(createAncillary());

        // Set the intial price.
        lastest_price = intercept;
    }

    /*//////////////////////////////////////////////////////////////
                            PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    /**
    * @dev Returns the current index price.
    **/
    function getPrice() public view returns (int256) {
        return lastest_price;
    }

    /**
    * @dev Add volume by the exchange.
    **/
    function addVolume(uint256 _amount) external {
        volume = volume + _amount;
        count++;
    }

    /*//////////////////////////////////////////////////////////////
                             LINEAR MODEL
    //////////////////////////////////////////////////////////////*/

    /**
    * @dev Updates the index price with new sales data.
    **/
    function updateIndex() internal returns (int256){
        int256 num = 0;
        int256 denom = 0;

        for (uint256 i = 0; i < sales.length; i++) {
            num += sales[i][0];
            denom += getRefPrice(sales[i], true);
        }

        index.push(num / denom);

        return num / denom;
    }
    
    /**
    * @dev Get the reference price for each o f the characteristics.
    **/
    function getRefPrice(int256[] memory _characteristics, bool includePrice) internal view returns (int256) {
        int256 price = intercept;

        for (uint256 i = 0; i < coefficients.length; i++) {
            price += coefficients[i] * _characteristics[includePrice ? i + 1 : i];
        }

        return price;
    }

    /*//////////////////////////////////////////////////////////////
                                  UMA
    //////////////////////////////////////////////////////////////*/

    /**
    * @dev Submit a data request to the Optimistic oracle.
    **/
    function requestData() public {
        requestTime = block.timestamp; // Set the request time to the current block time.
        IERC20 bondCurrency = IERC20(denomination); // Use the given denomination (using WETH).
        uint256 reward = 0; // Set the reward to 0 (so we dont have to fund it from this contract).

        // Now, make the price request to the Optimistic oracle and set the liveness to 30 so it will settle quickly.
        oracle.requestPrice(identifier, requestTime, ancillaryData, bondCurrency, reward);
        oracle.setCustomLiveness(identifier, requestTime, ancillaryData, 30);
    }

    /**
    * @dev Settle the request once it's gone through the liveness period of 30 seconds. This acts the finalize the voted on price.
    *      In a real world use of the Optimistic Oracle this should be longer to give time to disputers to catch bat price proposals.
    **/
    function settleRequest() public {
        oracle.settle(address(this), identifier, requestTime, ancillaryData);
    }

    /**
    * @dev Fetch the resolved price from the Optimistic Oracle that was settled and calculate new price.
    **/
    function getSettledData() public returns (int256) {
        int256 data = oracle.getRequest(address(this), identifier, requestTime, ancillaryData).resolvedPrice;
        // If price is zero, then no new sale for the given collection with the tracked attributes,
        if (data == 0) {
            return 0;
        }
        else {
            // Compute new sale
            sales.push([data, 1]);

            lastest_price = updateIndex();
            return lastest_price;
        }
    }

    /*//////////////////////////////////////////////////////////////
                                HELPERS
    //////////////////////////////////////////////////////////////*/
    
    /**
    * @dev Function that returns the index denomination, used by the exchange.
    **/
    function getDenomination() external view returns (address) {
        return denomination;
    }

    /**
    * @dev Function that returns index data and stats, used by the front-end.
    **/
    function getData() external view returns (uint8 _accuracy, address _collection, address _denomination, string memory _name, uint256 _manipulation, bool _opensource, int256 _price, uint256 _volume, uint256 _count, address _index) {
        return(
            // CreateIndex values
            accuracy,
            collection, 
            denomination, 
            name,
            manipulation,
            opensource,

            // Index values
            getPrice(),
            volume,
            count,
            address(this)
        );
    }

    /*//////////////////////////////////////////////////////////////
                            INTERNAL HELPERS
    //////////////////////////////////////////////////////////////*/

    /**
    * @dev Creates a custom ancillary request for the given collection and attributes.
    **/
    function createAncillary() internal view returns (string memory) {
        string memory s1 = string.concat('Q:Was there a new sale for the collection ', _toAsciiString(collection));
        string memory s2 = string.concat(s1, ' containing ');
        
        for (uint i = 0; i<attributes.length; i++) {
            string memory attribute = attributes[i];
            s2 = string.concat(s2, attribute);
            s2 = string.concat(s2, ' ');
        }
        
        string memory s3 = string.concat(s2, '?');
        return s3;
    }

    /**
    * @dev Returns an address as a string memory
    * @param _address is address to transform
    **/
    function _toAsciiString(address _address) internal pure returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint(uint160(_address)) / (2**(8*(19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2*i] = _char(hi);
            s[2*i+1] = _char(lo);            
        }
        return string(s);
    }

    /**
    * @dev Allows to manipulate bytes for toAsciiString function
    * @param b is a byte
    **/
    function _char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
    }

}