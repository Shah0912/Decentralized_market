<template>
  <div>
    <div id="nav">
      <router-link to="/">Home</router-link> |
      <router-link to="/about">About</router-link>
    </div>
    <router-view/>
    <p>Account Address: {{account}}</p>
    <p>AuctionRepo Contract Address: {{AuctionContractAddress}}</p>
    <p>DeedRepo Contract Address: {{DeedContractAddress}}</p>
  </div>
</template>

<script>

export default {
  computed: {
    account() {
      return this.$store.state.account;
    },
    AuctionContractAddress() {
      return this.$store.state.AuctionContractAddress;
    },
    DeedContractAddress() {
      return this.$store.state.DeedContractAddress;
    }
  }
}
</script>