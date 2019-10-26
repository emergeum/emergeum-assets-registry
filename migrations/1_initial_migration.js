const Migrations = artifacts.require("Migrations");
const AssetsRegistryFactory = artifacts.require("AssetsRegistryFactory");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(AssetsRegistryFactory);
};
