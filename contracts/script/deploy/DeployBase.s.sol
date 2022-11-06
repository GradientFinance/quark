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

    constructor(
        address[] memory _denominations,
        address _uma
    ) {
        denominations = _denominations;
        uma = _uma;
    }

    function run() external {
        uint256 deployerKey = private_key;
        address DeployerAddress = vm.addr(deployerKey);

        vm.startBroadcast(DeployerAddress);

        // Deploy factory and exchange contracts.
        IndexFactory _indexfactory = new IndexFactory(denominations, uma);
        Exchange _exchange = new Exchange(address(_indexfactory));
        
        vm.stopBroadcast();
    }
}
