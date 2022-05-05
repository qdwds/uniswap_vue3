import { ethers } from "hardhat"

const main = async () => {
    const T1 = await ethers.getContractFactory("Test1");
    const T2 = await ethers.getContractFactory("Test2");
    const T3 = await ethers.getContractFactory("Test3");
    const T4 = await ethers.getContractFactory("Test4");

    const t1 = await T1.deploy();
    const t2 = await T2.deploy();
    const t3 = await T3.deploy();
    const t4 = await T4.deploy();

    await t1.deployed();
    await t2.deployed();
    await t3.deployed();
    await t4.deployed();

    console.log("t1:  ", t1.address);
    console.log("t2:  ", t2.address);
    console.log("t3:  ", t3.address);
    console.log("t4:  ", t4.address);
}

main();