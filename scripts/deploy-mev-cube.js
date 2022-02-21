require('dotenv').config();
const {ethers, network} = require("hardhat");
const {TestCommon} = require("../test/test-common");
const writeFile = require('util').promisify(require('fs').writeFile);
// const hre = require('hardhat');


async function setupNfts(mockGausContract) {

  const [owner, _] = await ethers.getSigners();

  console.log('sending eth to ' + process.env.METAMASK_TEST_WALLET_ADDRESS);

  const transactionHash = await owner.sendTransaction({
    to: process.env.METAMASK_TEST_WALLET_ADDRESS,
    value: ethers.utils.parseEther("1.0"),        // Sends exactly 1.0 ether
  });

  await network.provider.send("hardhat_setBalance", [
    process.env.METAMASK_TEST_WALLET_ADDRESS,
    "0x1000000000000000000",
  ]);

  // Mint a mockErc721
  await mockGausContract.connect(owner).mint(process.env.METAMASK_TEST_WALLET_ADDRESS, 1);
}

async function main() {

  const [owner, _] = await ethers.getSigners();

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
