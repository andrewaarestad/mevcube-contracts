
const {expect} = require('chai');
const {ethers} = require("hardhat");
const {TestCommon} = require("./test-common");

describe('Owner Functions', () => {
  it('should allow owner to change solver fee', async() => {
    const [owner, otherPerson, _] = await ethers.getSigners();

    const contract = await TestCommon.deployMevCube();

    const currentSolverFee = await contract.currentSolverFee();
    expect(currentSolverFee.eq(TestCommon.SOLVER_FEE)).to.be.true;

    await contract.setSolverFee(ethers.utils.parseEther('23'));
    const newSolverFee = await contract.currentSolverFee();
    expect(newSolverFee.eq(ethers.utils.parseEther('23'))).to.be.true;

    await expect(contract.connect(otherPerson).setSolverFee(ethers.utils.parseEther('23'))).to.be.revertedWith("onlyOwner");

  })
})
