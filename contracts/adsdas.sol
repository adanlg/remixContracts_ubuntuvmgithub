// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GasConsumingFunction {
    function consumeGas() public {
        // Ejecutar un bucle con muchas iteraciones para consumir gas.
        for (uint256 i = 0; i < 100000; i++) {
            // Operación costosa para el gas.
            bytes32 randomHash = keccak256(abi.encodePacked(block.timestamp, msg.sender, i));
        }
    }
}
