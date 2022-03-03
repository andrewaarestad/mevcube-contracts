
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



describe.only('Cube', () => {


  it('should scramble', async() => {

    const contract = await deploy();
    const state1 = await contract.getState();
    await contract.scramble();
    const state2 = await contract.getState();
    await contract.reset();
    const state3 = await contract.getState();

    expect(state1).to.eq(state3);
    expect(state1).to.not.eq(state2);

  })


})
