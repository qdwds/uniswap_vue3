import { defineStore } from "pinia";

interface IState {
    signer?: any
}
export const useMetamaskStore = defineStore('metamsk', {
    state: ():IState => ({
        signer: null
    }),
    actions: {
        setSigner(signer: any) {
            this.signer = signer;
        }
    },
    getters: {
        getSigner: (state) => {
            return state.signer
        }
    }
})