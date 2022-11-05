// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import './interfaces/IIndexDeployer.sol';

contract Index {
    address public immutable factory;
    uint256[] public coefficients;
    string[] public attributes;
    address public immutable collection;
    string public name;

    constructor() {
        (factory, coefficients, attributes, collection, name) = IIndexDeployer(msg.sender).parameters();
    }
}
