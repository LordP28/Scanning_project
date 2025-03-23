<template>
  <div class="qr-display-container">
    <el-card class="qr-card">
      <h2>Student QR Code</h2>
      <div class="student-info">
        <p><strong>ID:</strong> {{ studentInfo.student_id }}</p>
        <p><strong>Last Name:</strong> {{ studentInfo.last_name }}</p>
        <p><strong>First Name:</strong> {{ studentInfo.first_name }}</p>
        <p><strong>Major:</strong> {{ studentInfo.major }}</p>
      </div>
      
      <div class="qr-code-container">
        <img :src="qrCodeUrl" alt="QR Code" class="qr-code" />
        <el-button type="primary" @click="downloadQRCode" class="download-btn">
          Download QR Code
        </el-button>
      </div>

      <div class="actions">
        <el-button @click="goToRegistration">Register Another Student</el-button>
      </div>
    </el-card>
  </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'

export default {
  name: 'QRCodeDisplay',
  setup() {
    const router = useRouter()
    const route = useRoute()
    const qrCodeUrl = ref('')
    const studentInfo = ref({})

    onMounted(() => {
      const { qr_code_url, student } = route.query
      if (qr_code_url) {
        qrCodeUrl.value = qr_code_url
      }
      if (student) {
        try {
          studentInfo.value = JSON.parse(student)
        } catch (error) {
          console.error('Error parsing student data:', error)
        }
      }
    })

    const downloadQRCode = () => {
      const link = document.createElement('a')
      link.href = qrCodeUrl.value
      link.download = `qr-code-${studentInfo.value.student_id}.png`
      document.body.appendChild(link)
      link.click()
      document.body.removeChild(link)
    }

    const goToRegistration = () => {
      router.push('/register')
    }

    return {
      qrCodeUrl,
      studentInfo,
      downloadQRCode,
      goToRegistration
    }
  }
}
</script>

<style scoped>
.qr-display-container {
  padding: 20px;
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: #f5f7fa;
}

.qr-card {
  max-width: 600px;
  width: 100%;
  text-align: center;
}

h2 {
  color: #409EFF;
  margin-bottom: 30px;
}

.student-info {
  text-align: left;
  margin-bottom: 30px;
  padding: 20px;
  background-color: #f8f9fa;
  border-radius: 8px;
}

.student-info p {
  margin: 10px 0;
}

.qr-code-container {
  margin: 30px 0;
}

.qr-code {
  max-width: 300px;
  margin-bottom: 20px;
  border: 1px solid #dcdfe6;
  padding: 10px;
  border-radius: 4px;
}

.download-btn {
  margin-top: 20px;
}

.actions {
  margin-top: 30px;
}
</style> 