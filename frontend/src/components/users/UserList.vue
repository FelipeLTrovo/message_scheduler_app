<template>
  <div>
      <div class="sign-out center">
        <label @click="goBack">Back</label>
        <label @click="signOut">Sign out</label>
      </div>
      <h1>Users</h1>

        <!-- Create -->
        <input type="text"
            v-model="name"
            placeholder="Name"
            class="title-input" />
        <input type="email"
            v-model="email"
            placeholder="Email"
            class="body-input" />
        <input type="password"
            v-model="password"
            placeholder="Password"
            class="body-input" />
        <input type="password"
            v-model="passwordConfirmation"
            placeholder="Password Confirmation"
            class="body-input" />

        <!-- only render if editing user -->
        <button v-if="isEditing" @click="updateUser">Update</button>
        <button v-if="isEditing" @click="cancelEdit">Cancel</button>

        <!-- only render if not editing user -->
        <button v-else @click="addUser">Create</button>
        <br
        <!-- List of Users -->
        <div v-for="user in users" :key="user.id">
            <br />
            <h5>[{{user.email}}] {{ user.name }}</h5>
            <p>{{ user.email }}</p>


            <button @click="editUser(user)">Edit</button>
            <button @click="removeUser(user)">Delete</button>
        </div>
    </div>
</template>
<script>
export default {
name: 'UserList',
data () {
  return {
    messages: [],
    users: [],
    name: [],
    email: [],
    password: [],
    passwordConfirmation: [],
    error: '',
    isEditing: false,
    userId: 0
  }
},
mounted () {
  window.setInterval(() => {
    this.$http.secured.get('/messages')
    .then(response => { this.messages = response.data })
    .catch(error => this.setError(error, 'Something went wrong'))
  }, 1000)

  window.setInterval(() => {
    this.$http.secured.get('/users')
    .then(response => { this.users = response.data })
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
    this.$http.secured.get('/users')
      .then(response => { this.users = response.data })
      .catch(error => this.setError(error, 'Something went wrong'))
  }
},
methods: {
  setError (error, text) {
    this.error = (error.response && error.response.data && error.response.data.error) || text
  },
  addUser () {
    const value = this.email && this.email.trim()
    if (!value) {
      return
    }
    this.$http.secured.post('/users', { user: { name: this.name,
                                                email: this.email,
                                                password: this.password,
                                                password_confirmation: this.passwordConfirmation
                                              }
                                          })
      .then(response => {
        this.users.push(response.data)
        this.name = ''
        this.email = ''
        this.password = ''
        this.passwordConfirmation = ''
      })
      .catch(error => this.setError(error, 'Cannot create user'))
  },
  removeUser (user) {
    this.$http.secured.delete(`/users/${user.id}`)
      .then(response => {
        this.users.splice(this.messages.indexOf(user), 1)
      })
      .catch(error => this.setError(error, 'Cannot delete user'))
  },
  editUser (user) {
    this.isEditing = true
    this.name = user.name
    this.email = user.email
    this.password = ''
    this.passwordConfirmation = ''
    this.userId = user.id
  },
  updateUser () {
    this.$http.secured.patch(`/users/${this.userId}`, { 
                                                          name: this.name,
                                                          email: this.email,
                                                          password: this.password,
                                                          password_confirmation: this.passwordConfirmation
                                                      })
      .then(response => {
        this.name = ''
        this.email = ''
        this.password = ''
        this.passwordConfirmation = ''
        this.userId = 0;
        this.isEditing = false
      })
      .catch(error => this.setError(error, 'Cannot update user'))
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
</style>
