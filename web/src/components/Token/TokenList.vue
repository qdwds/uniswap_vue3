<template>
    <div>
        <el-dialog
            v-model="isShow"
            title="Tips"
            width="40%"
            :before-close="handleVisibility"
        >
            <div class="box">
                <el-input v-model="data.address" clearable autofocus placeholder="搜索名称或者粘贴地址" @input="handleChangeAddress"></el-input>
                <el-divider></el-divider>
                <template v-if="data.search.length > 0">
                    <div class="list" v-for="token in data.search" @click="handleSelectToken">
                        <div class="l">
                            <img :src="token.logoURI">
                            <div>
                                <div>{{token.name}}</div>
                                <div>{{token.symbol}}</div>
                            </div>
                        </div>
                        <div class="r">
                            {{data.balance}}
                        </div>
                    </div>
                </template>
                <template v-else>
                    <div class="list" v-for="token in data.tokens" @click="handleSelectToken(token)">
                        <div class="l">
                            <img :src="token.logoURI">
                            <div>
                                <div>{{token.name}}</div>
                                <div>{{token.symbol}}</div>
                            </div>
                        </div>
                        <div class="r">
                            {{data.balance}}
                        </div>
                    </div>
                </template>
            </div>
        </el-dialog>
    </div>
</template>

<script lang="ts" setup>
import { onMounted, reactive, ref, toRef } from "vue";
import { getERC20AllInfo } from "../../contracts/erc20Info";
import { tokens } from "./tokens.json";
const emit = defineEmits([
    "handleVisibility",
    "handleSelectToken"
])

const props = defineProps({
    isShow:{
        type:Boolean,
        default:false
    }
})
const data = reactive({
    address:"",
    balance:"0",
    tokens,
    search:[]
})


const handleVisibility = () => {
    emit("handleVisibility",false);
}

// 后期加 防抖
const handleChangeAddress = async () => {
    // emit("handleChangeAddress",data.address);    
    console.log(data.address);
    
    //  TODO: 1. 防抖  2.校验地址
    if(data.address){
         const info:any = await getERC20AllInfo(data.address);
        data.search = [];
        data.search.push(info)
    }else{
        data.search = [];
    }
}
   
//  选中的列表
const handleSelectToken = (token:any) => {
    emit("handleSelectToken", token);
}

onMounted(()=>{
   const TOKENS = JSON.stringify(sessionStorage.TOKENS);
   if(!TOKENS){
       data.tokens = sessionStorage.TOKENS;
   }

})
</script>

<style scoped>
.box{
    width: 100%;
    max-height: 450px;
    overflow-y: auto;
}
.list{
    height: 50px;
    display: flex;
    justify-content: space-between;
}
.list:hover{
    cursor: pointer;
    background-color: rgb(237, 238, 242);
}
.list .l{
    display: flex;
}
.list .l img{
    height: 40px;
}
:deep .el-dialog{
    min-width: 400px;
}
</style>