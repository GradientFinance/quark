// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "solmate/tokens/ERC20.sol";

interface ERC677Receiver {
    function onTokenTransfer(
        address _sender,
        uint256 _value,
        bytes memory _data
    ) external;
}

contract WETH is ERC20 {
    uint256 constant INITIAL_SUPPLY = 1000000000000000000000000;
    uint8 constant DECIMALS = 18;

    constructor() ERC20("WETH", "WETH", DECIMALS) {
        _mint(msg.sender, INITIAL_SUPPLY);
    }
}
