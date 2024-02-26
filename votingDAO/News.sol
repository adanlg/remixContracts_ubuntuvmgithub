// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IToken {

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

    event Approval(address indexed owner, address indexed spender, uint amount);
}


contract News is Ownable {
    IToken public tokenDAO;
    uint256 public priceUploadNew;
    uint256 public articleIdCounter;
    

    struct Article {
        address writer;
        string metadata;
        uint256 id;
        uint256 weightedAverage;
         // New field to store weighted average
    }

    Article[] public articles;
    mapping(uint256 => uint256) public ratings;
    mapping(address => mapping(uint256 => bool)) public hasRatedArticle;
    mapping(uint256 => uint256) public ratingCount; 
    mapping(address => uint256) public ratedTimes;
    mapping(address => uint256) public timesUsed;
    constructor(address _contract, uint256 _priceUploadNew) {
        tokenDAO = IToken(_contract);
        priceUploadNew = _priceUploadNew;
        articleIdCounter = 0;
    }

    function updatePrice(uint256 _newPriceUpload) public onlyOwner {
        priceUploadNew = _newPriceUpload;
    }

    function createArticle(string memory _metadata) public {
        require(tokenDAO.transferFrom(msg.sender, address(this), priceUploadNew), "Failed to transfer tokens");
        articleIdCounter++;
        articles.push(Article({
            writer: msg.sender,
            metadata: _metadata,
            id: articleIdCounter,
            weightedAverage: 0 // Initialize weightedAverage to 0 when creating a new article
        }));
    }

    function rateArticle(uint256 _articleId, uint256 _rating) public {
        require(_articleId > 0 && _articleId <= articleIdCounter, "ID de articulo no valido");
        require(_rating >= 1 && _rating <= 5, "Calificacion no valida; debe estar entre 1 y 5");
        require(!hasRatedArticle[msg.sender][_articleId], "Ya has calificado este articulo");
        require(tokenDAO.balanceOf(msg.sender) > 0, "Saldo de tokens insuficiente");

        // Calculate the user's rating weight
        uint256 userBalance = tokenDAO.balanceOf(msg.sender);
        uint256 totalSupply = tokenDAO.totalSupply();
        uint256 userWeight = (userBalance * 1000000000000000000000000) / totalSupply; // Ponderación en porcentaje

        // Calculate the weighted rating of the user
        uint256 weightedRating = (_rating * userWeight) / 100;

        // Update the ratings and ratingCount for the article
        ratings[_articleId] += weightedRating;
        ratingCount[_articleId]++;

        // Calculate the new weighted average for the article
        uint256 totalWeightedRatings = ratings[_articleId];
        uint256 totalRatingsCount = ratingCount[_articleId];
        uint256 weightedAverage = totalWeightedRatings / totalRatingsCount;

        // Update the weightedAverage for the article
        articles[_articleId - 1].weightedAverage = weightedAverage;

        // Mark that the user has rated this article
        hasRatedArticle[msg.sender][_articleId] = true;
    }

    function pay(address _to , uint256 _amount) public onlyOwner{
        tokenDAO.transfer(_to, _amount);

    }
    function checkBalance() public view returns(uint256){
        uint256 quantity =tokenDAO.balanceOf(address(this));
        return(quantity);
    }
}
