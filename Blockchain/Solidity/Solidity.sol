// Contracts with owners
// https://docs.openzeppelin.com/contracts/4.x/access-control
// contracts/MyContract.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

// Ownable Source
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.7.3/contracts/access/Ownable.sol
// Context Source
// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol

contract MyContract is Ownable {
    function normalThing() public {
        // anyone can call this normalThing()
    }

    function specialThing() public onlyOwner {
        // only the owner can call specialThing()!
    }
}

// WARNING: TONS OF CARE IS NEEDED
// Destroyable
// https://github.com/ConsenSysMesh/openzeppelin-solidity/blob/master/contracts/lifecycle/Destructible.sol
contract Destructible is Ownable {
    constructor() public payable {}

    /**
     * @dev Transfers the current balance to the owner and terminates the contract.
     */
    function destroy() public onlyOwner {
        selfdestruct(owner);
    }

    function destroyAndSend(address _recipient) public onlyOwner {
        selfdestruct(_recipient);
    }
}
