require('dotenv').config();
const {ethers, network} = require("hardhat");
const {TestCommon} = require("../test/test-common");
const writeFile = require('util').promisify(require('fs').writeFile);



async function main() {

  // const [owner, _] = await ethers.getSigners();

  const mevCubeContract = await TestCommon.deployMevCube();

  console.log("MEV Cube deployed to:", mevCubeContract.address);

  await writeFile('addresses.json', JSON.stringify({
    mevCube: mevCubeContract.address,
  }, null, 2));

}

main()
.then(() => process.exit(0))
.catch((error) => {
  console.error(error);
  process.exit(1);
});
