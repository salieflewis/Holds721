// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/token/ERC721/ERC721.sol";
import "zorb/ZorbNFT.sol";
import "./ERC721DropMinterInterface.sol";

contract ZorbMinter  {
    // ===== ERRORS =====

    // error ZorbsUnapproved();
    // error NotEnoughZorbs(); dont actually need this -- if not enough zorbs, the mint full price

    /// @notice Action is unable to complete because msg.value is incorrect
    error WrongPrice();

    error MinterNotAuthorized();

    // ===== CONSTANTS =====
    bytes32 public immutable MINTER_ROLE = keccak256("MINTER");
    ZorbNFT public immutable ZORB_ADDRESS = ZorbNFT(0xCa21d4228cDCc68D4e23807E5e370C07577Dd152);

    // ===== PUBLIC VARIABLES =====
    uint256 public priceInZorbs;
    uint256 public priceInEth;
    // uint256 public amountOfZorbsHeld;
    uint256[] public specificZorbsHeld;
    uint256 public zorbSupply = ZORB_ADDRESS.totalSupply();
    

    // ===== CONSTRUCTOR =====
    constructor(uint256 _priceInZorbs, uint256 _priceInEth) {
        priceInZorbs = _priceInZorbs;
        priceInEth = _priceInEth;
    }

    function mintWithZorbs(
        address zoraDrop, 
        address mintRecipient, 
        uint256 quaantity
    ) external payable {

        // check if CustomPricingMinter contract has MINTER_ROLE on target ZORA Drop contract
        if (
            !ERC721DropMinterInterface(zoraDrop).hasRole(
                MINTER_ROLE,
                address(this)
            )
        ) {
            revert MinterNotAuthorized();
        }

        // if msg.sender doesn't have enough Zorbs, they have to pay priceInEth
        if (priceInZorbs > ZORB_ADDRESS.balanceOf(msg.sender)) {            

            if (msg.value != priceInEth) {
                revert WrongPrice();
            }

            ERC721DropMinterInterface(zoraDrop).adminMint(mintRecipient, quantity);

            // Transfer funds to zora drop contract
            (bool success, ) = zoraDrop.call{value: msg.value}("");
            if (!success) {
                revert TransferNotSuccessful();
            }

        }


        // if msg.sender has enough zorbs, they can mint for free
        ERC721DropMinterInterface(zoraDrop).adminMint(mintRecipient, quantity);

        // the zorb minter wont actually transfer zorbs out, its just a check
        //      to see if the person has the zorbs. if they do, they mint for free

        // if (!ZORB_ADDRESS.isApprovedForAll(msg.sender, address(this))) {
        //     // if user has not approved this minter, approve it

        //     ZORB_ADDRESS.setApprovalForAll(address(this), true);
        // }

        // for (uint256 index; index < zorbSupply; index++) {
        //     if (index.ownerOf() == msg.sender) {
        //         specificZorbsHeld.push(index);
        //     }
        // }

        // for (uint256 index; index < priceInZorbs; index++) {
        //     ZORB_ADDRESS.transferFrom(msg.sender, address(this), specificZorbsHeld[index]);
        // }

        // Call Admin Mint
    }
}
