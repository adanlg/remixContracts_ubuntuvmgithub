// SPDX-License-Identifier: MIT

/*
© 2023 Telefónica Digital España S.L. , All rights reserved
*/

pragma solidity 0.8.18;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./base.sol";
import "./nft.sol";

contract Pay is Ownable {
    event Payed(address from, uint256 level);

    event Deployed(address payer, uint256 level, address contractAddress);

    //address => {level => amount}
    mapping(address => mapping(uint256 => uint256)) private players;
    mapping(address => mapping(uint256 => address)) private contracts;
    uint256 public cost = 200000000000000; // WEIs
    Base public base;
    NFT_Level_Up public nft;

    constructor(Base _base, NFT_Level_Up _nft) {
        base = _base;
        nft = _nft;
    }

    function payDeploy(uint256 _level) public payable {
        require(base.existPlayer(msg.sender), "No eres un jugador");
        if (players[msg.sender][_level] == 0) {
            require(msg.value >= cost, "No has pagado lo suficiente");
            players[msg.sender][_level] = msg.value;
            emit Payed(msg.sender, _level);
        } else if (contracts[msg.sender][_level] == address(0)) {
            emit Payed(msg.sender, _level);
            revert("Vamos a intentar desplegar este nivel de nuevo");
        } else {
            emit Deployed(msg.sender, _level, contracts[msg.sender][_level]);
            revert("Ya has desplegado este nivel");
        }
    }

    function notify(
        address _address,
        uint256 _level,
        address _contract
    ) public onlyOwner {
        require(players[_address][_level] != 0, "No se ha desplegado");
        contracts[_address][_level] = _contract;
        emit Deployed(_address, _level, _contract);
    }

    function giveMeMoney() public onlyOwner {
        (bool sent, ) = this.owner().call{value: address(this).balance}("");
        require(sent, "Fallo al enviar cantidad");
    }

    function getContract(uint256 _level) public view returns (address) {
        require(base.existPlayer(msg.sender), "No eres un jugador");
        require(
            contracts[msg.sender][_level] != address(0),
            "No se ha desplegado"
        );
        return contracts[msg.sender][_level];
    }
}
