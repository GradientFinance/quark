// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {console} from "forge-std/console.sol";
import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";

import {Utils} from "./utils/Utils.sol";

import "../src/IndexFactory.sol";
import "../src/Exchange.sol";
import "./mocks/WETH.sol";

contract BaseSetup is Test {
    Utils internal utils;

    address internal deployer;
    address internal creator_and_buyer;
    address internal seller;

    address[] internal collaterals; 
    address payable[] internal users;

    IndexFactory public indexfactory;
    Exchange public exchange;
    WETH public weth;

    function setUp() public virtual {
        utils = new Utils();
        users = utils.createUsers(3);

        deployer = users[0];
        vm.label(deployer, "Factory Deployer");

        creator_and_buyer = users[1];
        vm.label(creator_and_buyer, "Index Creator & Option Buyer");

        seller = users[2];
        vm.label(seller, "Option Seller");

        vm.prank(deployer);
        indexfactory = new IndexFactory();

        vm.prank(deployer);
        exchange = new Exchange(address(indexfactory));

        vm.prank(creator_and_buyer);
        weth = new WETH();

        vm.prank(creator_and_buyer);
        weth.transfer(seller, 100000000000000000000);
    }
}

contract TestFactory is BaseSetup {
    int256[] coefficients = [int256(50), -63, 77, -28, 90];
    int256 intercept = 242242;
    uint8 accuracy = 85;
    string[] attributes = ['Aquamarine', 'Prom Dress', 'Crazy', 'Black', 'Bored'];
    address collection = 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D;
    string name = 'BAYC Index'; 
    uint256 manipulation = 10;
    bool opensource = true;

    function setUp() public virtual override {
        BaseSetup.setUp();
    }

    function testCreateIndex() public {
        console.log(
            "Create a BAYC index."
        );

        address denomination = address(weth);

        vm.prank(creator_and_buyer);

        address index = indexfactory.createIndex(
            coefficients,
            intercept,
            accuracy,
            attributes,
            collection,
            denomination,
            name,
            manipulation,
            opensource
        );

        // put
        bool _type = true;
        // 15 eth
        uint256 _strike = 15000000000000000000;
        // 30 days from now
        uint256 _expiry = 1669814557;
        
        vm.prank(creator_and_buyer);
        weth.approve(address(exchange), 2**256-1);

        console.log(
            "Create a put option."
        );

        vm.prank(creator_and_buyer);
        uint256 id = exchange.requestOption(index, _type, _strike, _expiry);

        console.log(
            "Create a put option offer."
        );

        // 1 eth
        uint256 premium = 1000000000000000000;
        
        vm.prank(seller);
        weth.approve(address(exchange), _strike);

        vm.prank(seller);
        bool fill = exchange.createOffer(id, premium);

        require(fill);

        console.log(
            "Accept a put option offer."
        );

        vm.prank(creator_and_buyer);
        bool accept = exchange.acceptOption(id);

        require(accept);

        console.log(
            "Travel in time and excerise option."
        );
        
        vm.warp(_expiry + 1);

        console.log(weth.balanceOf(address(exchange)));
        
        vm.prank(creator_and_buyer);
        bool excerise = exchange.exerciseOption(id);

        require(excerise);

    }


}
