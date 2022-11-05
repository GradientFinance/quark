// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {console} from "forge-std/console.sol";
import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";

import {Utils} from "./utils/Utils.sol";
import "../src/Exchange.sol";
import "../src/Index.sol";
import "./mocks/ApeCoin.sol";
 
contract BaseSetup is Test {
    Utils internal utils;

    address internal deployer;
    address internal buyer;
    address internal seller;

    address[] internal collaterals; 
    address payable[] internal users;

    Exchange public exchange;
    Index public index;
    ApeCoin public apecoin;

    function setUp() public virtual {
        utils = new Utils();
        users = utils.createUsers(3);

        deployer = users[0];
        vm.label(deployer, "Exchange Deployer");

        buyer = users[1];
        vm.label(buyer, "Option Buyer");

        seller = users[2];
        vm.label(seller, "Option Seller");

        apecoin = new ApeCoin();
        collaterals.push(address(apecoin));

        index = new Index();

        vm.prank(deployer);
        exchange = new Exchange(collaterals);
    }
}

contract TestExchange is BaseSetup {
    function setUp() public virtual override {
        BaseSetup.setUp();
    }

    function testCreateOption() public {
        console.log(
            "Create a put option."
        );
    }
}
