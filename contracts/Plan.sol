pragma solidity ^ 0.4.11;

import './Initiative.sol';


contract Plan {
    address public owner;
    bytes32 public name;
    address[] members;
    mapping(address => bool) public membersMap;

    Initiative[] initiatives;

    event NewInitiativeAdded(address initiative);
    event NewMemberAdded(bytes32 planName, address newMember);
    event OwnershipTransferred(address newOwner);

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }

    function Plan(bytes32 _name, address[] _members) {
        owner = tx.origin;
        name = _name;
        members = _members;

        for (uint i = 0; i < members.length; i++) {
            membersMap[members[i]] = true;
        }
    }

    function transfer(address _newOwner) onlyOwner returns (bool) {
        owner = _newOwner;
        OwnershipTransferred(owner);
        return true;
    }

    function addMember(address newMember) onlyOwner returns (bool) {
        // check if newMember is already a member
        require(checkIfMember(newMember));

        // add member
        members.push(newMember);
        membersMap[newMember] = true;

        // add member to all initiatives of this plan
        for (uint i = 0; i < initiatives.length; i++) {
            initiatives[i].addMember(newMember);
        }

        // communicate that a new member has been added to the plan
        NewMemberAdded(name, newMember);
        return true;
    }

    function addInitiative(uint256 votesNeededToPass, bytes32 name, bytes32 description) returns (Initiative newInitiativeAddress) {
        Initiative newInitiative = new Initiative(members, votesNeededToPass, name, description);
        initiatives.push(newInitiative);
        NewInitiativeAdded(newInitiative);
        return newInitiative;
    }

    function checkIfMember(address member) constant returns (bool) {
        require(membersMap[member]);
        return membersMap[member];
    }
}
