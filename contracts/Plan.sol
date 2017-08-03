pragma solidity ^0.4.11;

import './Initiative.sol';


contract Plan {
    address public owner;
    bytes32 public name;
    address[] members;
    mapping(address => bool) public membersMap;

    Initiative[] initiatives;
    mapping(address => Initiative) initiativesMap;

    event NewInitiativeAdded(address initiative);
    event NewMemberAdded(address newMember);
    event OwnershipTransferred(address newOwner);

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }

    modifier onlyMembers() {
        require(membersMap[msg.sender]);
        _;
    }

    function Plan(bytes32 _name, address[] _members) {
        owner = msg.sender;
        name = _name;
        members = _members;

        for (uint i = 0; i < members.length; i++) {
            membersMap[members[i]] = true;
        }

        // add owner as member even if he hasn't been part of the initial members collection
        if (!membersMap[owner]) {
            members.push(owner);
            membersMap[owner] = true;
        }
    }

    function transfer(address _newOwner) onlyOwner returns (bool) {
        // check that the new owner is a member
        require(membersMap[_newOwner]);

        owner = _newOwner;
        OwnershipTransferred(owner);

        return true;
    }

    function addMember(address newMember) onlyOwner {
        // make sure the new member is not an existing one
        require(!membersMap[newMember]);

        // add member
        members.push(newMember);
        membersMap[newMember] = true;

        // communicate that a new member has been added to the plan
        NewMemberAdded(newMember);
    }

    function addInitiative(uint256 votesNeededToPass, bytes32 name, bytes32 description) onlyMembers returns (Initiative newInitiativeAddress) {
        Initiative newInitiative = new Initiative(
            votesNeededToPass,
            name,
            description
        );
        initiatives.push(newInitiative);
        NewInitiativeAdded(newInitiative);
        return newInitiative;
    }

    function openVoting(address initiative) onlyOwner {
        initiativesMap[initiative].openVoting();
    }

    function closeVoting(address initiative) onlyOwner {
        initiativesMap[initiative].closeVoting();
    }

    function voteOnInitiative(address initiative, bool value) onlyMembers {
        initiativesMap[initiative].vote(msg.sender, value);
    }

    function changeInitiativeName(address initiative, bytes32 _name) onlyMembers {
        initiativesMap[initiative].changeName(_name);
    }

    function changeInitiativeDescription(address initiative, bytes32 _description) onlyMembers {
        initiativesMap[initiative].changeDescription(_description);
    }

    function getVoteForInitiative(address initiative) onlyMembers constant returns (bool) {
        return initiativesMap[initiative].voterValue(msg.sender);
    }

    function getInitiativeVotes(address initiative) onlyMembers constant returns (uint) {
        return initiativesMap[initiative].getPositiveVotes();
    }
}
