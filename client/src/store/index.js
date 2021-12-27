import { createStore } from 'vuex'

export default createStore({
  state: {
    web3Provider: null,
    contracts: {},
    account: '0x0000000000000000000000000000000000000000',
    accountAddress: 'not connected',
    AuctionContractAddress: 'not connected',
    DeedContractAddress: 'not connected',
    deedInstance: null,
    auctionInstance: null
  },
  mutations: {
  },
  actions: {
  },
  modules: {
  }
})
