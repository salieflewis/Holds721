// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/Holds721Factory.sol";
import "../src/Holds721.sol";

import {TestConfig} from "./TestConfig.sol";

contract Holds721FactoryTest is TestConfig {
    // address holds721Impl = makeAddr("holds721Impl");
    // address creator = makeAddr("creator");
    // bytes32 salt;

    // Test Holds721Factory deploys
    function test_holds721FactoryDeploys() public {
        // Deploy Holds721 implementation
        // Holds721 holds721impl = new Holds721();
        // Initialize Holds721
        // holds721impl.initialize(address(0));
        // Deploy Holds721Factory implementation
        // Holds721Factory holds721Factory = new Holds721Factory(address(holds721impl));

        // Assert that Holds721Factory is not deployed at the zero address
        // assert(address(holds721Factory) != address(0));
        // Assert that the initialied addressOf721 is the provided addressOf721
        // assertEq((holds721impl.addressOf721()), address(addressOf721));
    }

    // function test_updateHolds721Impl() public {}

    // function test_createHolds721() public {
    //     bytes32 salt = keccak256(bytes("randomString"));
    // }
}

// test who owns a holds721 proxy
