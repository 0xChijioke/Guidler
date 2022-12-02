// deploy/00_deploy_your_contract.js

const { ethers } = require("hardhat");

const localChainId = "31337";

// const sleep = (ms) =>
//   new Promise((r) =>
//     setTimeout(() => {
//       console.log(`waited for ${(ms / 1000).toFixed(3)} seconds`);
//       r();
//     }, ms)
//   );

module.exports = async ({ getNamedAccounts, deployments, getChainId }) => {
  const { deploy } = deployments;
  const { deployer } = await getNamedAccounts();
  const chainId = await getChainId();

  const cape = await deploy("Cape", {
    from: deployer,
    args: [],
    log: true,
  });
  const Cape = await ethers.getContract("Cape", deployer);
  const noob = await deploy("Noob", {
    from: deployer,
    args: [Cape.address],
    log: true,
  });
  const arms = await deploy("Arms", {
    from: deployer,
    args: [],
    log: true,
  });
  const chest = await deploy("Chest", {
    from: deployer,
    args: [],
    log: true,
  });
  const capeFront = await deploy("CapeFront", {
    from: deployer,
    args: [],
    log: true,
  });
  const boots = await deploy("Boots", {
    from: deployer,
    args: [],
    log: true,
  });
  const waist = await deploy("Waist", {
    from: deployer,
    args: [],
    log: true,
  });
  const headmail = await deploy("HeadMail", {
    from: deployer,
    args: [],
    log: true,
  });
  const helmet = await deploy("Helmet", {
    from: deployer,
    args: [],
    log: true,
  });
  const ethlogo = await deploy("ETHLogo", {
    from: deployer,
    args: [],
    log: true,
  });
  const sword = await deploy("Sword", {
    from: deployer,
    args: [],
    log: true,
  });
  // const castle = await deploy("Castle", {
  //   from: deployer,
  //   args: [],
  //   log: true,
  // });
  
  // Getting a previously deployed contract
  // const SmileAddr = await ethers.getContract("Smile", deployer);


  /*  await YourContract.setPurpose("Hello");
  
    To take ownership of yourContract using the ownable library uncomment next line and add the 
    address you want to be the owner. 
    // await yourContract.transferOwnership(YOUR_ADDRESS_HERE);

    //const yourContract = await ethers.getContractAt('YourContract', "0xaAC799eC2d00C013f1F11c37E654e59B0429DF6A") //<-- if you want to instantiate a version of a contract at a specific address!
  */

  /*
  //If you want to send value to an address from the deployer
  const deployerWallet = ethers.provider.getSigner()
  await deployerWallet.sendTransaction({
    to: "0x34aA3F359A9D614239015126635CE7732c18fDF3",
    value: ethers.utils.parseEther("0.001")
  })
  */

  /*
  //If you want to send some ETH to a contract on deploy (make your constructor payable!)
  const yourContract = await deploy("YourContract", [], {
  value: ethers.utils.parseEther("0.05")
  });
  */

  /*
  //If you want to link a library into your contract:
  // reference: https://github.com/austintgriffith/scaffold-eth/blob/using-libraries-example/packages/hardhat/scripts/deploy.js#L19
  const yourContract = await deploy("YourContract", [], {}, {
   LibraryName: **LibraryAddress**
  });
  */

  // Verify from the command line by running `yarn verify`

  // You can also Verify your contracts with Etherscan here...
  // You don't want to verify on localhost
  // try {
  //   if (chainId !== localChainId) {
  //     await run("verify:verify", {
  //       address: YourContract.address,
  //       contract: "contracts/YourContract.sol:YourContract",
  //       constructorArguments: [],
  //     });
  //   }
  // } catch (error) {
  //   console.error(error);
  // }
};
module.exports.tags = [ "Castle", "Arms", "Cape","Chest", "Noob" ];
