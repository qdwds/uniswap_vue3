import { ethers } from "hardhat"
import { contractInfo } from "../utils/contractInfo";



const main = async () => {
    const WETH9 = await ethers.getContractFactory("WETH9");
    const weth = await WETH9.deploy();
    await weth.deployed();

    contractInfo(weth.address, "WETH9");
    console.log("WERH to:", weth.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  