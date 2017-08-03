pragma solidity ^0.4.11;


/*
 * An initiative is something a group of people casts a vote on.
 * It can be not-yet-opened, in progress and ended
 * An initiative has:
 *  - A description of the initiative.
 *  - A number of votes needed to pass
 *  - A result: pass/no-pass
 *  - A status: not-yet-opened, in progress and ended
 *  - A map from voters to votes
 * Only members of the parent `Plan` can vote
 */
contract Initiative {
    enum StateTypes { InProgress, Ended }

    bytes32 public name;
    bytes32 public description;
    uint votesNeededToPass;

    mapping(address => bool) votes;
    uint256 positiveVotes;
    bool public isOpen;
    bool public result;

    event CommunicateResult(bool result);
    event InitiativeHasBeenOpened(address initiative, bytes32 name, bytes32 description);
    event NewVoteCasted(address voter, bool value);

    // check if voting period is open
    modifier isVotingOpen() {
        require(isOpen);
        _;
    }

    modifier isVotingClosed() {
        require(!isOpen);
        _;
    }

    function Initiative(
        uint _votesNeededToPass,
        bytes32 _name,
        bytes32 _description
    ) {
        require(_votesNeededToPass > 0);

        votesNeededToPass = _votesNeededToPass;
        name = _name;
        description = _description;
        isOpen = false;
    }

    function vote(address voter, bool value) isVotingOpen {
        votes[voter] = value;

        if (value) {
            positiveVotes++;
        }

        if (!result && positiveVotes >= votesNeededToPass) {
            result = true;
        }

        NewVoteCasted(voter, value);
    }

    function closeVoting() isVotingOpen {
        isOpen = false;
        CommunicateResult(result);
    }

    function openVoting() isVotingClosed {
        isOpen = true;
        InitiativeHasBeenOpened(this, name, description);
    }

    function changeName(bytes32 _name) {
        name = _name;
    }

    function changeDescription(bytes32 _description)  {
        description = _description;
    }

    function voterValue(address member) constant returns (bool) {
        return votes[member];
    }

    function getPositiveVotes() constant returns (uint) {
        return positiveVotes;
    }
}
