// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "openzeppelin-contracts/token/ERC721/ERC721.sol";
import "zorb/ZorbNFT.sol";
import "./ERC721DropMinterInterface.sol";

contract ZorbMinter {
    // ===== ERRORS =====
    /// @notice Action is unable to complete because msg.value is incorrect
    error WrongPrice();
    error MinterNotAuthorized();
    error TransferUnsuccessful();

    // ===== CONSTANTS =====
    bytes32 public immutable MINTER_ROLE = keccak256("MINTER");
    ZorbNFT public immutable ZORB_ADDRESS = ZorbNFT(0xCa21d4228cDCc68D4e23807E5e370C07577Dd152);

    // ===== PUBLIC VARIABLES =====
    uint256 public priceInZorbs;
    uint256 public priceInEth;

    // ===== CONSTRUCTOR =====
    constructor(uint256 _priceInZorbs, uint256 _priceInEth) {
        priceInZorbs = _priceInZorbs;
        priceInEth = _priceInEth;
    }

    // ===== FUNCTIONS =====
    function mintWithZorbs(address zoraDrop, address mintRecipient, uint256 quantity) external payable {
        // Check if ZorbMinter.sol has MINTER_ROLE on target zoraDrop contract
        if (!ERC721DropMinterInterface(zoraDrop).hasRole(MINTER_ROLE, address(this))) {
            revert MinterNotAuthorized();
        }

        // If msg.sender doesn't have enough Zorbs, they have to pay priceInEth
        if (priceInZorbs > ZORB_ADDRESS.balanceOf(msg.sender)) {
            if (msg.value != priceInEth) {
                revert WrongPrice();
            }

            ERC721DropMinterInterface(zoraDrop).adminMint(mintRecipient, quantity);

            // Transfer funds to target zoraDrop contract
            (bool success,) = zoraDrop.call{value: msg.value}("");
            if (!success) {
                revert TransferUnsuccessful();
            }
        }

        // If msg.sender has enough Zorbs, they can mint for free
        ERC721DropMinterInterface(zoraDrop).adminMint(mintRecipient, quantity);
    }
}
