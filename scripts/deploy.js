const { ethers, upgrades } = require("hardhat");

const main = async () => {
  const Token = await ethers.getContractFactory('Token');
  const token = await upgrades.deployProxy(Token, ['Token', 'TOKE', 1000], {
    initializer: 'initialize',
  });

  await token.deployed();
  console.log("ERC20 Token deployed to:", token.address);
}

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
}

runMain();