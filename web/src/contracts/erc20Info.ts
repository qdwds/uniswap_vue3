import { ethers, Signer } from "ethers";
import { useGetSigner } from "../hooks/useMetamask";
import abi from "../abi/erc20.json";
import { useGetUser } from "../hooks/useUser";
const getContract = async (address: string) => {
    return new ethers.Contract(address, abi, useGetSigner())
}

export const getERC20AllInfo = async (address: string) => {
    const erc20 = await getContract(address);
    const decimals = (await erc20.decimals()).toString();
    const name = await erc20.name();
    const symbol = await erc20.symbol();
    const balance = (await erc20.balanceOf(useGetUser())).toString();
    return{
        decimals,
        name,
        symbol,
        balance
    }
}


export const getERC20Balance = async (address:string):Promise<string> => {
    const erc20 = await getContract(address);
    return ethers.utils.formatUnits(await erc20.balanceOf(useGetUser()), 18);
}