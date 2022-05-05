<template>
    <div>
        pool
    </div>
</template>

<script setup lang="ts">
import { onMounted } from "vue";
import { getERC20AllInfo } from "../../contracts/erc20Info";
onMounted(async ()=>{
    const a = await getERC20AllInfo("0xa513E6E4b8f2a923D98304ec87F64353C4D5C853");
    console.log(a);
})
</script>

<style scoped>

</style>