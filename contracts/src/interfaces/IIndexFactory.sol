// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

interface IIndexFactory {
    function getParameters()
        external
        view
        returns (
            address,
            int256[] memory,
            int256,
            uint8,
            string[] memory,
            address,
            address,
            address,
            string memory
        );
}
