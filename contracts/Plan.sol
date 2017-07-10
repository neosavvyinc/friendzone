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

    function checkIfMember(address member) returns (bool) {
        require(membersMap[member]);
        return membersMap[member];
    }

    function Plan(bytes32 _name, address[] _members) {
        owner = msg.sender;
        name = _name;
        members = _members;

        for (uint i = 0; i < members.length; i++) {
            membersMap[members[i]] = true;
        }
    }

    function addMember(address newMember) onlyOwner {
        // add member
        members.push(newMember);
        // communicate that a new member has been added to the plan
        NewMemberAdded(name, newMember);
    }

    function addInitiative(uint256 votesNeededToPass, bytes32 name, bytes32 description) returns (Initiative newInitiativeAddress) {
        Initiative newInitiative = new Initiative(members, votesNeededToPass, name, description);
        initiatives.push(newInitiative);
        NewInitiativeAdded(newInitiative);
        return newInitiative;
    }

    function getMemberAtIndex(uint idx) returns (address) {
        return members[idx];
    }

    function getInitiativesLength() returns (uint) {
        return initiatives.length;
    }

    function transfer(address _newOwner) onlyOwner {
        owner = _newOwner;
        OwnershipTransferred(owner);
    }
}
