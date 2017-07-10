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
    bytes32 public name;
    bytes32 public description;
    uint votesNeededToPass;

    mapping(address => bool) members;
    mapping(address => bool) votes;
    uint256 positiveVotes;
    bool public isOpen;
    bool public result;

    event CommunicateResult(bool result);
    event InitiativeHasBeenOpened(address initiative, bytes32 name, bytes32 description);
    event NewVoteCasted(address voter, bool value);

    modifier onlyAdmin() {
        require(admin == msg.sender);
        _;
    }

    // check if sender is a member
    modifier onlyMember() {
        require(members[msg.sender]);
        _;
    }

    // check if voting period is open
    modifier isVotingOpen() {
        require(isOpen);
        _;
    }

    modifier isVotingClosed() {
        require(!isOpen);
        _;
    }

    modifier onlyIfNotVoted() {
        require(!votes[msg.sender]);
        _;
    }

    function Initiative(
        address[] _members,
        uint _votesNeededToPass,
        bytes32 _name,
        bytes32 _description
    ) {
        require(_votesNeededToPass > 0);

        admin = msg.sender;
        votesNeededToPass = _votesNeededToPass;
        name = _name;
        description = _description;
        for (uint i = 0; i < _members.length; i++) {
            members[_members[i]] = true;
        }
        isOpen = false;
    }

    function vote(bool value) onlyIfNotVoted isVotingOpen {
        votes[msg.sender] = value;

        if (value) {
            positiveVotes++;
        }

        if (!result && positiveVotes >= votesNeededToPass) {
            result = true;
        }

        NewVoteCasted(msg.sender, value);
    }

    function closeVoting() onlyAdmin isVotingOpen {
        isOpen = false;
        CommunicateResult(result);
    }

    function openVoting() onlyAdmin isVotingClosed {
        isOpen = true;
        InitiativeHasBeenOpened(this, name, description);
    }

    function changeName(bytes32 _name) onlyAdmin {
        name = _name;
    }

    function changeDescription(bytes32 _description) onlyAdmin {
        description = _description;
    }

    function addMember(address _member) onlyAdmin constant {
        require(!isMember(_member));
        members[_member] = true;
    }

    function isMember(address member) onlyMember constant returns (bool) {
        return members[member];
    }

    function voterValue(address member) onlyMember constant returns (bool) {
        return votes[member];
    }

    function getPositiveVotes() onlyMember constant returns (uint) {
        return positiveVotes;
    }
}
