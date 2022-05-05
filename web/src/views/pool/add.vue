<template>
    <div class="add">
        <Token
            :balance="token1.balance"
            :input="token1.input"
            :symbol="token1.symbol"
            @selectTokens="selectTokens1"
            @handleTokenAll="handleTokenAll1"
        ></Token>
        
		<el-divider>
			<el-icon @click="switchData"><Sort /></el-icon>
		</el-divider>

        <Token 
            :balance="token2.balance"
            :input="token2.input"
            :symbol="token2.symbol"
            @selectTokens="selectTokens2"
            @handleTokenAll="handleTokenAll2"
        ></Token>

        <el-button type="primary" size="large" @click="exchange">添加流动性</el-button>

        <TokenList 
            :isShow="token1.isShow"
            @handleVisibility="selectTokens1"
            @handleSelectToken="handleSelectToken1"
        ></TokenList>
		<TokenList 
            :isShow="token2.isShow" 
            @handleVisibility="selectTokens2"
            @handleSelectToken="handleSelectToken2"
        ></TokenList>
    </div>
</template>

<script lang="ts" setup>
import Token from "../../components/Token/index.vue";
import TokenList from "../../components/Token/TokenList.vue";
import { Sort } from '@element-plus/icons-vue';
import { reactive } from "vue";
import { getERC20Balance } from "../../contracts/erc20Info";
const token1 = reactive({
    input: "0.0",
    token: "",
    balance: "0",
    symbol:"请选择",
	isShow:false,
})
const token2 = reactive({
    input: "0.0",
    token: "",
    balance: "0",
    symbol:"请选择",
	isShow:false,
})

// dialog show
const selectTokens1 = () => token1.isShow = !token1.isShow;
const selectTokens2 = () => token2.isShow = !token2.isShow;

//  all balance change
const handleTokenAll1 = () => token1.input = token1.balance;
const handleTokenAll2 = () => token2.input = token2.balance;

// 兑换
const exchange = () => {
    console.log("兑换");
    
}
// 上下切换token
const switchData = () => {
    console.log("switch");
}

//  选中的列表数据
const handleSelectToken1 = async (token:any) => {
    const balance = await getERC20Balance(token.address);
    token1.balance = balance;
    token1.symbol = token.symbol;
    token1.token = token.token;
    selectTokens1();
}
const handleSelectToken2 = async (token:any) => {
    const balance = await getERC20Balance(token.address);
    token2.balance = balance;
    token2.symbol = token.symbol;
    token2.token = token.token;
    selectTokens2();
}
</script>
<style>
*{
    padding: 0;
    margin: 0;
}
</style>
<style scoped>
:deep .el-button{
	width: 100%;
	margin-top: 12px;
}
.add{
    margin-top: 24px;
}
</style>