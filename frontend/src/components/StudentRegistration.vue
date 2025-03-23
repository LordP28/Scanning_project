<template>
  <div class="registration-container">
    <el-card class="registration-card">
      <h2>Student Registration</h2>
      <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
        <el-form-item label="Student ID" prop="student_id">
          <el-input v-model="form.student_id" placeholder="Enter student ID"></el-input>
        </el-form-item>
        <el-form-item label="First Name" prop="first_name">
          <el-input v-model="form.first_name" placeholder="Enter first name"></el-input>
        </el-form-item>
        <el-form-item label="Last Name" prop="last_name">
          <el-input v-model="form.last_name" placeholder="Enter last name"></el-input>
        </el-form-item>
        <el-form-item label="Major" prop="major">
          <el-select v-model="form.major" placeholder="Select major">
            <el-option label="Computer Science" value="Computer Science"></el-option>
            <el-option label="Engineering" value="Engineering"></el-option>
            <el-option label="Business" value="Business"></el-option>
            <el-option label="Arts" value="Arts"></el-option>
          </el-select>
        </el-form-item>
        <el-form-item label="Profile Picture" prop="profile_picture">
          <el-upload
            class="avatar-uploader"
            action="http://localhost:3000/api/upload"
            :show-file-list="false"
            :on-success="handleUploadSuccess"
            :before-upload="beforeUpload"
            :headers="uploadHeaders"
          >
            <img v-if="form.profile_picture" :src="form.profile_picture" class="avatar">
            <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
          </el-upload>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleSubmit" :loading="loading">Register Student</el-button>
        </el-form-item>
      </el-form>
    </el-card>
  </div>
</template>

<script>
import { ref, reactive, computed } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'
import { ElMessage } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'

export default {
  name: 'StudentRegistration',
  components: {
    Plus
  },
  setup() {
    const router = useRouter()
    const formRef = ref(null)
    const form = reactive({
      student_id: '',
      first_name: '',
      last_name: '',
      major: '',
      profile_picture: ''
    })
    const loading = ref(false)

    const uploadHeaders = computed(() => ({
      Authorization: `Bearer ${localStorage.getItem('token')}`
    }))

    const rules = {
      student_id: [
        { required: true, message: 'Please enter student ID', trigger: 'blur' },
        { pattern: /^[A-Z0-9]+$/, message: 'Student ID must contain only uppercase letters and numbers', trigger: 'blur' }
      ],
      first_name: [
        { required: true, message: 'Please enter first name', trigger: 'blur' },
        { min: 2, message: 'First name must be at least 2 characters', trigger: 'blur' }
      ],
      last_name: [
        { required: true, message: 'Please enter last name', trigger: 'blur' },
        { min: 2, message: 'Last name must be at least 2 characters', trigger: 'blur' }
      ],
      major: [
        { required: true, message: 'Please select a major', trigger: 'change' }
      ]
    }

    const handleUploadSuccess = (response) => {
      form.profile_picture = response.url
      ElMessage.success('Profile picture uploaded successfully')
    }

    const beforeUpload = (file) => {
      const isImage = file.type.startsWith('image/')
      const isLt2M = file.size / 1024 / 1024 < 2

      if (!isImage) {
        ElMessage.error('Upload file can only be image format!')
        return false
      }
      if (!isLt2M) {
        ElMessage.error('Upload file size can not exceed 2MB!')
        return false
      }
      return true
    }

    const handleSubmit = async () => {
      if (!formRef.value) return
      
      try {
        await formRef.value.validate()
        loading.value = true
        
        const formData = new FormData()
        Object.keys(form).forEach(key => {
          formData.append(key, form[key])
        })

        const response = await axios.post('http://localhost:3000/api/students', formData, {
          headers: {
            'Content-Type': 'multipart/form-data',
            Authorization: `Bearer ${localStorage.getItem('token')}`
          }
        })

        ElMessage.success('Student registered successfully')
        router.push({
          name: 'QRCodeDisplay',
          query: {
            qr_code_url: response.data.qr_code_url,
            student: JSON.stringify({
              student_id: form.student_id,
              first_name: form.first_name,
              last_name: form.last_name,
              major: form.major
            })
          }
        })
      } catch (error) {
        console.error('Registration error:', error)
        ElMessage.error(error.response?.data?.message || 'Registration failed')
      } finally {
        loading.value = false
      }
    }

    return {
      form,
      formRef,
      rules,
      loading,
      uploadHeaders,
      handleSubmit,
      handleUploadSuccess,
      beforeUpload
    }
  }
}
</script>

<style scoped>
.registration-container {
  padding: 20px;
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: #f5f7fa;
}

.registration-card {
  width: 500px;
}

h2 {
  text-align: center;
  color: #409EFF;
  margin-bottom: 30px;
}

.avatar-uploader {
  text-align: center;
}

.avatar-uploader .avatar {
  width: 178px;
  height: 178px;
  display: block;
}

.avatar-uploader .el-upload {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
  transition: var(--el-transition-duration-fast);
}

.avatar-uploader .el-upload:hover {
  border-color: var(--el-color-primary);
}

.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 178px;
  height: 178px;
  text-align: center;
  line-height: 178px;
}
</style> 