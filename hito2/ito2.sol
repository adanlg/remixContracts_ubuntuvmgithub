// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CampaignFactory {
    Campaign[] public deployedCampaigns;

    function createFunding(uint _goal) public {
        Campaign newCampaign = new Campaign(msg.sender, _goal);
        deployedCampaigns.push(newCampaign);
        emit CampaignCreated(msg.sender, newCampaign);
    }

    function getDeployedCampaigns() public view returns (Campaign[] memory) {
        return deployedCampaigns;
    }

    event CampaignCreated(address indexed creator, address campaignAddress);
}

contract Campaign {
    address public manager;
    uint public goal;
    uint public totalFunds;
    bool public ended;
    mapping(address => uint) public contributors;

    modifier onlyManager() {
        require(msg.sender == manager, "Only the manager can perform this action.");
        _;
    }

    constructor(address _manager, uint _goal) {
        manager = _manager;
        goal = _goal;
    }

    function fund() public payable {
        require(!ended, "Campaign has already ended.");
        require(msg.value > 0, "You must send some ether.");
        require(msg.value + totalFunds <= goal, "Funding goal reached or exceeded.");

        contributors[msg.sender] += msg.value;
        totalFunds += msg.value;

        emit Donation(msg.sender, msg.value, address(this));
    }

    function removeFund() public {
        require(!ended, "Campaign has already ended.");
        uint amountContributed = contributors[msg.sender];
        require(amountContributed > 0, "No funds to remove.");

        contributors[msg.sender] = 0;
        totalFunds -= amountContributed;

        payable(msg.sender).transfer(amountContributed);

        emit RemoveDonation(msg.sender, amountContributed, address(this));
    }

    function endFund() public onlyManager {
        require(!ended, "Campaign has already ended.");
        require(totalFunds >= goal, "Funding goal not reached yet.");

        ended = true;
        payable(manager).transfer(address(this).balance);

        emit FundEnded();
    }

    event FundEnded();
    event Donation(address indexed donator, uint amount, address indexed campaignAddress);
    event RemoveDonation(address indexed donator, uint amount, address indexed campaignAddress);
}
