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
            uint8 accuracy,
            string[] memory attributes,
            address collection,
            address uma,
            address denomination,
            string memory name
        );
}
