// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {console} from "forge-std/console.sol";
import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";

import {Utils} from "./utils/Utils.sol";
import "../src/IndexFactory.sol";
 
contract BaseSetup is Test {
    Utils internal utils;

    address internal deployer;
    address internal creator;

    address[] internal collaterals; 
    address payable[] internal users;

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

    IndexFactory public indexfactory;

    function setUp() public virtual {
        utils = new Utils();
        users = utils.createUsers(3);

        deployer = users[0];
        vm.label(deployer, "Factory Deployer");

        creator = users[1];
        vm.label(creator, "Index Creator");

        vm.prank(deployer);
        indexfactory = new IndexFactory(denominations, uma);
    }
}

contract TestFactory is BaseSetup {
    int256[] coefficients = [int256(50), -63, 77, -28, 90];
    int256 intercept = 242242;
    uint8 accuracy = 85;
    string[] attributes = ['Aquamarine', 'Prom Dress', 'Crazy', 'Black', 'Bored'];
    address collection = 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D;
    address denomination = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;
    string name = 'BAYC Index'; 

    function setUp() public virtual override {
        BaseSetup.setUp();
    }

    function testCreateIndex() public {
        console.log(
            "Create a BAYC index."
        );

        vm.prank(creator);

        address index = indexfactory.createIndex(
            coefficients,
            intercept,
            accuracy,
            attributes,
            collection,
            denomination,
            name
        );
    }
}
