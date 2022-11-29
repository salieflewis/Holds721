// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/Holds721.sol";
import "../src/Holds721Factory.sol";
import "../src/ERC721DropMinterInterface.sol";
import "solmate/tokens/ERC721.sol";

contract DeployScript is Script {

    uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

    function run() external {
        vm.startBroadcast(deployerPrivateKey);

        // Deploy Holds721 implementation
        Holds721 holds721impl = new Holds721();
        holds721impl.initialize(
             // 
        );

        // Deploy Holds721Factory
        Holds721Factory holds721Factory = new Holds721Factory(holds721impl);

        vm.stopBroadcast();
    }
}
