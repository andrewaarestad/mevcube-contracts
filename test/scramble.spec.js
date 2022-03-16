
const {expect} = require('chai');
const {TestCommon} = require("./test-common");



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

  })


})
