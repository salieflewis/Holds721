// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/Holds721.sol";
import "../src/ERC721DropMinterInterface.sol";
import "solmate/tokens/ERC721.sol";

contract DeployScript is Script {
    // ===== CONSTRUCTOR INPUTS =====
    ERC721 public ADDRESS_OF_721 = ERC721(0xCa21d4228cDCc68D4e23807E5e370C07577Dd152); // Zorb contract address
    ERC721 public GOERLI_ADDRESS_OF_721 = ERC721(0x34FE32e6442D14d923953a537B8163365630b5A7); // Test curation pass address

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);
        new Holds721(GOERLI_ADDRESS_OF_721);
        vm.stopBroadcast();
    }
}
