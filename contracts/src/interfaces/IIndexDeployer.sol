// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;


interface IIndexDeployer {
    function parameters()
        external
        view
        returns (
            address factory,
            uint256[] memory coefficients,
            string[] memory attributes,
            address collection,
            string memory name
        );
}
