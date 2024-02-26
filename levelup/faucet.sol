// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Faucet {
    address public owner;
    mapping(address => uint256) public withdrawals;
    mapping(address => bool) public specialPermissions;
    uint256 public constant MAX_WITHDRAWAL = 0.5 ether;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not the owner");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is the zero address");
        owner = newOwner;
    }

    receive() external payable {}

    function withdraw(uint withdraw_amount) public {
        if (!specialPermissions[msg.sender]) {
            require(withdrawals[msg.sender] + withdraw_amount <= MAX_WITHDRAWAL);
        }
        require(address(this).balance >= withdraw_amount);
        withdrawals[msg.sender] += withdraw_amount;
        payable(msg.sender).transfer(withdraw_amount);
    }

    function setSpecialPermission(address user, bool permission) public onlyOwner {
        specialPermissions[user] = permission;
    }
}
