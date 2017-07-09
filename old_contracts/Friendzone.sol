pragma solidity ^0.4.11;

import './Plan.sol';

/*
  An Ownable contract gives you the following functionality:
    * Ownable(): constructor that sets the address of the creator of the contract as the owner
    * modifier onlyOwner(): prevents function from running if it is called by anyone other than the owner
    * transfer(address newOwner) onlyOwner: Transfers ownership of the contract to the passed address.
*/
contract Friendzone {

  mapping(address => Plan[]) plans;

  function addPlan(bytes32 _planName, address[] _members) {
    require(_planName.length >= 0);

    zones.push(Plan(_members, _planName, _members));
  }

  function getOwnPlans() constant returns (Plan[] ownPlans) {
    return plans[msg.sender];
  }
}
