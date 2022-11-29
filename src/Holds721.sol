// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "./ERC721DropMinterInterface.sol";
import "solmate/tokens/ERC721.sol";
import "openzeppelin-contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "openzeppelin-contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Holds721 is OwnableUpgradeable, ReentrancyGuardUpgradeable {
    // ===== ERRORS =====
    error NotAHolder();
    error MinterNotAuthorized();
    error TransferUnsuccessful();

    // ===== CONSTANTS =====
    bytes32 public immutable MINTER_ROLE = keccak256("MINTER");

    // ===== PUBLIC VARIABLES =====
    ERC721 public ADDRESS_OF_721;

    // ===== INITIALIZER =====
    function initialize(ERC721 _ADDRESS_OF_721) external initializer {
        ADDRESS_OF_721 = _ADDRESS_OF_721;
        __Ownable_init();
        __ReentrancyGuard_init();
    }

    // ===== FUNCTIONS =====
    function mintWith721(address zoraDrop, address mintRecipient, uint256 quantity) external payable nonReentrant {
        // Check if Holds721.sol has MINTER_ROLE on target zoraDrop contract
        if (!ERC721DropMinterInterface(zoraDrop).hasRole(MINTER_ROLE, address(this))) {
            revert MinterNotAuthorized();
        }

        // If msg.sender does not hold the specified NFT, they cannot mint
        if (ADDRESS_OF_721.balanceOf(msg.sender) == 0) {
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
