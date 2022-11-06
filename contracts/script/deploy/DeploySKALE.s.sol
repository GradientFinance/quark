// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {DeployBase} from "./DeployBase.s.sol";

contract DeploySKALE is DeployBase {
    address[] public denominations =  [
        // DAI
        0x3163d01f990269fBeBbE6590bF60a9b499b6E163
    ];

    address public immutable uma = 0xA5B9d8a0B0Fa04Ba71BDD68069661ED5C0848884;

    constructor()
        DeployBase(
            denominations,
            uma
        )
    {}
}
