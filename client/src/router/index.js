import { createRouter, createWebHashHistory } from 'vue-router'
import Auction from '../views/Auction.vue'

const routes = [
  {
    path: '/',
    name: 'Auction',
    component: Auction
  },
  {
    path: '/deed',
    name: 'Deed',
    // route level code-splitting
    // this generates a separate chunk (about.[hash].js) for this route
    // which is lazy-loaded when the route is visited.
    component: () => import(/* webpackChunkName: "about" */ '../views/Deed.vue')
  }
]

const router = createRouter({
  history: createWebHashHistory(),
  routes
})

export default router
