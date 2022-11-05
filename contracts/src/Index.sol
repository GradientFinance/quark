// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import './interfaces/IIndexDeployer.sol';
import "prb-math/PRBMathSD59x18.sol";

contract Index {
    using PRBMathSD59x18 for int256;
    
    /*//////////////////////////////////////////////////////////////
                                 STORAGE
    //////////////////////////////////////////////////////////////*/

    address public immutable factory;
    int256[] public coefficients;
    int256 public intercept;
    string[] public attributes;
    address public immutable collection;
    string public name;
    int256[] public index;

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor() {
        (factory, coefficients, intercept, attributes, collection, name) = IIndexDeployer(msg.sender).parameters();
    }

    /*//////////////////////////////////////////////////////////////
                             PUBLIC FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    
    function getPrice(int256[] memory _characteristics, uint256 indexNumber) external view returns (int256) {
        return getRefPrice(_characteristics, false) * index[indexNumber];
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