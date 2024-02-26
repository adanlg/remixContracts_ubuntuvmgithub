// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract TimestampManp {
    uint public pastBlockTime;

    constructor() payable {}

    function spin() external payable {
        require(msg.value == 4 ether); 
        require(block.timestamp != pastBlockTime); 

        pastBlockTime = block.timestamp;

        if (block.timestamp % 3 == 0) {
            (bool sent, ) = msg.sender.call{value: address(this).balance}("");
            require(sent, "Failed to send Ether");
        }
    }
}