// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import './IndexDeployer.sol';
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
        address denomination,
        string indexed name,
        address index
    );

    /*//////////////////////////////////////////////////////////////
                                 STORAGE
    //////////////////////////////////////////////////////////////*/

    // Store all the created indeces.
    mapping(string => address) public getIndex;
    mapping(address => bool) public isIndex;
    mapping(address => bool) public valid_denomination;

    address public immutable uma; 

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(address[] memory denominations, address _uma) {
        for (uint i = 0; i < denominations.length; i++) {
            valid_denomination[denominations[i]] = true;
        }

        uma = _uma;
    }

    /*//////////////////////////////////////////////////////////////
                            EXTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function createIndex(
        int256[] memory coefficients,
        int256 intercept,
        string[] memory attributes,
        address collection,
        address denomination,
        string memory name
    ) external nonReentrant returns (address index) {
        require(getIndex[name] == address(0), "Index with given name already exists.");
        require(valid_denomination[denomination], "Collateral denomination token is not approved.");

        index = deploy(address(this), coefficients, intercept, attributes, collection, uma, denomination, name);

        getIndex[name] = index;
        isIndex[index] = true;

        emit IndexCreated(coefficients, intercept, attributes, collection, denomination, name, index);
    }

    function isValid(address index) external view returns (bool) {
        return isIndex[index];
    }
}
