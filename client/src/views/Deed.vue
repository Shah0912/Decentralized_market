<template>
  <div>
    <form @submit.prevent="registerDeed()">
      <input type="text" v-model="deed.tokenId" placeholder="token ID" required>
      <input type="text" v-model="deed.tokenURI" placeholder="token URI" required>
      <button type="submit">done</button>
    </form>
  </div>
</template>

<script>
export default {
  data() {
    return {
      deed: {
        tokenId: '',
        tokenURI: ''
      },
    }
  },
  methods: {
    async registerDeed() {
      this.$store.dispatch('registerDeed', { deed: this.deed })
      this.deed.tokenId = ''
      this.deed.tokenURI = ''
    }
  }
}
</script>