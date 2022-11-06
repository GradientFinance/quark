// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {DeployBase} from "./DeployBase.s.sol";

contract DeployGoerli is DeployBase {
    address[] public denominations =  [
        // WETH
        0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6, 
        // USDC
        0x07865c6E87B9F70255377e024ace6630C1Eaa37F,
        // APECOIN
        0x07865c6E87B9F70255377e024ace6630C1Eaa37F,
        // ibAlluoUSD
        0x07865c6E87B9F70255377e024ace6630C1Eaa37F];

    address public immutable uma = 0xA5B9d8a0B0Fa04Ba71BDD68069661ED5C0848884;

    constructor()
        DeployBase(
            denominations,
            uma
        )
    {}
}
