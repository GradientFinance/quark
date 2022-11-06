// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

import {console} from "forge-std/console.sol";
import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";

import {Utils} from "./utils/Utils.sol";
import {LibRLP} from "./utils/LibRLP.sol";

import "../src/IndexFactory.sol";
import "../src/Exchange.sol";
import "./mocks/WETH.sol";

contract BaseSetup is Test {
    Utils internal utils;

    address internal deployer;
    address internal creator_and_buyer;
    address internal seller;

    address[] internal _denominations; 
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

        vm.prank(creator_and_buyer);
        weth = new WETH();

        vm.prank(creator_and_buyer);
        weth.transfer(seller, 100000000000000000000);

        uint256 nonce = vm.getNonce(deployer);

        // Precomputed contract addresses, based on contract deploy nonces.
        address indexfactory_address = LibRLP.computeAddress(deployer, nonce);
        address exchange_address = LibRLP.computeAddress(deployer, nonce + 1);

        _denominations = [
            // WETH (goerli)
            0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6,
            // USDC (goerli)
            0x07865c6E87B9F70255377e024ace6630C1Eaa37F,
            // WETH (foundry)
            address(weth)
        ];

        address _uma = 0xA5B9d8a0B0Fa04Ba71BDD68069661ED5C0848884;

        vm.prank(deployer);
        indexfactory = new IndexFactory(_denominations, _uma, exchange_address);
        
        require(address(indexfactory) == indexfactory_address);

        vm.prank(deployer);
        exchange = new Exchange(address(indexfactory));

        require(address(exchange) == exchange_address);
    }
}

contract TestFactory is BaseSetup {
    int256[] coefficients = [int256(50), -63, 77, -28, 90];
    int256 intercept = 242242;
    uint8 accuracy = 85;
    string[] attributes = ['Aquamarine', 'Prom Dress', 'Crazy', 'Black', 'Bored'];
    address collection = 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D;
    string name = 'BAYC Index 1'; 
    uint256 manipulation = 10;
    bool opensource = true;

    function setUp() public virtual override {
        BaseSetup.setUp();
    }

    function testCreateIndex() public {
        console.log(
            "Create a BAYC index."
        );

        vm.prank(creator_and_buyer);

        address index = indexfactory.createIndex(
            coefficients,
            intercept,
            accuracy,
            attributes,
            collection,
            address(weth),  // denomination
            name,
            manipulation,
            opensource
        );

        assertTrue(indexfactory.isValid(index));
        assertEq(indexfactory.getIndices()[0], index);
    }
}


