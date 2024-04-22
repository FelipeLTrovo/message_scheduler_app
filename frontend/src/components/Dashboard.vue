<template>
  <div>
      <div class="sign-out center">
        <label @click="signOut">Sign out</label>
      </div>
      <router-link to="/users">Users</router-link>
    <br />
    <router-link to="/messages">Messages</router-link>
    </div>
</template>
<script>
export default {
name: 'Dashboard',
data () {
  return {
    error: '',
    messages: []
  }
},
mounted () {
    window.setInterval(() => {
      this.$http.secured.get('/messages')
      .then(response => { this.messages = response.data })
      .catch(error => this.setError(error, 'Something went wrong'))
    }, 1000)

    window.setInterval(() => {
      for (let i = 0; i < this.messages.length; i++) {
        let tzoffset = (new Date()).getTimezoneOffset() * 60000;
        let localISOTime = (new Date(Date.now() - tzoffset)).toISOString();
        if(this.messages[i].scheduled_date.substring(0,19) === localISOTime.substring(0,19)){
          console.log('rodou')
          window.open(this.messages[i].whatsapp_link,'_blank')
        }
       }
    }, 1000)
  },
created () {
  if (!localStorage.signedIn) {
    this.$router.replace('/')
  }
},
methods: {
  setError (error, text) {
    this.error = (error.response && error.response.data && error.response.data.error) || text
  },
  signOut () {
    this.$http.secured.delete('/signin')
      .then(response => {
        delete localStorage.csrf
        delete localStorage.signedIn
        this.$router.replace('/')
      })
      .catch(error => {
        this.setError(error, 'Cannot sign out')
      })
  }
}
}
</script>
