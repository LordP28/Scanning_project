import { createRouter, createWebHistory } from 'vue-router'
import Login from '../components/Login.vue'
import StudentRegistration from '../components/StudentRegistration.vue'
import QRCodeDisplay from '../components/QRCodeDisplay.vue'

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
  }
]

const router = createRouter({
  history: createWebHistory(process.env.BASE_URL),
  routes
})

router.beforeEach((to, from, next) => {
  if (to.matched.some(record => record.meta.requiresAuth)) {
    if (!localStorage.getItem('token')) {
      next('/')
    } else {
      next()
    }
  } else {
    next()
  }
})

export default router 