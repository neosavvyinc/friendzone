pragma solidity ^0.4.11;

import './Plan.sol';


contract Friendzone {
    event NewPlanCreated(Plan planAddress);

    function createNewPlan(bytes32 name, address[] members) returns (Plan planAddress) {
        Plan newPlan = new Plan(name, members);
        NewPlanCreated(newPlan);
        return newPlan;
    }
}
