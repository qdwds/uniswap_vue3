import { ethers } from "ethers";
import { useSetSigner } from "../hooks/useMetamask";
import { useSetUser } from "../hooks/useUser";

export const initMetaMask = async () => {
    if (typeof window.ethereum == 'undefined') {
        console.warn('没有检查到MetaMask,请先安装！');
        return {}
    } else {
        const provider = new ethers.providers.Web3Provider(window.ethereum);
        const account = await provider.send("eth_requestAccounts", []);
        const signer = await provider.getSigner();
        useSetSigner(signer);
        useSetUser(account.length > 0? account[0] : "");
    }
}