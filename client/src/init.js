import store from './store'
import Web3 from "web3";
import TruffleContract from "@truffle/contract";
import auction from "../../build/contracts/AuctionRepository.json";
import deed from "../../build/contracts/DeedRepository.json"

export default {
  initWeb3: async function() {
    //Modern dapp browsers
    if(window.ethereum) {
      store.state.web3Provider = window.ethereum;
      console.log("web3Provider = ", store.state.web3Provider);
      try {
        //Request account access
        // await window.ethereum.enable();
        const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
        store.state.account = accounts[0];
      } catch (error) {
        // user denied access
        console.error("user denied account access");
      }
    }
  
    // Legacy dapp browsers....
    else if(window.web3) {
      store.state.web3Provider = window.web3.currentProvider;
      console.log("web3ProviderLegacy = ", window.web3.currentProvider);
    }
    // If no injected web3 instance is detected, fall back to Ganache
    else {
      store.state.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
      console.log("web3provider Ganache", store.state.web3Provider);
    }
    web3 = new Web3(store.state.web3Provider);
  
    this.initContract();
  },
  
  initContract: function() {
    // Instantiate a new truffle contract from the artifact
    store.state.contracts.AuctionRepository = TruffleContract(auction);
    store.state.contracts.DeedRepository = TruffleContract(deed);
    // Set the provider for our contract
    store.state.contracts.AuctionRepository.setProvider(store.state.web3Provider);
    store.state.contracts.DeedRepository.setProvider(store.state.web3Provider);
    this.render();
  },
  
  render: async function() {
    var auctionInstance, deedInstance;
    
    // Load contract data
    store.state.AuctionContractAddress = await store.state.contracts.AuctionRepository.deployed()
    .then(function(instance) {
      auctionInstance = instance;
      return auctionInstance.address;
    }).then(function(contractAddr){
      return contractAddr;
    }).catch(err => console.error(err))
  
    store.state.DeedContractAddress = await store.state.contracts.DeedRepository.deployed()
    .then(function(instance) {
      deedInstance = instance;
      return deedInstance.address;
    }).then(function(contractAddr){
      return contractAddr;
    }).catch(err => console.error(err))
    store.state.deedInstance = deedInstance
    store.state.auctionInstance = auctionInstance
  }
}