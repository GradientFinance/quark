// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;


interface IIndexDeployer {
    function parameters()
        external
        view
        returns (
            address factory,
            int256[] memory coefficients,
            int256 intercept,
            string[] memory attributes,
            address collection,
            string memory name
        );
}
