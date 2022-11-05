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

    constructor() {
        address[4] memory denominations =  [
            // WETH
            0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6, 
            // USDC
            0x07865c6E87B9F70255377e024ace6630C1Eaa37F,
            // APECOIN
            0x07865c6E87B9F70255377e024ace6630C1Eaa37F,
            // ibAlluoUSD
            0x07865c6E87B9F70255377e024ace6630C1Eaa37F
        ];

        for (uint i = 0; i < denominations.length; i++) {
            valid_denomination[denominations[i]] = true;
        }

        uma = 0xA5B9d8a0B0Fa04Ba71BDD68069661ED5C0848884;
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
