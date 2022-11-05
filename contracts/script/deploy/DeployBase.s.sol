// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import "forge-std/Script.sol";

import {LibRLP} from "../../test/utils/LibRLP.sol";

import {Exchange} from "../../src/Exchange.sol";
import {IndexDeployer} from "../../src/IndexDeployer.sol";
import {IndexFactory} from "../../src/IndexFactory.sol";

abstract contract DeployBase is Script {
    // Environment specific variables.
    address[] private denominations;
    address private uma;

    // Deploy addresses.
    Exchange public exchange;
    IndexDeployer public indexdeployer;
    IndexFactory public indexfactory;

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
        uint256 nonce = vm.getNonce(DeployerAddress);

        vm.startBroadcast(deployerKey);

        // Deploy team and community reserves, owned by cold wallet.
        indexdeployer = new IndexDeployer();
        indexfactory = new IndexFactory(denominations, uma);
        exchange = new Exchange(address(indexfactory));
    }
}
