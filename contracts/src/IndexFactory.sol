// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import './IndexDeployer.sol';
import './Index.sol';
import "solmate/utils/ReentrancyGuard.sol";

contract IndexFactory is IndexDeployer, ReentrancyGuard {
    
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event IndexCreated(
        int256[] coefficients,
        int256 intercept,
        string[] attributes,
        address indexed collection,
        string indexed name,
        address index
    );

    /*//////////////////////////////////////////////////////////////
                                 STORAGE
    //////////////////////////////////////////////////////////////*/

    // Store all the created indeces.
    mapping(string => address) public getIndex;
    mapping(address => bool) public isIndex;

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor() {}

    /*//////////////////////////////////////////////////////////////
                            EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function createIndex(
        int256[] memory coefficients,
        int256 intercept,
        string[] memory attributes,
        address collection,
        string memory name
    ) external nonReentrant returns (address index) {
        require(getIndex[name] == address(0), "Index with given name already exists.");

        index = deploy(address(this), coefficients, intercept, attributes, collection, name);

        getIndex[name] = index;
        isIndex[index] = true;

        emit IndexCreated(coefficients, intercept, attributes, collection, name, index);
    }
}
