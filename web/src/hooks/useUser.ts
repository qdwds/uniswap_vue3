import { toRaw } from "vue";
import { useUseStore } from "../store/user"

const store = useUseStore();

export const useGetUser = () => {
    return toRaw(store.getUser);
}

export const useSetUser = (user:string) => {
    store.setUser(user);
}
