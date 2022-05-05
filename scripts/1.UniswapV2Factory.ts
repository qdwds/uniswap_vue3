import { ethers } from "hardhat";
import { contractInfo } from "../utils/contractInfo";
//  部署 uniswap的 工厂合约
async function main() {
  const UniswapV2Factory = await ethers.getContractFactory("UniswapV2Factory");
  const factory = await UniswapV2Factory.deploy("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266");

  await factory.deployed();
  await contractInfo(factory.address, "UniswapV2Factory");

  console.log("UniswapV2Factory deployed to:", factory.address);
  const INIT_CODE_PAIR_HASH = await factory.INIT_CODE_PAIR_HASH();
  console.log("INIT_CODE_PAIR_HASH:", INIT_CODE_PAIR_HASH.slice(2));
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
