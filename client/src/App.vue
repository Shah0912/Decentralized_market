<template>
  <div>
    <div id="nav">
      <router-link to="/">Home</router-link> |
      <router-link to="/about">About</router-link>
    </div>
    <router-view/>
    <p>Account Address: {{account}}</p>
    <p>Contract Address: {{contractAddress}}</p>
  </div>
</template>

<script>
import Web3 from "web3";
import TruffleContract from "@truffle/contract";
import auction from "../../build/contracts/AuctionRepository.json";

export default {
  data() {
    return {
      web3Provider: null,
      contracts: {},
      account: '0x0',
      accountAddress: 'not connected',
      contractAddress: 'not connected'
    }
  },
  methods: {
    initWeb3: async function() {
      //Modern dapp browsers
      if(window.ethereum) {
        this.web3Provider = window.ethereum;
        console.log("web3Provider = ", this.web3Provider);
        try {
          //Request account access
          // await window.ethereum.enable();
          const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
          this.account = accounts[0];

        } catch (error) {
          // user denied access
          console.error("user denied account access");
        }
      }

      // Legacy dapp browsers....
      else if(window.web3) {
        this.web3Provider = window.web3.currentProvider;
        console.log("web3ProviderLegacy = ", window.web3.currentProvider);
      }
      // If no injected web3 instance is detected, fall back to Ganache
      else {
        this.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
        console.log("web3provider Ganache", this.web3Provider);
      }
      web3 = new Web3(this.web3Provider);

      return this.initContract();
    },

    initContract: function() {
      // Instantiate a new truffle contract from the artifact
      this.contracts.AuctionRepository = TruffleContract(auction);
      // Set the provider for our contract
      this.contracts.AuctionRepository.setProvider(this.web3Provider);
      return this.render();
    },

    render: async function() {
      var auctionInstance;
      // this.isLoading = true
      
      // Load contract data
      this.contractAddress = await this.contracts.AuctionRepository.deployed().then(function(instance) {
        auctionInstance = instance;
        return auctionInstance.address;
      }).then(function(contractAddr){
        // this.isLoading = false
        return contractAddr;
      }).catch(err => console.error(err))
    }
  },
  created() {
    this.initWeb3();
  }
}
</script>