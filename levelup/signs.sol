pragma solidity 0.8.17;

contract MyContract {
    address public owner;
    uint public blockNumber;

    modifier onlyOwner {
        require(msg.sender == owner, "No eres el propietario");
        _;
    }

    // The setSelector() function calculates and returns the function selector for the add() function.
    function setSelector(string memory _hola) public pure returns (bytes4) {
        // Calculate the Keccak-256 hash of the add() function's signature.
        bytes4 selector = bytes4(keccak256(abi.encodePacked(_hola)));
        // Return the function selector.
        return selector;
    }

    function jump() public onlyOwner {
        blockNumber = block.number;
    }

    function loveisintheair() public onlyOwner {
        blockNumber = block.number;
    }

    function gameover() public onlyOwner {
        blockNumber = block.number;
    }

    function ideaslocas() public onlyOwner {
        blockNumber = block.number;
    }

    function team() public onlyOwner {
        blockNumber = block.number;
    }
}
//jump() 0x8f6c696b
//love 0xfd459d96
//game 0x2d175f11
//ideas 0x04867e32
//team 0x85f2aef2