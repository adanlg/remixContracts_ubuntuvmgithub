// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0; // Ensure to use a version greater than 0.5.0

contract FixedEther {
    uint public lockedAmount;
    address payable public owner;
    string public nothinToWitdraw;

    constructor() {
        owner = payable(msg.sender); // Convert msg.sender to address payable
    }

    function deposit() external payable {
        lockedAmount += msg.value;
    }

    function withdraw() external {
        require(msg.sender == owner, "Only the contract owner can withdraw the ether.");
        nothinToWitdraw = "blocked ether";

    }
}