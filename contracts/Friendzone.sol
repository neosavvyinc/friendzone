pragma solidity ^0.4.11;


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
contract Initiative {
    enum StateTypes { InProgress, Ended }

    address public admin;
    bytes32 public description;
    uint votesNeededToPass;

    mapping(address => bool) members;
    mapping(address => bool) votes;
    uint256 positiveVotes;
    bool public isOpen;
    bool public result;

    event CommunicateResult(bool result);
    event OnOpenInitiative(bytes32 description);

    modifier onlyAdmin() {
        require(admin == msg.sender);
        _;
    }

    // check if sender is a member
    modifier isMember() {
        require(members[msg.sender]);
        _;
    }

    // check if voting period is open
    modifier isVotingOpen() {
        require(isOpen);
        _;
    }

    modifier isVotingClosed() {
        require(isOpen);
        _;
    }

    modifier onlyIfNotVoted() {
        require(!votes[msg.sender]);
        _;
    }

    function Initiative(
        address[] _members,
        uint _votesNeededToPass,
        bytes32 _description
    ) {
        require(_votesNeededToPass > 0);

        admin = msg.sender;
        votesNeededToPass = _votesNeededToPass;
        description = _description;
        for (uint i = 0; i < _members.length; i++) {
            members[_members[i]] = true;
        }
        isOpen = false;
    }

    function vote(bool value) onlyIfNotVoted {
        votes[msg.sender] = value;

        if (value) {
            positiveVotes++;
        }

        if (!result && positiveVotes >= votesNeededToPass) {
            result = true;
        }
    }

    function closeVoting() onlyAdmin isVotingOpen {
        isOpen = false;
        CommunicateResult(result);
    }

    function openVoting() onlyAdmin isVotingClosed {
        isOpen = true;
        OnOpenInitiative(description);
    }

    function changeDescription(bytes32 _description) onlyAdmin {
        description = _description;
    }

    function onAddMember(address _member) onlyAdmin {
        members[_member] = true;
    }
}


contract Plan {
    address public owner;
    bytes32 public name;
    address[] public members;

    Initiative[] initiatives;

    event OnAddInitiative(address initiative);
    event OnAddNewMember(bytes32 planName, address newMember);

    modifier onlyOwner() {
        require(owner == msg.sender);
        _;
    }

    function Plan(bytes32 _name, address[] _members) {
        owner = msg.sender;
        name = _name;
        members = _members;
    }

    function addMember(address newMember) onlyOwner {
        // add member
        members.push(newMember);
        // communicate that a new member has been added to the plan
        OnAddNewMember(name, newMember);
    }

    function addInitiative(uint256 votesNeededToPass, bytes32 description) returns (Initiative newInitiativeAddress) {
        Initiative newInitiative = new Initiative(members, votesNeededToPass, description);
        initiatives.push(newInitiative);
        OnAddInitiative(address(newInitiative));
        return newInitiative;
    }
}


contract Friendzone {
    function createNewPlan(bytes32 name, address[] members) returns (Plan planAddress) {
        return new Plan(name, members);
    }
}
