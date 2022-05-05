<template>
    <div>
        <el-radio-group v-model="radio1" size="large">
            <el-radio-button label="add"></el-radio-button>
            <el-radio-button label="pool"></el-radio-button>
        </el-radio-group>

        <Add v-if="radio1 == 'add'"></Add>
        <Mobility v-else></Mobility>
    </div>
</template>

<script setup lang="ts">
import { ref } from "vue";
import Add from "./add.vue";
import Mobility from "./mobility.vue";
const radio1 = ref("add");
</script>

<style scoped>

</style>