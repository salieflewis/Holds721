// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/ZorbMinter.sol";
import "../src/ERC721DropMinterInterface.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        ZorbMinter zM = new ZorbMinter("10", "1");
        vm.stopBroadcast();
    }
}
