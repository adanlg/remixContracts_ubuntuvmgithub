
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/access/Ownable.sol";


interface Itoken {
    function mint(address to, uint256 amount) external returns (bool);

    function burn(address _from, uint256 amount) external;

    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint amount);
    event Approval(address indexed owner, address indexed spender, uint amount);
}

contract DEX_CTF is Ownable {
    Itoken public tokenA;
    Itoken public tokenB;
    string private flag;
    uint256 public proportion;
    address public liquidityProvider = address(0);
    bool public swap;
    uint256 public liquidityA = tokenA.balanceOf(address(this));
    uint256 public liquidityB = tokenB.balanceOf(address(this));



    constructor(address _tokenA, address _tokenB, string memory _flag) {
        tokenA = Itoken(_tokenA);
        tokenB = Itoken(_tokenB);
        flag = _flag;
    }

    function createPool(uint256 amountA, uint256 amountB) public onlyOwner {
        tokenA.mint(msg.sender, amountA);
        tokenB.mint(msg.sender, amountB);

    }



    function swapAforB() public  {
        require(tokenA.balanceOf(msg.sender)>= 0, "Insufficient tokenA balance");
        require(tokenA.balanceOf(address(this)) > 0, "Insufficient tokenA balance in the contract");
        require(tokenB.balanceOf(address(this)) > 0, "Insufficient tokenB balance in the contract");

        tokenA.transferFrom(msg.sender, address(this), 10);
        uint256 newTokenB =  proportion / tokenA.balanceOf(address(this));
        uint256 tokensBleft = tokenB.balanceOf(address(this)) - newTokenB;
        uint256 tokensSwapped = (tokensBleft * 9) / 10; 
        uint256 commission = (tokensBleft * 1) / 10;   
        tokenB.transferFrom(address(this),msg.sender, tokensSwapped);
        tokenB.transferFrom(address(this),liquidityProvider,commission);
        swap = true;
     
    }
    function swapBforA() public {
        require(tokenB.balanceOf(msg.sender) >= 10, "Insufficient tokenB balance");
        require(tokenB.balanceOf(address(this)) > 99, "Insufficient tokenB balance in the contract");
        require(tokenA.balanceOf(address(this)) > 99, "Insufficient tokenA balance in the contract");
        
        tokenB.transferFrom(msg.sender, address(this), 10);
        
        uint256 newTokenA = proportion / tokenB.balanceOf(address(this));
        uint256 tokensAleft = tokenA.balanceOf(address(this)) - newTokenA;
        uint256 tokensSwapped = (tokensAleft * 9) / 10; 
        uint256 commission = (tokensAleft * 1) / 10;  
        
        tokenA.transferFrom(address(this), msg.sender, tokensSwapped);
        tokenA.transferFrom(address(this), liquidityProvider, commission);
        swap = true;
    }


    function getFlag() public view returns(string memory){
        require(swap == true,"No has realizado nigun swap");
        require(tokenB.balanceOf(address(this)) > 0 && tokenA.balanceOf(address(this)) > 0, "Both token balances must be greater than 0");
        require(tokenB.balanceOf(address(this)) == tokenA.balanceOf(address(this)), "Token balances must be equal");

        return flag;
    }



}

/*
    // Function to provide liquidity
    function provideLiquidity(uint256 amountA, uint256 amountB) external {
        require(amountA >= 100 && amountB >= 100, "Amounts must be greater than 0");
        require(
            tokenA.transferFrom(msg.sender, address(this), amountA) &&
                tokenB.transferFrom(msg.sender, address(this), amountB),
            "Transfer of tokens failed"
        );
        if(liquidityProvider == address(0)){
            liquidityProvider=msg.sender;
        } else{
            revert("Liquidity provider already exist");
        }
        proportion = tokenA.balanceOf(address(this)) * tokenB.balanceOf(address(this));
    }
    */