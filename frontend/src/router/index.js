import { createRouter, createWebHistory } from 'vue-router'
import Login from '../components/Login.vue'
import StudentRegistration from '../components/StudentRegistration.vue'
import QRCodeDisplay from '../components/QRCodeDisplay.vue'
import StudentHistory from '../components/StudentHistory.vue'

const routes = [
  {
    path: '/',
    name: 'Login',
    component: Login
  },
  {
    path: '/register',
    name: 'StudentRegistration',
    component: StudentRegistration,
    meta: { requiresAuth: true }
  },
  {
    path: '/qr-code',
    name: 'QRCodeDisplay',
    component: QRCodeDisplay,
    meta: { requiresAuth: true }
  },
  {
    path: '/history',
    name: 'StudentHistory',
    component: StudentHistory,
    meta: { requiresAuth: true }
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

router.beforeEach((to, from, next) => {
  const isAuthenticated = localStorage.getItem('token')
  
  if (to.meta.requiresAuth && !isAuthenticated) {
    next('/')
  } else {
    next()
  }
})

export default router 