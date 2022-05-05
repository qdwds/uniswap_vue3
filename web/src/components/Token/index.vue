<template>
    <div class="token">
        <el-row>
            <el-col :span="12">
                <el-input v-model="input" size="large"></el-input>
            </el-col>
            <el-col :span="11" class="text" :push="1">
                <el-button @click="handleTokenAll" >全部</el-button>
                <div class="info" @click="selectTokens">
                    <div class="tk">{{ symbol}}</div>
                    <div>{{ balance }}</div>
                </div>
            </el-col>
        </el-row>
    </div>
</template>

<script setup lang="ts">

const props = defineProps({
    balance:{
        type:String,
    },
    input:{
        type:String
    },
    symbol:{
        type:String,
    }
});
const emit = defineEmits(["selectTokens","handleTokenAll"]);

const selectTokens = () => emit("selectTokens");

const handleTokenAll = ()=> emit("handleTokenAll");
</script>

<style scoped>
.token {
    height: 50px;
    width: 400px;
}
.text {
    text-align: center;
    display: flex;
}
.tk{
    width: 100%;

}
.el-button{
    width:80px !important;
}
.info{
    width: 100%;
    border: 1px solid #cacaca;
	border-radius: 12px;
	cursor: pointer;
}
</style>