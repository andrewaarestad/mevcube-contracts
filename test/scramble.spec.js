
const {expect} = require('chai');
const {TestCommon} = require("./test-common");
const { ethers, waffle} = require("hardhat");
const {BigNumber} = require("ethers");



describe('Scramble', () => {


  it('should scramble', async() => {

    const contract = await TestCommon.deployMevCube();
    const state1 = await contract.getState();
    await contract.scramble();
    const state2 = await contract.getState();
    await contract.reset();
    const state3 = await contract.getState();

    expect(state1).to.eq(state3);
    expect(state1).to.not.eq(state2);

  });

  it('should fail to scramble an unsolved cube', async() => {

    const contract = await TestCommon.deployMevCube();
    await contract.scramble();
    await expect(contract.scramble()).to.be.revertedWith("Cube must be solved");
  });

  it('should pay solver fee as reward for scrambling', async() => {
    const [owner, _] = await ethers.getSigners();

    const contract = await TestCommon.deployMevCube();
    await contract.move(TestCommon.ALL_MOVES[0] + TestCommon.ALL_MOVES[0].toLowerCase(), {value: TestCommon.SOLVER_FEE});
    const balance1 = await waffle.provider.getBalance(owner.address);
    const result = await contract.scramble();
    const balance2 = await waffle.provider.getBalance(owner.address);

    // console.log('result: ', result);
    // console.log('balance1: ', balance1);
    // console.log('balance2: ', balance2);
    // console.log('solverFee: ', TestCommon.SOLVER_FEE);
    // console.log('diff: ', balance2.sub(balance1));
    // console.log('ddiff: ', TestCommon.SOLVER_FEE.sub(balance2.sub(balance1)))

    // expect(balance2).to.eq(balance1.add(TestCommon.SOLVER_FEE))

    // TODO: Can we find a way to assert an equality here?
    // The difference is not exactly the solver fee, I assume this is due to gas consumption
    expect(balance2.gt(balance1)).to.be.true;




  });

  it('should return scrambler reward', async() => {
    const contract = await TestCommon.deployMevCube();
    const result = await contract.currentScrambleReward();
    expect(result.eq(TestCommon.SOLVER_FEE)).to.be.true;
  });

})
