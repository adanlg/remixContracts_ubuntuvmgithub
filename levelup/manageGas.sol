
//SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

contract Gasolina{

    uint256 public iniciotx;
    uint256 public mitadtx;
    uint256 public mitad2tx;
    uint256 public gasfinal;

    string public ideasLocas;
    string private flag;

    bool calculado;

    constructor(string memory _flag){
        flag = _flag;
    }

    function calculame() public {
        calculado = true;
    }

    function gass() public {

        iniciotx=gasleft();
        require(gasleft() < 500000, "Demasiado gas");
        ideasLocas = " mola";
        mitadtx=gasleft();
        mitad2tx==gasleft();
        calculame();
        gasfinal=gasleft();
    }

    function getFlag(uint256 _guess) public view returns(string memory){
        require(gasfinal==_guess, "No has calculado bien");
        return flag;
    }

}
//	23519  A
// 434099   B
// 410580  A-B

// 23519
// 58842

//23497
//40705 + 23497