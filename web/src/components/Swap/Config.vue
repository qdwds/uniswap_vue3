<template>
    <h3>交易设置</h3>
    <div class="flex">
        <el-button type="danger" round class="auto">自动</el-button>
        <el-input v-model="data.point" class="point"></el-input>
    </div>
    <div class="flex">
        <span class="text">交易截止时间</span>
        <div class="flex">
            <el-input v-model="data.date"></el-input>
            <span style="width:50px" class="text">分钟</span>
        </div>
    </div>
</template>

<script setup lang="ts">
import { reactive } from "vue-demi";
const data = reactive({
    point:"0.1",
    date:30
})
</script>

<style scoped>
.flex{
    display: flex;
    justify-content: space-between;
    align-content: center;
    padding: 4px;
}
.text{
    line-height: 40px;
}
.auto{
    width: 150px !important;
}
.point{
    height: 32px;
    width: 200px;
}
[data-v-54cdc180] .el-button{
    margin-top: 0px;
}
</style>