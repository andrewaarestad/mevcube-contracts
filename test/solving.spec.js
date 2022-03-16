
const {expect} = require('chai');
const {TestCommon} = require("./test-common");
const {BigNumber} = require("ethers");



describe('Solving', () => {

  it('should indicate whether cube is solved when moving', async() => {

    const contract = await TestCommon.deployMevCube();

    const result1 = await contract.move('F');
    const result2 = await contract.move('f');


    const confirmation1 = await result1.wait();
    const confirmation2 = await result2.wait();

    expect(confirmation1.events.length).to.be.equal(0);
    expect(confirmation2.events.length).to.be.equal(1);

    const solvedEvent = confirmation2.events.filter(e => e.event === 'Solved')[0];
    expect(solvedEvent).to.exist;

    const [owner] = await ethers.getSigners();

    // console.log('event: ', solvedEvent, solvedEvent.args, solvedEvent.constructor.name);

    expect(solvedEvent.args._solution).to.eq('f');
    expect(solvedEvent.args._solver).to.eq(owner.address);

    // console.log('result1: ', result1);
    // console.log('result2: ', result2);

    // expect(result1.value).to.be.equal(BigNumber.from(0));
    // expect(result2.value).to.be.equal(BigNumber.from(1));

  })


})
