// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/token/ERC721/ERC721.sol";

contract ZorbMinter {
    // ===== ERRORS =====
    error ZorbsUnapproved();
    error NotEnoughZorbs();

    // ===== CONSTANTS =====
    bytes32 public immutable MINTER_ROLE = keccak256("MINTER");
    address public immutable ZORB_ADDRESS = 0xCa21d4228cDCc68D4e23807E5e370C07577Dd152;

    // ===== PUBLIC VARIABLES =====
    uint256 public priceInZorbs;
    uint256 public amountOfZorbsHeld;
    uint256[] public specificZorbsHeld;

    // ===== CONSTRUCTOR =====
    constructor(uint256 _priceInZorbs) {
        priceInZorbs = _priceInZorbs;
    }

    function mintWithZorbs() external payable {
        amountOfZorbsHeld = ZORB_ADDRESS.balanceOf(msg.sender);

        if (!amountOfZorbsHeld >= priceInZorbs) {
            revert NotEnoughZorbs();
        }

        (bool success,) = ZORB_ADDRESS.setApprovalForAll();

        if (!success) {
            revert ZorbsUnapproved();
        }

        for (uint256 index; index < ZORB_ADDRESS.totalSupply(); index++) {
            if (index.ownerOf() == msg.sender) {
                specificZorbsHeld.push(index);
            }
        }

        for (uint256 index; index < priceInZorbs; index++) {
            ZORB_ADDRESS.transferFrom(msg.sender, address(this), specificZorbsHeld[index]);
        }

        // Call Admin Mint
    }
}
