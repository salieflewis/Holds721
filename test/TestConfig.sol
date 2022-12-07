// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Test} from "forge-std/Test.sol";

import {Holds721Factory} from "../src/Holds721Factory.sol";
import {Holds721} from "../src/Holds721.sol";

contract TestConfig is Test {
    address addressOf721 = makeAddr("addressOf721");

    Holds721 holds721impl;
    Holds721Factory holds721factory;

    function setUp() public {
        // Deploy Holds721 implementation
        holds721impl = new Holds721();

        // Initialize Holds721
        holds721impl.initialize(address(0));

        // Deploy Holds721Factory implementation
        Holds721Factory holds721Factory = new Holds721Factory(address(holds721impl));
    }
}
