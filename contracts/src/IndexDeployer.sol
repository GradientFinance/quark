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
        address uma;
        string name;
        address denomination;
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
        address uma,
        address denomination,
        string memory name
    ) internal returns (address index) {
        parameters = Parameters({factory: factory, coefficients: coefficients, intercept: intercept, attributes: attributes, collection: collection, uma: uma, denomination: denomination, name: name});
        index = address(new Index{salt: keccak256(abi.encode(coefficients, attributes, collection, uma, denomination, name))}());
        delete parameters;
    }
}
