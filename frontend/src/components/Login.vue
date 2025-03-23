<template>
  <div class="login-container">
    <el-card class="login-card">
      <h2>Admin Login</h2>
      <el-form :model="form" :rules="rules" ref="formRef" label-width="80px">
        <el-form-item label="Email" prop="email">
          <el-input v-model="form.email" placeholder="Enter your email"></el-input>
        </el-form-item>
        <el-form-item label="Password" prop="password">
          <el-input v-model="form.password" type="password" placeholder="Enter your password"></el-input>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSubmit" :loading="loading">Login</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import { ref, reactive } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'
import { ElMessage } from 'element-plus'

export default {
  name: 'Login',
  setup() {
    const router = useRouter()
    const formRef = ref(null)
    const form = reactive({
      email: '',
      password: ''
    })
    const loading = ref(false)

    const rules = {
      email: [
        { required: true, message: 'Please enter your email', trigger: 'blur' },
        { type: 'email', message: 'Please enter a valid email address', trigger: 'blur' }
      ],
      password: [
        { required: true, message: 'Please enter your password', trigger: 'blur' },
        { min: 6, message: 'Password must be at least 6 characters', trigger: 'blur' }
      ]
    }

    const handleSubmit = async () => {
      if (!formRef.value) return
      
      try {
        await formRef.value.validate()
        loading.value = true
        
        const response = await axios.post('http://localhost:3000/api/admin/login', form)
        localStorage.setItem('token', response.data.token)
        ElMessage.success('Login successful')
        router.push('/register')
      } catch (error) {
        ElMessage.error(error.response?.data?.message || 'Login failed')
      } finally {
        loading.value = false
      }
    }

    return {
      form,
      formRef,
      rules,
      loading,
      handleSubmit
    }
  }
}
</script>

<style scoped>
.login-container {
  height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: #f5f7fa;
}

.login-card {
  width: 400px;
}

h2 {
  text-align: center;
  color: #409EFF;
  margin-bottom: 30px;
}
</style> 