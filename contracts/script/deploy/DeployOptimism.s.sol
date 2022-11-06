// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {DeployBase} from "./DeployBase.s.sol";

contract DeployOptimism is DeployBase {
    address[] public denominations =  [
        // WETH
        0x4200000000000000000000000000000000000006, 
        // USDC
        0x7F5c764cBc14f9669B88837ca1490cCa17c31607
    ];

    address public immutable uma = 0xA5B9d8a0B0Fa04Ba71BDD68069661ED5C0848884;

    constructor()
        DeployBase(
            denominations,
            uma
        )
    {}
}
