// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Es ⏰ de crear tu SM
contract Fundraiser{
  event FundEnded();
  event Donation(address donator, uint amount, uint id);
  event FundCreated(address creator, uint goal, uint id);
  event RemoveDonation(address donator, uint amount, uint id);

   //mapping donatedFunds(mapping(address donator => uint amount);
    struct campaign {
       uint256 goal;
       address creator;
       uint256 id;
        bool ended;
        bool closed; 
   }
    struct donation {
       address donator;
       uint256 amount;
       uint256 id;
   }
   donation[] public donations;
   campaign[] public campaigns;

   mapping(uint id => uint amount)amounts;


    function createFunding(uint _goal) public {
        address creator = msg.sender;
        uint256 goal = _goal;
        uint256 id = campaigns.length;
        campaign memory newCampaign = campaign({
            goal: goal,
            creator: creator,
            id: id,
            ended: false,
            closed: false
        });
        campaigns.push(newCampaign);        

        emit FundCreated(creator,goal,id);

    } 

    function fund(uint _fundingId) public payable {
        require(campaigns[_fundingId].ended ==false,"Terminado");
        require(campaigns[_fundingId].closed ==false,"Cerrado");
        require(_fundingId < campaigns.length, "ID incorrecto");
        uint256 amount = msg.value;
        address donator = msg.sender;
        uint256 id = _fundingId;
        require(campaigns[id].goal > amounts[id] + amount, "La meta de financiamiento ya se ha alcanzado");

        donation memory newDonation = donation(donator,amount,id);
        donations.push(newDonation);

        amounts[id] += amount;

        emit Donation(donator,amount,id);
    } 
    function removeFund(uint _fundingId) public {
        require(_fundingId < campaigns.length, "ID incorrecto");
        require(campaigns[_fundingId].ended ==false,"Terminado");
        require(campaigns[_fundingId].closed ==false,"Cerrado");
        uint256 refundAmount = 0;

        for (uint256 i = 0; i < donations.length; i++) {
            if (donations[i].donator == msg.sender && donations[i].id == _fundingId) {
                refundAmount += donations[i].amount;
                delete donations[i];
            }
        }

        require(refundAmount > 0, "No hay fondos que retirar");

        amounts[_fundingId] -= refundAmount;
        payable(msg.sender).transfer(refundAmount);

        emit RemoveDonation(msg.sender, refundAmount, _fundingId);
}
    function endFund(uint _fundingId) public{
        require(campaigns[_fundingId].closed ==false,"Cerrado");
        require(msg.sender == campaigns[_fundingId].creator);
        require(campaigns[_fundingId].ended ==false,"Terminado");

        campaigns[_fundingId].ended = true;

        emit FundEnded();
    }



}
