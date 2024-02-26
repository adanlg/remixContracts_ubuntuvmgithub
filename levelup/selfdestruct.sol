// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SelfDestructContract {

    constructor(address payable _recipient) payable {
        selfdestruct(_recipient);
    }

}
