// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import "./ERC721DropMinterInterface.sol";

contract Holds721 {
    // ===== ERRORS =====
    /// @notice Action is unable to complete because msg.value is incorrect
    error NotAHolder();
    error MinterNotAuthorized();
    error TransferUnsuccessful();

    // ===== CONSTANTS =====
    bytes32 public immutable MINTER_ROLE = keccak256("MINTER");

    // ===== PUBLIC VARIABLES =====
    address public immutable ADDRESS_OF_721;

    // ===== CONSTRUCTOR =====
    constructor(address _ADDRESS_OF_721) {
        ADDRESS_OF_721 = _ADDRESS_OF_721;
    }

    // ===== FUNCTIONS =====
    function mintWith721(address zoraDrop, address mintRecipient, uint256 quantity) external payable {
        // Check if Holds721.sol has MINTER_ROLE on target zoraDrop contract
        if (!ERC721DropMinterInterface(zoraDrop).hasRole(MINTER_ROLE, address(this))) {
            revert MinterNotAuthorized();
        }

        // If msg.sender holds less than one Zorb, they cannot mint
        if (ADDRESS_OF_721.balanceOf(msg.sender) == 0) {
            revert NotAHolder();

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
