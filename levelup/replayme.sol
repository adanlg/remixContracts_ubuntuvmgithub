// SPDX-FileCopyrightText: © 2023 Telefónica Digital España S.L.

// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.9;

contract ReplayMe {

    string private flag;
    mapping(address => uint) public balances;
    uint public blockNumber;

    constructor(string memory _flag){
        flag = _flag;
    }
    function deposit(
        bytes32 _hashedMessage,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) public payable {
        address depositer = _verifyMessage(_hashedMessage, _v, _r, _s);
        require(depositer != address(0), "Not a valid signature");

        balances[depositer] += msg.value;
        blockNumber = block.number;
    }


    function extractFunds(
        bytes32 _hashedMessage,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) public payable {
        address extractor = _verifyMessage(_hashedMessage, _v, _r, _s);
        require(extractor != address(0), "Not a valid signature");

        uint amount = balances[extractor];
        balances[extractor] = 0;
        payable(extractor).transfer(amount);
    }

    function _verifyMessage(
        bytes32 _hashedMessage,
        uint8 _v,
        bytes32 _r,
        bytes32 _s
    ) public pure returns (address) {
        address signer = ecrecover(_hashedMessage, _v, _r, _s);
        return signer;
    }

    function getFlag() public view returns(string memory) {
        require(address(this).balance == 0, "Contract not exploited");
        return flag;
    }
}

//blocknumber 10081
//0x1aF87dD5E75E36BdedF8d72eA81ebf4282d67539  
// at address 0xf464ce922Dd4ED49DbfaFA3f50f19a45B39E67f5
// - _verifyMessage(bytes32,uint8,bytes32,bytes32)
//0x27e235e3: