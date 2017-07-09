var Ownable = artifacts.require("./Ownable.sol");
var Plan = artifacts.require("./Plan.sol");

module.exports = function(deployer) {
  deployer.deploy(Ownable);
  deployer.link(Ownable, Plan);
  deployer.deploy(Plan);
};
