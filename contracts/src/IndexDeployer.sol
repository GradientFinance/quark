// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import './Index.sol';

contract IndexDeployer {
    struct Parameters {
        address factory;
        uint256[] coefficients;
        string[] attributes;
        address collection;
        string name;
    }

    Parameters public parameters;

    function deploy(
        address factory,
        uint256[] memory coefficients,
        string[] memory attributes,
        address collection,
        string memory name
    ) internal returns (address index) {
        parameters = Parameters({factory: factory, coefficients: coefficients, attributes: attributes, collection: collection, name: name});
        index = address(new Index{salt: keccak256(abi.encode(coefficients, attributes, collection, name))}());
        delete parameters;
    }
}
