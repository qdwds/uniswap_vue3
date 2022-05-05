import { createRouter, createWebHashHistory, RouteRecordRaw } from 'vue-router'
const routes: Array<RouteRecordRaw> = [
    {
        path:"/",
        name:"Layout",
        redirect:"/swap",
        component:()=>import("../views/index.vue"),
        children:[
            {
                path:"/swap",
                name:"Swap",
                component: ()=> import("../views/swap/index.vue")
            },
            {
                path:"/pool",
                name:"Pool",
                component:()=>import("../views/pool/index.vue")
            },
        ]
    },
    
]

const router = createRouter({
    history: createWebHashHistory(),
    routes
})

export default router