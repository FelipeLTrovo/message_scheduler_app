import Vue from 'vue'
import Router from 'vue-router'
import Signin from '@/components/Signin'
import Signup from '@/components/Signup'
import MessageList from '@/components/messages/MessageList'
import UserList from '@/components/users/UserList'
import Dashboard from '@/components/Dashboard'


Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Signin',
      component: Signin
    },
    {
      path: '/signup',
      name: 'Signup',
      component: Signup
    },
    {
      path: '/messages',
      name: 'MessageList',
      component: MessageList
    },
    {
      path: '/users',
      name: 'UserList',
      component: UserList
    },
    {
      path: '/dashboard',
      name: 'Dashboard',
      component: Dashboard
    },
  ]
})
