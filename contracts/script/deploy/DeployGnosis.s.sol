// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {DeployBase} from "./DeployBase.s.sol";

contract DeployGnosis is DeployBase {
    address[] public denominations =  [
        // WETH
        0x6A023CCd1ff6F2045C3309768eAd9E68F978f6e1, 
        // USDC
        0xDDAfbb505ad214D7b80b1f830fcCc89B60fb7A83
    ];

    address public immutable uma = 0xA5B9d8a0B0Fa04Ba71BDD68069661ED5C0848884;

    constructor()
        DeployBase(
            denominations,
            uma
        )
    {}
}
