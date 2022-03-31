const { ethers, upgrades } = require("hardhat");

const main = async () => {
  const Token = await ethers.getContractFactory('Token');
  const token = await upgrades.deployProxy(Token, ['Test', 'TST', 1000], {
    initializer: 'initialize',
  });

  await token.deployed();
  console.log("ERC20 Token deployed to:", token.address);

  // Get accounts
  const accounts = await ethers.getSigners();
  const accountOne = accounts[0].address
  const accountTwo = accounts[1].address


  // Run basic functions
  const decimals = await token.decimals();
  console.log('decimals: ', decimals);

  const totalSupply = await token.totalSupply();
  console.log('totalSupply: ', totalSupply);


  // Transfer token from account one to account two
  const balanceOfAccountOne = await token.balanceOf(accountOne);
  console.log('balance of account 1: ', balanceOfAccountOne); // should be 1000

  const transfer = await token.transfer(accountTwo, 1);
  console.log('transfer result: ', transfer.hash);

  const balanceOfAccountTwo = await token.balanceOf(accountTwo);
  console.log('balance of account 2: ', balanceOfAccountTwo); // should be 1 


  // Transfer token back to account one using 'approve' and 'transferFrom'
  const allowanceBeforeApproval = await token.allowance(accountOne, accountTwo);
  console.log('allowance before approval: ', allowanceBeforeApproval);

  const approve = await token.approve(accountTwo, 1);
  console.log('approve result: ', approve.hash);

  const allowanceAfterApproval = await token.allowance(accountOne, accountTwo);
  console.log('allowance after approval: ', allowanceAfterApproval);

  const transferFrom = await token.transferFrom(accountTwo, accountOne, 1);
  console.log('transferFrom result: ', transferFrom.hash);

  const finalBalanceOfAccountTwo = await token.balanceOf(accountTwo);
  console.log('final balance 0f account 2: ', finalBalanceOfAccountTwo); // should be zero

  const finalAllowance = await token.allowance(accountOne, accountTwo);
  console.log('final allowance after transfer: ', finalAllowance); // should be zero
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