<template>
    <div>
        <div class="sign-out center">
          <label @click="goBack">Back</label>
          <label @click="signOut">Sign out</label>
        </div>
        <h1>Messages</h1>
        <!-- Create -->
        <input type="text"
            v-model="textMsg"
            placeholder="Message"
            class="title-input" />
        <input type="number"
            v-model="whatsappNumber"
            placeholder="Whatsapp Number"
            class="body-input" />
        <input type="datetime-local"
            step=1
            v-model="scheduleDate"
            placeholder="Schedule Date"
            class="body-input" />

        <!-- only render if editing message -->
        <button v-if="isEditing" @click="updateMessage">Update</button>
        <button v-if="isEditing" @click="cancelEdit">Cancel</button>

        <!-- only render if not editing message -->
        <button v-else @click="addMessage">Create</button>
        <br />
        <br />
        <!-- List of Messages -->
        <div style="margin-bottom: 50px;"v-for="message in messages" :key="message.id">
            <h5>[{{message.id}}] {{ message.text }}</h5>
            <p>{{ message.whatsapp_number }}</p>
            <p>{{ message.scheduled_date }}</p>
            <p>{{ message.whatsapp_link }}</p>
            <button @click="editMessage(message)">Edit</button>
            <button @click="removeMessage(message)">Delete</button>
        </div>
    </div>
</template>
<script>
export default {
  name: 'MessageList',
  data () {
    return {
      messages: [],
      textMsg: [],
      whatsappNumber: [],
      scheduleDate: [],
      error: '',
      isEditing: false,
      msgId: 0
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
    } else {
      this.$http.secured.get('/messages')
        .then(response => { this.messages = response.data })
        .catch(error => this.setError(error, 'Something went wrong'))
    }
  },
  methods: {
    setError (error, text) {
      this.error = (error.response && error.response.data && error.response.data.error) || text
    },
    addMessage () {
      const value = this.textMsg && this.textMsg.trim()
      if (!value) {
        return
      }
      this.$http.secured.post('/messages', { message: { text: this.textMsg,
                                                        whatsapp_number: this.whatsappNumber,
                                                        scheduled_date: this.scheduleDate
                                                        }
                                            })
        .then(response => {
          this.messages.push(response.data)
          this.textMsg = ''
          this.whatsappNumber = ''
          this.scheduleDate = ''
        })
        .catch(error => this.setError(error, 'Cannot create message'))
    },
    removeMessage (message) {
      this.$http.secured.delete(`/messages/${message.id}`)
        .then(response => {
          this.messages.splice(this.messages.indexOf(message), 1)
        })
        .catch(error => this.setError(error, 'Cannot delete message'))
    },
    editMessage (message) {
      this.isEditing = true
      this.textMsg = message.text
      this.whatsappNumber = message.whatsapp_number
      this.scheduleDate = message.scheduled_date.substring(0,19)
      this.msgId = message.id
    },
    updateMessage () {
      this.$http.secured.patch(`/messages/${this.msgId}`, { 
                                                            text: this.textMsg,
                                                            whatsapp_number: this.whatsappNumber,
                                                            scheduled_date: this.scheduleDate
                                                          })
        .then(response => {
          this.textMsg = ''
          this.whatsappNumber = ''
          this.scheduleDate = ''
          this.msgID = 0;
          this.isEditing = false
        })
        .catch(error => this.setError(error, 'Cannot update message'))
    },
    cancelEdit () {
        this.textMsg = ''
        this.whatsappNumber = ''
        this.scheduleDate = ''
        this.msgID = 0;
        this.isEditing = false
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
    },
    goBack () {
      this.$router.back()
    },
  },
  directives: {
    'message-focus': function (el) {
      el.focus()
    }
  }
}
</script>

<style lang="css">
.messages ul li i.fa.fa-trash-alt {
  visibility: hidden;
  margin-top: 5px;
}
.messages ul li:hover {
  background: #fcfcfc;
}
.messages ul li:hover i.fa.fa-trash-alt {
  visibility: visible;
}

input::-webkit-outer-spin-button,
input::-webkit-inner-spin-button {
  -webkit-appearance: none;
  margin: 0;
}
</style>
