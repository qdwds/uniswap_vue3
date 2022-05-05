import { defineStore } from "pinia";

interface IState {
    user?: string
}
export const useUseStore = defineStore('user', {
    state: ():IState => ({
        user: ""
    }),
    actions: {
        setUser(user: string):void {
            this.user = user;
        }
    },
    getters: {
        getUser: (state) => state.user
    }
})
