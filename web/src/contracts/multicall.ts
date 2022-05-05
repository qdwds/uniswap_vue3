import { reactify } from "@vueuse/shared";
import { Contract, ethers } from "ethers"
import { isProxy, reactive, toRaw, toRef, toRefs, unref } from "vue";
import { abi, info } from "../../../abi/Multicall.json";
import { useGetSigner } from "../hooks/useMetamask";

export let multicall:Contract;

export const initMulticall = async () => {
    multicall = new ethers.Contract(info.address, abi, useGetSigner());
    console.log(multicall);
}

export const aggregate = async (address: string) => {
    const result = await multicall.getEthBalance(address);
    console.log(result);
    
}