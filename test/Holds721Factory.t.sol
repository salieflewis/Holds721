// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "../src/Holds721Factory.sol";
import "../src/Holds721.sol";

contract Holds721FactoryTest is Test {
    address holds721Impl = makeAddr("holds721Impl");
    address creator = makeAddr("creator");
    bytes32 salt;

    function setUp() public {}

    function test_updateHolds721Impl() public {}

    // function test_createHolds721() public {
    //     bytes32 salt = keccak256(bytes("randomString"));
    // }
}