contract TestExchange is BaseSetup {
    // Index Parameters
    int256[] coefficients = [int256(50), -63, 77, -28, 90];
    int256 intercept = 242242;
    uint8 accuracy = 85;
    string[] attributes = ['Aquamarine', 'Prom Dress', 'Crazy', 'Black', 'Bored'];
    address collection = 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D;
    string name = 'BAYC Index 1'; 
    uint256 manipulation = 10;
    bool opensource = true;

    // Option Parameters
    bool _type = true;
    uint256 _strike = 15000000000000000000;  // 15 eth
    uint256 _expiry = 1669814557;

    function setUp() public virtual override {
        BaseSetup.setUp();
    }

    function testRequestOffer() public {
        console.log(
            "Create a request for a put option."
        );

        vm.prank(creator_and_buyer);

        address index = indexfactory.createIndex(
            coefficients,
            intercept,
            accuracy,
            attributes,
            collection,
            address(weth),  // denomination
            name,
            manipulation,
            opensource
        );

        assertTrue(indexfactory.isValid(index));
        assertEq(indexfactory.getIndices()[0], index);

        vm.prank(creator_and_buyer);
        weth.approve(address(exchange), 2**256-1);

        vm.prank(creator_and_buyer);
        uint256 id = exchange.requestOption(index, _type, _strike, _expiry);

        assertEq(exchange.getOptions(creator_and_buyer)[0], id);
    }

    function testCreateOffer() public {
        console.log(
            "Create a request for a put option and give it an offer."
        );

        vm.prank(creator_and_buyer);

        address index = indexfactory.createIndex(
            coefficients,
            intercept,
            accuracy,
            attributes,
            collection,
            address(weth),  // denomination
            name,
            manipulation,
            opensource
        );

        assertTrue(indexfactory.isValid(index));
        assertEq(indexfactory.getIndices()[0], index);

        vm.prank(creator_and_buyer);
        weth.approve(address(exchange), 2**256-1);

        vm.prank(creator_and_buyer);
        uint256 id = exchange.requestOption(index, _type, _strike, _expiry);

        assertEq(exchange.getOptions(creator_and_buyer)[0], id);

        uint256 premium = 1000000000000000000;  // 1 eth
        
        vm.prank(seller);
        weth.approve(address(exchange), _strike);

        vm.prank(seller);
        bool fill = exchange.createOffer(id, premium);

        assertTrue(fill);
    }

    function testAcceptOffer() public {
        console.log(
            "Create a request for a put option, give it an offer and accept it."
        );

        vm.prank(creator_and_buyer);

        address index = indexfactory.createIndex(
            coefficients,
            intercept,
            accuracy,
            attributes,
            collection,
            address(weth),  // denomination
            name,
            manipulation,
            opensource
        );

        assertTrue(indexfactory.isValid(index));
        assertEq(indexfactory.getIndices()[0], index);

        vm.prank(creator_and_buyer);
        weth.approve(address(exchange), 2**256-1);

        vm.prank(creator_and_buyer);
        uint256 id = exchange.requestOption(index, _type, _strike, _expiry);

        assertEq(exchange.getOptions(creator_and_buyer)[0], id);

        uint256 premium = 1000000000000000000;  // 1 eth
        
        vm.prank(seller);
        weth.approve(address(exchange), _strike);

        vm.prank(seller);
        bool fill = exchange.createOffer(id, premium);

        assertTrue(fill);

        // // Accept offer to create option NFT.
        uint256 seller_balance = weth.balanceOf(seller) - _strike + premium;
        uint256 buyer_balance = weth.balanceOf(creator_and_buyer) - premium;

        vm.prank(creator_and_buyer);
        bool accept = exchange.acceptOption(id);

        assertTrue(accept);

        assertEq(seller_balance, weth.balanceOf(seller));
        assertEq(buyer_balance, weth.balanceOf(creator_and_buyer));

        assertEq(exchange.ownerOf(id), creator_and_buyer);
    }

    function testExerciseOption() public {
        console.log(
            "Create a request for a put option, give it an offer, accept it and excerise it."
        );

        vm.prank(creator_and_buyer);

        address index = indexfactory.createIndex(
            coefficients,
            intercept,
            accuracy,
            attributes,
            collection,
            address(weth),  // denomination
            name,
            manipulation,
            opensource
        );

        assertTrue(indexfactory.isValid(index));
        assertEq(indexfactory.getIndices()[0], index);

        vm.prank(creator_and_buyer);
        weth.approve(address(exchange), 2**256-1);

        vm.prank(creator_and_buyer);
        uint256 id = exchange.requestOption(index, _type, _strike, _expiry);

        assertEq(exchange.getOptions(creator_and_buyer)[0], id);

        uint256 premium = 1000000000000000000;  // 1 eth
        
        vm.prank(seller);
        weth.approve(address(exchange), _strike);

        vm.prank(seller);
        bool fill = exchange.createOffer(id, premium);

        assertTrue(fill);

        // Accept offer to create option NFT.
        uint256 seller_balance = weth.balanceOf(seller) - _strike + premium;
        uint256 buyer_balance = weth.balanceOf(creator_and_buyer) - premium;

        vm.prank(creator_and_buyer);
        bool accept = exchange.acceptOption(id);

        assertTrue(accept);

        assertEq(seller_balance, weth.balanceOf(seller));
        assertEq(buyer_balance, weth.balanceOf(creator_and_buyer));

        assertEq(exchange.ownerOf(id), creator_and_buyer);

        /////

        vm.warp(_expiry + 1);
    
        uint256 price = 10000000000000000000;  // 10 eth

        seller_balance = weth.balanceOf(seller) + (_strike - (_strike - price));
        buyer_balance = weth.balanceOf(creator_and_buyer) + (_strike - price);

        vm.prank(creator_and_buyer);
        bool excerise = exchange.exerciseOption(id);

        assertTrue(excerise);

        assertEq(seller_balance, weth.balanceOf(seller));
        assertEq(buyer_balance, weth.balanceOf(creator_and_buyer));
    }

}