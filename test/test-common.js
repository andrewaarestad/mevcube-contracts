
const {ethers} = require("hardhat");

class TestCommon {
  static ALL_MOVES = ['L','M','R','U','E','D','F','S','B']


  static async deployMevCube() {
    const contractFactory = await ethers.getContractFactory("MevCube");
    const contract = await contractFactory.deploy();
    await contract.deployed();
    return contract;
  }
}


module.exports = {TestCommon};
