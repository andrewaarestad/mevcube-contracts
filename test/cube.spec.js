
const {ethers,waffle} = require("hardhat");
const {expect} = require('chai');
const {TestCommon} = require("./test-common");

async function deploy() {
  const contractFactory = await ethers.getContractFactory("MevCube");
  // const [owner, executor, _] = await ethers.getSigners();
  const contract = await contractFactory.deploy({value: ethers.utils.parseEther("5")});
  await contract.deployed();
  // console.log('deployed: %s', contract.address);

  return contract;
}



describe('Cube', () => {
  it('should deploy', async() => {

    const contract = await deploy();

    console.log('deployed');
  });

  it('should move each direction', async() => {
    const contract = await deploy();
    // const state1 = await contract.getState();

    await contract.moveSingleAxis('L', 1, true);
    await contract.moveSingleAxis('M', 1, true);
    await contract.moveSingleAxis('R', 1, true);
    await contract.moveSingleAxis('U', 1, true);
    await contract.moveSingleAxis('E', 1, true);
    await contract.moveSingleAxis('D', 1, true);
    await contract.moveSingleAxis('F', 1, true);
    await contract.moveSingleAxis('S', 1, true);
    await contract.moveSingleAxis('B', 1, true);
    // const state2 = await contract.getState();

    // console.log('state1: ', convertToString(state1));
    // console.log('state2: ', convertToString(state2));

    // console.log('move result: ', result);
  })

  it('all moves should be reversible', async() => {
    const contract = await deploy();
    for (let ii=0; ii<TestCommon.ALL_MOVES.length; ii++) {
      for (let jj=1; jj<4; jj++) {
        const state1 = await contract.getState();
        await contract.moveSingleAxis(TestCommon.ALL_MOVES[ii], jj, true);
        const state2 = await contract.getState();
        await contract.moveSingleAxis(TestCommon.ALL_MOVES[ii], jj, false);
        const state3 = await contract.getState();
        // console.log('');
        // console.log('ii: ', ii, 'jj: ', jj);
        // console.log('state1: ', convertToString(state1));
        // console.log('state2: ', convertToString(state2));
        // console.log('state3: ', convertToString(state3));
        expect(state1).to.eq(state3);
        expect(state2).to.not.eq(state3);
      }
    }
  })

  it('all moves should be identity after 4 rotations', async() => {
    const contract = await deploy();
    for (let ii=0; ii<TestCommon.ALL_MOVES; ii++) {
      const state1 = await contract.getState();
      await contract.moveSingleAxis(TestCommon.ALL_MOVES[ii], 4, true);
      const state2 = await contract.getState();
      expect(state1).to.eq(state2);
    }
  })

  it('should scramble and reset', async() => {

    const contract = await deploy();
    const state1 = await contract.getState();
    await contract.scramble();
    const state2 = await contract.getState();
    await contract.reset();
    const state3 = await contract.getState();

    expect(state1).to.eq(state3);
    expect(state1).to.not.eq(state2);

  })

  it('should perform bulk moves', async() => {

    const contract = await deploy();
    const state1 = await contract.getState();
    await contract.move('Ff')
    const state2 = await contract.getState();
    expect(state1).to.eq(state2);
  })

})
