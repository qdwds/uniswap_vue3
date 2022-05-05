import { ethers } from "hardhat"
import { contractInfo } from "../utils/contractInfo";
// factory: 0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9
// INIT_CODE_PAIR_HASH: 0x6514c4a4acb567240d98ed68dd26ed635559313c8c728536d174408bb2820ed8
// weth9: 0x5FC8d32690cc91D4c39d9d3abcBD16989F875707
const main = async() => {
    const UniswapV2Router02 = await ethers.getContractFactory("UniswapV2Router02");
    const route2 = await UniswapV2Router02.deploy(
        "0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9",
        "0x5FC8d32690cc91D4c39d9d3abcBD16989F875707",
    );

    await route2.deployed();

    await contractInfo(route2.address, "UniswapV2Router02");
    console.log("UniswapV2Router02 to:", route2.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  