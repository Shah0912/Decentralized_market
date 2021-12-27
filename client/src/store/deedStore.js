export default {
  state: {},
  mutations: {},
  actions: {
    registerDeed: async function(context, payload) {
      await context.rootState.deedInstance.registerDeed(payload.deed.tokenId, payload.deed.tokenURI, {from: context.rootState.account})
      .then((txnLog)=>{
        console.log(txnLog)
        // success toast using txnLog.receipt
      })
      .catch(err => console.error(err.message))
      alert(`${await context.rootState.deedInstance.ownerOf(payload.deed.tokenId)} 
        has successfully published token 
        ${await context.rootState.deedInstance.tokenURI(payload.deed.tokenId)}`
      )
    }
  }
}