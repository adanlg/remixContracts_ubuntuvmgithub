pragma solidity ^0.8.0;

contract HashFunction {
    // Function to hash a string input
    function hashString(string memory input) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(input));
    }
}
