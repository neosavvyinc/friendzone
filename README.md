# Friendzone

Solidity Smart Contracts to help you organize plans with friends

## Setup

Dependencies:

```npm install -g truffle ethereumjs-testrpc```

Run TestRPC on a separate window: `testrpc`

Inside the friendzone run truffle commands:

* `truffle compile`: Compiles the contracts

* `truffle deploy`: By default it deploys it to testrpc

* `truffle test`: Runs the tests

## Architecture

There are 3 contracts: `Friendzone.sol`, `Plan.sol` and `Initiative.sol`.

`Friendzone.sol`: It creates new plans. It should be used as entry point for new plan organization.

`Plan.sol`: It is in charge of creating new initiatives for the plan, manage members and owners. It is the "umbrella" for a set of initiatives. An example could be "trip to Spain" with 8 members,

`Initiative.sol`: Here is where the voting happens. An initiative will be voted yay or nay by the members of the plan. The owner of the plan determines how many votes are needed to pass an initiative. The owner is also in charge of opening and closing the initiative for voting. Members cannot vote more than once on a given initiative.
