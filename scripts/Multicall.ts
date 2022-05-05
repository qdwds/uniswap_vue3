import { ethers } from "hardhat"
import { contractInfo } from "../utils/contractInfo";

const main = async () => {
    const Multicall = await ethers.getContractFactory("Multicall");
    const multicall = await Multicall.deploy();
    await multicall.deployed();
    await contractInfo(multicall.address, "Multicall");
    console.log("multicall address: ",multicall.address);
}

main();