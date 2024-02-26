// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

contract mycontract{

    string public hola;

    constructor(string memory hello){
        hola = hello;
    }

    function decode(bytes memory decodeme)public pure returns (string memory) {
        return keccak256(abi.decodePacked(decodeme));


    }

}