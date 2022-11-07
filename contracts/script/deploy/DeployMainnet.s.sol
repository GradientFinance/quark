// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {DeployBase} from "./DeployBase.s.sol";

contract DeployMainnet is DeployBase {
    address[] public denominations =  [
        // WETH
        0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6, 
        // USDC
        0x07865c6E87B9F70255377e024ace6630C1Eaa37F,
        // APECOIN
        0x4d224452801ACEd8B2F0aebE155379bb5D594381,
        // IbAlluoUSD 
        0xF555B595D04ee62f0EA9D0e72001D926a736A0f6
    ];

    address public immutable uma = 0xA5B9d8a0B0Fa04Ba71BDD68069661ED5C0848884;

    constructor()
        DeployBase(
            denominations,
            uma
        )
    {}
}
