// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@openzepplin/contracts/token/ERC721/ERC721.sol";

// address public ZorbAddress = 0x34fe32e6442d14d923953a537b8163365630b5a7;

error ErrorTransferringFunds();
error MintingError();

contract MyMinter {

    event MintedFromMyMinter(address target, address to, uint256);

    function purchase(address payable target, uint256 quantity) public {
        address to = msg.sender;


        try IERC721Drop(target).adminMint(to, quantity) {
            if (msg.value > 0) {
                // Send value to root contract
                (bool success, ) = payable(address(target)).call{
                    value: msg.value
                }("");
                if (!success) {
                    revert.ErrorTransferringFunds();
                }
            }
           emit MintedFromMyMinter(target, to, quantity);
        } catch {
            revert MintingError();
    }
}

