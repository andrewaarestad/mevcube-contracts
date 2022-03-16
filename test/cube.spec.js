
const {TestCommon} = require("./test-common");


describe('Cube', () => {

  let contract;

  before(async() => {
    contract = await TestCommon.deployMevCube();
  })

  it('should return version', async() => {
    await contract.getVersion();
  })

})
