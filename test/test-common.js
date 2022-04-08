
const {ethers} = require("hardhat");

class TestCommon {
  static ALL_MOVES = ['L','M','R','U','E','D','F','S','B']

  static SOLVER_FEE = ethers.utils.parseEther("0.01");

  static async deployMevCube() {
    const contractFactory = await ethers.getContractFactory("MevCube");
    const contract = await contractFactory.deploy();
    await contract.deployed();
    return contract;
  }

  static convertToString(state) {
    let str = '';
    const sliced = state.slice(2).trim();
    // console.log('converting: ', sliced);
    for (let ii=0; ii<sliced.length / 2; ii++) {
      const val = parseInt(sliced.substring(ii * 2, ii * 2 + 2), 16);
      str += String.fromCharCode(val);
    }
    return str;
  }
}


module.exports = {TestCommon};
