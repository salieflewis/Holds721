// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import {ERC721DropMinterInterface} from "./ERC721DropMinterInterface.sol";
import {IERC721Upgradeable} from "openzeppelin-contracts-upgradeable/token/ERC721/IERC721Upgradeable.sol";
import {ReentrancyGuardUpgradeable} from "openzeppelin-contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import {OwnableUpgradeable} from "openzeppelin-contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Holds721 is OwnableUpgradeable, ReentrancyGuardUpgradeable {
    // ===== ERRORS =====
    error NotAHolder();
    error MinterNotAuthorized();
    error TransferUnsuccessful();

    // ===== CONSTANTS =====
    bytes32 public immutable MINTER_ROLE = keccak256("MINTER");

    // ===== PUBLIC VARIABLES =====
    address public addressOf721;

    // ===== INITIALIZER =====
    function initialize(address _addressOf721) external initializer {
        // Initialize contract ownership
        __Ownable_init();
        __ReentrancyGuard_init();

        // Initialize the NFT address
        addressOf721 = _addressOf721;
    }

    // ===== FUNCTIONS =====
    function mintWith721(address zoraDrop, address mintRecipient, uint256 quantity) external payable nonReentrant {
        // Check if Holds721 has MINTER_ROLE on target zoraDrop contract
        if (!ERC721DropMinterInterface(zoraDrop).hasRole(MINTER_ROLE, address(this))) {
            revert MinterNotAuthorized();
        }

        // If msg.sender does not hold the specified NFT, they cannot mint
        if (IERC721Upgradeable(addressOf721).balanceOf(msg.sender) == 0) {
            revert NotAHolder();
        }

        // If msg.sender holds the specified NFT, they can mint for free
        ERC721DropMinterInterface(zoraDrop).adminMint(mintRecipient, quantity);

        // Transfer funds to zora drop contract
        (bool success,) = zoraDrop.call{value: msg.value}("");
        if (!success) {
            revert TransferUnsuccessful();
        }
    }
}
