// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import './interfaces/IIndexDeployer.sol';
import "prb-math/PRBMathSD59x18.sol";
import "./uma/OptimisticOracleV2Interface.sol";

contract Index {
    using PRBMathSD59x18 for int256;

    /*//////////////////////////////////////////////////////////////
                                 STORAGE
    //////////////////////////////////////////////////////////////*/

    address public immutable factory;
    address public immutable collection;
    address public immutable uma;

    int256[] public coefficients;
    int256[] public index;
    int256 public intercept;
    string public name;
    string[] public attributes;

    OptimisticOracleV2Interface oracle;

    // Use the yes no idetifier to ask arbitary questions, such as the weather on a particular day.
    bytes32 identifier = bytes32("YES_OR_NO_QUERY");

    // Post the question in ancillary data. Note that this is a simplified form of ancillry data to work as an example. A real
    // world prodition market would use something slightly more complex and would need to conform to a more robust structure.
    bytes ancillaryData =
        bytes("Q:Did the temperature on the 25th of July 2022 in Manhattan NY exceed 35c? A:1 for yes. 0 for no.");

    uint256 requestTime = 0; // Store the request time so we can re-use it later.

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor() {
        (factory, coefficients, intercept, attributes, collection, uma, name) = IIndexDeployer(msg.sender).parameters();

        // Define the Optimistic oracle with the given UMA address.
        oracle = OptimisticOracleV2Interface(uma);
    }

    /*//////////////////////////////////////////////////////////////
                             PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    function getPrice(int256[] memory _characteristics, uint256 indexNumber) external view returns (int256) {
        return getRefPrice(_characteristics, false) * index[indexNumber];
    }

    // Submit a data request to the Optimistic oracle.
    function requestData() public {
        requestTime = block.timestamp; // Set the request time to the current block time.
        IERC20 bondCurrency = IERC20(0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6); // Use Görli WETH as the bond currency.
        uint256 reward = 0; // Set the reward to 0 (so we dont have to fund it from this contract).

        // Now, make the price request to the Optimistic oracle and set the liveness to 30 so it will settle quickly.
        oracle.requestPrice(identifier, requestTime, ancillaryData, bondCurrency, reward);
        oracle.setCustomLiveness(identifier, requestTime, ancillaryData, 30);
    }

    // Settle the request once it's gone through the liveness period of 30 seconds. This acts the finalize the voted on price.
    // In a real world use of the Optimistic Oracle this should be longer to give time to disputers to catch bat price proposals.
    function settleRequest() public {
        oracle.settle(address(this), identifier, requestTime, ancillaryData);
    }

    // Fetch the resolved price from the Optimistic Oracle that was settled.
    function getSettledData() public view returns (int256) {
        return oracle.getRequest(address(this), identifier, requestTime, ancillaryData).resolvedPrice;
    }

    /*//////////////////////////////////////////////////////////////
                            INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function getRefPrice(int256[] memory _characteristics, bool includePrice)
        internal
        view
        returns (int256)
    {
        int256 price = intercept;

        for (uint256 i = 0; i < coefficients.length; i++) {
            price += coefficients[i] * _characteristics[includePrice ? i + 1 : i];
        }

        return price;
    }
}