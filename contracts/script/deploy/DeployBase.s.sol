// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "forge-std/Script.sol";

import {LibRLP} from "../../test/utils/LibRLP.sol";
import {IndexFactory} from "../../src/IndexFactory.sol";

abstract contract DeployBase is Script {
    // Environment specific variables.
    address[] private denominations;
    address private uma;

    // Deploy addresses.
    IndexFactory public _indexfactory;

    constructor(
        address[] memory _denominations,
        address _uma
    ) {
        denominations = _denominations;
        uma = _uma;
    }

    function run() external {
        uint256 deployerKey = vm.envUint("PRIVATE_KEY");
        address DeployerAddress = vm.addr(deployerKey);

        vm.startBroadcast(deployerKey);

        // Deploy team and community reserves, owned by cold wallet.
        _indexfactory = new IndexFactory();
        // _exchange = new Exchange(address(_indexfactory));
        
        vm.stopBroadcast();
    }
}
