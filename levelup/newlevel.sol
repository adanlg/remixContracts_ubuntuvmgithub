// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenA is ERC20 {
    constructor() ERC20("TokenA", "TKA") {
    }
    function mintTokens() external payable {
        require(msg.value > 0, "Must send some ether");
        uint256 tokensToMint = msg.value * 1000; // 10 tokens per wei, adjust as needed
        _mint(msg.sender, tokensToMint);
    }
}

contract TokenB is ERC20 {
    constructor() ERC20("TokenB", "TKB") {
         // Mint 1,000,000 TKB tokens to the contract deployer
    }
    function mintTokens() external payable {
        require(msg.value > 0, "Must send some ether");
        uint256 tokensToMint = msg.value * 1000; // 10 tokens per wei, adjust as needed
        _mint(msg.sender, tokensToMint);
    }
}

