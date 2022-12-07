// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import {Clones} from "openzeppelin-contracts/proxy/Clones.sol";
import {OwnableUpgradeable} from "openzeppelin-contracts-upgradeable/access/OwnableUpgradeable.sol";

import {Holds721} from "./Holds721.sol";

contract Holds721Factory is OwnableUpgradeable {
    // ===== EVENTS =====
    /**
     * @notice Emitted when the implementation address of Holds721 is updated.
     */
    event Holds721ImplUpdated(address holds721impl);
    /**
     * @notice Emitted when a new proxy is created from this factory.
     */
    event Holds721Created(address holds721);

    // ===== CONSTANTS =====
    /**
     * @notice The implementation address of Holds721
     */
    address public holds721impl;

    // ===== CONSTRUCTOR =====
    constructor(address _holds721impl) {
        __Ownable_init();
        holds721impl = _holds721impl;
    }

    // ===== FUNCTIONS =====
    /**
     * @notice Updates the implementation address of Holds721
     */
    function updateHolds721Impl(address _newHolds721Impl) external onlyOwner {
        holds721impl = _newHolds721Impl;
        emit Holds721ImplUpdated(holds721impl);
    }

    /**
     * @notice Creates a proxy of Holds721
     */
    function createHolds721(bytes32 salt, address addressOf721) external returns (address holds721) {
        // Create Holds721 proxy
        holds721 = payable(Clones.cloneDeterministic(holds721impl, _generateSalt(msg.sender, salt)));
        // Initialize the proxy
        Holds721(holds721).initialize(addressOf721);
        emit Holds721Created(holds721);
    }

    /**
     * @dev Generates a salt by encoding the creator address and client generated salt.
     */
    function _generateSalt(address creator, bytes32 salt) private pure returns (bytes32 result) {
        return keccak256(abi.encode(creator, salt));
    }
}
