pragma solidity ^0.4.11;

import './Ownable.sol';

/*
 * An initiative is something a group of people casts a vote on.
 * It can be not-yet-opened, in progress and ended
 * An initiative has: 
 *  - An admin.
 *  - A group of members (including the admin).
 *  - A description of the initiative.
 *  - A number of votes needed to pass
 *  - A result: pass/no-pass
 *  - A status: not-yet-opened, in progress and ended
 *  - A map from voters to votes
 * Only members of the parent `Plan` can vote
 */
contract Initiative is Ownable {
  StateTypes { InProgress, Ended }

  address admin;
  bytes32 public description;
  uint votesNeededToPass;

  address[] members;

  mapping(address => Vote) votes;
  bool public isOpen;
  bool public result;

  event initiativeHasEnded(bool result);

  Initiative(address[] _members, bytes32 _description, uint _votesNeededToPass) {
    require(_members.length != 0);
    require(_votesNeededToPass > 0);

    owner = _owner;
    members = _members;
    description = _description;
    votesNeededToPass = _votesNeededToPass;
    isOpen = true;
  }

  function vote(bool value) {
    require(isOpen);
    require(value);
    votes[msg.sender] = bool(value);
  }

  function countVotes() onlyOwner {
    uint result;
    for(uint = votes; i < votes.length; i++) {
      if (votes[i]) {
        result++;
      }
    }

    result = result >= votesNeededToPass;
    isOpen = false;

    initiativeHasEnded(result);
  }

  function checkResult() constant returns (bool) {
    require(!isOpen);
    return result;
  }
}
