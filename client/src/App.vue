<template>
  <div>
    <div id="nav">
      <router-link to="/">Auction</router-link> |
      <router-link to="/deed">Deed</router-link> |
      <div class="tooltip">Account <span class="tooltiptext">{{account}}</span> </div>
    </div>
    <router-view/>
  </div>
</template>

<script>

export default {
  computed: {
    account() {
      return this.$store.state.account;
    }
  }
}
</script>

<style scoped>
.tooltip {
  position: relative;
  display: inline-block;
  border-bottom: 1px solid black;
}

.tooltip .tooltiptext {
  visibility: hidden;
  background-color: rgba(0, 0, 0, 0.7);
  color: #fff;
  text-align: center;
  border-radius: 6px;
  padding: 5px;
  position: absolute;
  z-index: 1;
  top: 100%;
  left: 50%;
}

.tooltip:hover .tooltiptext {
  visibility: visible;
}
</style>