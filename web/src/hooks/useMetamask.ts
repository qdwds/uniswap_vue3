import { toRaw } from "vue";
import { useMetamaskStore } from "../store/metamask"

const store = useMetamaskStore();

export const useGetSigner = () => {
    return toRaw(store.getSigner);
}

export const useSetSigner = (signer:any) => {
    store.setSigner(signer);
}
