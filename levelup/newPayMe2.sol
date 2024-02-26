// SPDX-License-Identifier: MIT

/*
© 2023 Telefónica Digital España S.L. , All rights reserved
*/

pragma solidity 0.8.18;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./base.sol";

contract Pay is Ownable {
    event Payed(address indexed from, uint256 indexed level);

    event Deployed(address indexed payer, uint256 indexed level, address  indexed contractAddress);

    event DeployedMany(address indexed payer, uint256 indexed level, uint256  indexed _contractsDeployed);


    //address => {level => amount}
    mapping(address => mapping(uint256 => uint256)) private playersPayed;
    mapping(address => mapping(uint256 => address[])) private contracts;
    uint256 public cost = 200000000000000; // WEIs
    Base public base;

    constructor(Base _base) {
        base = _base;
    }

    function payDeploy(uint256 _level) public payable {
        require(base.existPlayer(msg.sender), "No eres un jugador");
        if (playersPayed[msg.sender][_level] == 0) {
            require(msg.value >= cost, "No has pagado lo suficiente");
            playersPayed[msg.sender][_level] = msg.value;
            emit Payed(msg.sender, _level);
        } else {
            emit Deployed(msg.sender, _level, contracts[msg.sender][_level][contracts[msg.sender][_level].length - 1]);
            revert("Ya has desplegado este nivel");
        }
    }

    function notify(
        address _address,
        uint256 _level,
        address _contract
    ) public onlyOwner {
        require(playersPayed[_address][_level] != 0, "No se ha desplegado");
        contracts[_address][_level].push(_contract);
        uint256 _contractsDeployed = contracts[_address][_level].length;
        if (contracts[_address][_level].length == 1) {
            emit Deployed(_address, _level, _contract);
        } else {
            emit DeployedMany(_address, _level, _contractsDeployed);
        }
    }

    function giveMeMoney() public onlyOwner {
        (bool sent, ) = this.owner().call{value: address(this).balance}("");
        require(sent, "Fallo al enviar cantidad");
    }

    function getContract(uint256 _level) public view returns (address[] memory) {
        require(base.existPlayer(msg.sender), "No eres un jugador");
        return contracts[msg.sender][_level];
    }
}
