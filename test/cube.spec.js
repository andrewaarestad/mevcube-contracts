
const {ethers,waffle} = require("hardhat");


async function deploy() {
  const contractFactory = await ethers.getContractFactory("MevCube");
  // const [owner, executor, _] = await ethers.getSigners();
  const contract = await contractFactory.deploy({value: ethers.utils.parseEther("5")});
  await contract.deployed();
  // console.log('deployed: %s', contract.address);

  return contract;
}

function convertToString(state) {
  let str = '';
  const sliced = state.slice(2).trim();
  // console.log('converting: ', sliced);
  for (let ii=0; ii<sliced.length / 2; ii++) {
    const val = parseInt(sliced.substring(ii * 2, ii * 2 + 2), 16);
    str += String.fromCharCode(val);
  }
  return str;
}

describe('Cube', () => {
  it('should deploy', async() => {

    const contract = await deploy();

    console.log('deployed');
  });

  it('should move', async() => {
    const contract = await deploy();
    const state1 = await contract.getState();

    const result = await contract.move('L', 1, true);
    const state2 = await contract.getState();

    console.log('state1: ', convertToString(state1));
    console.log('state2: ', convertToString(state2));

    // console.log('move result: ', result);
  })

})
