import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import init from './init'

let app = createApp(App)

app.use(store)
app.use(router)

app.mount('#app')
init.initWeb3();