
// SPDX-License-Identifier: AGPL-3.0-or-later

pragma solidity ^0.8.20;

contract functions4{

    uint8 private oil;
    uint8 private salt;
    uint8 private tomatoe;

    constructor(){
    }

    function addTomatoe(uint8 _stepNumber) public{
        require(_stepNumber > 0 && _stepNumber < 4, "Ingredient order must be between 1 and 3");
        tomatoe = _stepNumber;
    }
    
    function addSalt(uint8 _stepNumber) public {
        require(_stepNumber > 0 && _stepNumber < 4, "Ingredient order must be between 1 and 3");
        salt = _stepNumber;
    }

    function addOil(uint8 _stepNumber) public {
        require(_stepNumber > 0 && _stepNumber < 4, "Ingredient order must be between 1 and 3");
        oil = _stepNumber;
    }
    
}

