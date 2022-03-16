require('dotenv/config');
require("@nomiclabs/hardhat-waffle");
require("hardhat-tracer");
require('hardhat-etherscan-abi');

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.4",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200
          }
        }
      }
    ]
  },
  networks: {
    hardhat: {
      chainId: 1337,
      // forking: {
      //   enabled: true,
      //   url: process.env.ALCHEMY_URL,
      //   blockNumber: 12943483
      // }
    },
    mumbai: {
      url: "https://rpc-mumbai.maticvigil.com",
      accounts: [process.env.POLYGON_MUMBAI_PRIVATE_KEY],
      gasPrice: 8000000000
    },
    matic: {
      url: "https://speedy-nodes-nyc.moralis.io/<YOUR_ID>/polygon/mainnet",
      accounts: [process.env.POLYGON_MUMBAI_PRIVATE_KEY],
      gasPrice: 8000000000
    }
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY
  }
};

