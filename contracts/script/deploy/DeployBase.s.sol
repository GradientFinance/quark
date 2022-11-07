// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import "forge-std/Script.sol";

import {LibRLP} from "../../test/utils/LibRLP.sol";
import {IndexFactory} from "../../src/IndexFactory.sol";
import {Exchange} from "../../src/Exchange.sol";
import {Key} from "./Key.sol";

abstract contract DeployBase is Script, Key {
    // Environment specific variables.
    address[] private denominations;
    address private uma;

    // Deploy addresses
    IndexFactory public indexfactory;
    Exchange public exchange;

    constructor(
        address[] memory _denominations,
        address _uma
    ) {
        denominations = _denominations;
        uma = _uma;
    }

    function run() external {
        uint256 deployerPrivateKey = private_key;
        address DeployerAddress = vm.addr(deployerPrivateKey);
        uint256 nonce = vm.getNonce(DeployerAddress);

        // Precomputed contract addresses, based on contract deploy nonces.
        address indexfactory_address = LibRLP.computeAddress(DeployerAddress, nonce);
        address exchange_address = LibRLP.computeAddress(DeployerAddress, nonce + 1);

        vm.startBroadcast(DeployerAddress);

        // Deploy contracts.
        indexfactory = new IndexFactory(denominations, uma, exchange_address);
        require(address(indexfactory) == indexfactory_address);

        exchange = new Exchange(address(indexfactory));
        require(address(exchange) == exchange_address);

        vm.stopBroadcast();
    }
}
