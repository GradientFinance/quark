// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {DeployBase} from "./DeployBase.s.sol";

contract DeployEvmos is DeployBase {
    address[] public denominations =  [
        // WETH
        0x5842C5532b61aCF3227679a8b1BD0242a41752f2, 
        // USDC
        0x51e44FfaD5C2B122C8b635671FCC8139dc636E82
    ];

    address public immutable uma = 0xA5B9d8a0B0Fa04Ba71BDD68069661ED5C0848884;

    constructor()
        DeployBase(
            denominations,
            uma
        )
    {}
}
