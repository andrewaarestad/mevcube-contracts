
const {expect} = require('chai');
const {TestCommon} = require("./test-common");


describe('Moves', () => {

  let contract;

  before(async() => {
    contract = await TestCommon.deployMevCube();
  })

  it('should move each direction', async() => {
    for (let ii=0; ii<TestCommon.ALL_MOVES.length; ii++) {
      await contract.move(TestCommon.ALL_MOVES[ii], { value: TestCommon.SOLVER_FEE });
    }
  })

  it('all moves should be reversible', async() => {
    for (let ii=0; ii<TestCommon.ALL_MOVES.length; ii++) {
      // for (let jj=1; jj<4; jj++) {
        const state1 = await contract.getState();
        await contract.move(TestCommon.ALL_MOVES[ii], { value: TestCommon.SOLVER_FEE });
        const state2 = await contract.getState();
        await contract.move(TestCommon.ALL_MOVES[ii].toLowerCase(), { value: TestCommon.SOLVER_FEE });
        const state3 = await contract.getState();
        expect(state1).to.eq(state3);
        expect(state2).to.not.eq(state3);
      // }
    }
  })

  it('all moves should be identity after 4 rotations', async() => {
    for (let ii=0; ii<TestCommon.ALL_MOVES; ii++) {
      const state1 = await contract.getState();
      await contract.move(TestCommon.ALL_MOVES[ii]+TestCommon.ALL_MOVES[ii]+TestCommon.ALL_MOVES[ii]+TestCommon.ALL_MOVES[ii], { value: TestCommon.SOLVER_FEE });
      const state2 = await contract.getState();
      expect(state1).to.eq(state2);
    }
  })

  it('should scramble and reset', async() => {

    await contract.reset();
    const state1 = await contract.getState();
    await contract.scramble();
    const state2 = await contract.getState();
    await contract.reset();
    const state3 = await contract.getState();

    expect(state1).to.eq(state3);
    expect(state1).to.not.eq(state2);

  })

  it('should perform bulk moves', async() => {

    const state1 = await contract.getState();
    await contract.move('Ff', { value: TestCommon.SOLVER_FEE })
    const state2 = await contract.getState();
    expect(state1).to.eq(state2);
  })


})
