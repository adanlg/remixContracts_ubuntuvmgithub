// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;




    contract FunctionExecutor {

        bytes public hola;
        function executeFunction(string memory data) public returns (bytes memory) {
            hola = abi.encode("guess(uint256)", 1);
            bytes memory resultBytes = bytes(data);
            return hola;
        }
        function getEncodeWithSelector(uint256 numero) pure public returns(bytes memory){
        bytes4 selector = bytes4(keccak256(bytes("guess(uint256)"))); 
        bytes memory data = abi.encodeWithSelector(selector,numero );
        return data;
    }
    }
