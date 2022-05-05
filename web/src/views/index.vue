<template>
    <div class="app">
        <ElCard>
            <el-tabs v-model="activeName" @tab-click="handleClick">
                <el-tab-pane label="swap" name="swap">
                    <Swap></Swap>
                </el-tab-pane>
                <el-tab-pane label="pool" name="pool">
                    <Pool></Pool>
                </el-tab-pane>
            </el-tabs>
        </ElCard>
    </div>
</template>

<script lang="ts" setup>

import { ref , onMounted} from "vue";
import Swap from "./swap/index.vue";
import Pool from "./pool/index.vue";
import { initMetaMask } from "../contracts/metamask";
import { initMulticall } from "../contracts/multicall";

const activeName = ref("pool");
const handleClick = (e) => {
    console.log(e);
}
onMounted(async ()=> {
    await initMetaMask();
    initMulticall();
})
</script>
<style>
*{
    padding: 0;
    margin: 0;
}
</style>
<style scoped>

.app{
    width: 100vw;
    height: 100vh;
    display: flex;
    justify-content: center;
    align-items: center;
}
.el-card{
    min-height:440px ;
    min-width: 440px;
}
</style>