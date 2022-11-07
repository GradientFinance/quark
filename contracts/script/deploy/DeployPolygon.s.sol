// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {DeployBase} from "./DeployBase.s.sol";

contract DeployPolygon is DeployBase {
    address[] public denominations =  [
        // WETH
        0x7ceB23fD6bC0adD59E62ac25578270cFf1b9f619, 
        // USDC
        0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174,
        // IbAlluoUSD
        0xC2DbaAEA2EfA47EBda3E572aa0e55B742E408BF6
    ];

    address public immutable uma = 0xA5B9d8a0B0Fa04Ba71BDD68069661ED5C0848884;

    constructor()
        DeployBase(
            denominations,
            uma
        )
    {}
}
