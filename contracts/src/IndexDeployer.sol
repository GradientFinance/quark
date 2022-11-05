// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import './Index.sol';

contract IndexDeployer {

    /*//////////////////////////////////////////////////////////////
                                 STORAGE
    //////////////////////////////////////////////////////////////*/

    struct Parameters {
        address factory;
        int256[] coefficients;
        int256 intercept;
        string[] attributes;
        address collection;
        string name;
    }

    Parameters public parameters;

    /*//////////////////////////////////////////////////////////////
                            INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function deploy(
        address factory,
        int256[] memory coefficients,
        int256 intercept,
        string[] memory attributes,
        address collection,
        string memory name
    ) internal returns (address index) {
        parameters = Parameters({factory: factory, coefficients: coefficients, intercept: intercept, attributes: attributes, collection: collection, name: name});
        index = address(new Index{salt: keccak256(abi.encode(coefficients, attributes, collection, name))}());
        delete parameters;
    }
}
