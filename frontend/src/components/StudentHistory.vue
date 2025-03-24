<template>
  <div class="student-history">
    <h2>Student Registred History</h2>
    
    <div class="filters">
      <input 
        v-model="searchQuery" 
        type="text" 
        placeholder="Search A Student..."
        class="search-input"
      />
      <select v-model="selectedMajor" class="major-select">
        <option value="">All Majors</option>
        <option v-for="major in uniqueMajors" :key="major" :value="major">
          {{ major }}
        </option>
      </select>
    </div>

    <div v-if="loading" class="loading">
      Loading data...
    </div>

    <div v-else-if="error" class="error">
      {{ error }}
    </div>

    <div v-else>
      <table class="student-table">
        <thead>
          <tr>
            <th @click="sortBy('student_id')">Student ID</th>
            <th @click="sortBy('first_name')">First Name</th>
            <th @click="sortBy('last_name')">Last Name</th>
            <th @click="sortBy('major')">Major</th>
            <th @click="sortBy('created_at')">Registration Date</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="student in filteredStudents" :key="student.id">
            <td>{{ student.student_id }}</td>
            <td>{{ student.first_name }}</td>
            <td>{{ student.last_name }}</td>
            <td>{{ student.major }}</td>
            <td>{{ formatDate(student.created_at) }}</td>
            <td>
              <button @click="viewDetails(student)" class="view-btn">
                View details
              </button>
            </td>
          </tr>
        </tbody>
      </table>

      <div class="pagination">
        <button 
          @click="currentPage--" 
          :disabled="currentPage === 1"
          class="pagination-btn"
        >
          Previous
        </button>
        <span>Page {{ currentPage }} sur {{ totalPages }}</span>
        <button 
          @click="currentPage++" 
          :disabled="currentPage === totalPages"
          class="pagination-btn"
        >
          Next
        </button>
      </div>
    </div>

    <!-- Modal pour les détails -->
    <div v-if="selectedStudent" class="modal">
      <div class="modal-content">
        <span class="close" @click="selectedStudent = null">&times;</span>
        <h3>Student Details</h3>
        <div class="student-details">
          <img 
            :src="`http://localhost:3000${selectedStudent.profile_picture}`" 
            :alt="selectedStudent.first_name"
            class="student-image"
          />
          <div class="details-info">
            <p><strong>ID:</strong> {{ selectedStudent.student_id }}</p>
            <p><strong>Last Name:</strong> {{ selectedStudent.last_name }}</p>
            <p><strong>First Name:</strong> {{ selectedStudent.first_name }}</p>
            <p><strong>Major:</strong> {{ selectedStudent.major }}</p>
            <p><strong>Registration Date:</strong> {{ formatDate(selectedStudent.created_at) }}</p>
            <img 
              :src="`http://localhost:3000/qrcodes/${selectedStudent.qr_code}.png`" 
              :alt="`QR Code de ${selectedStudent.first_name}`"
              class="qr-code"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  name: 'StudentHistory',
  data() {
    return {
      students: [],
      loading: true,
      error: null,
      searchQuery: '',
      selectedMajor: '',
      currentPage: 1,
      itemsPerPage: 10,
      sortField: 'created_at',
      sortOrder: 'desc',
      selectedStudent: null
    };
  },
  computed: {
    filteredStudents() {
      let filtered = this.students;
      
      // Filtre par recherche
      if (this.searchQuery) {
        const query = this.searchQuery.toLowerCase();
        filtered = filtered.filter(student => 
          student.student_id.toLowerCase().includes(query) ||
          student.first_name.toLowerCase().includes(query) ||
          student.last_name.toLowerCase().includes(query)
        );
      }
      
      // Filtre par filière
      if (this.selectedMajor) {
        filtered = filtered.filter(student => 
          student.major === this.selectedMajor
        );
      }
      
      // Tri
      filtered.sort((a, b) => {
        const aValue = a[this.sortField];
        const bValue = b[this.sortField];
        return this.sortOrder === 'asc' 
          ? aValue.localeCompare(bValue)
          : bValue.localeCompare(aValue);
      });
      
      // Pagination
      const start = (this.currentPage - 1) * this.itemsPerPage;
      const end = start + this.itemsPerPage;
      return filtered.slice(start, end);
    },
    totalPages() {
      return Math.ceil(this.filteredStudents.length / this.itemsPerPage);
    },
    uniqueMajors() {
      return [...new Set(this.students.map(student => student.major))];
    }
  },
  methods: {
    async fetchStudents() {
      try {
        const response = await axios.get('http://localhost:3000/api/students');
        this.students = response.data;
        this.loading = false;
      } catch (error) {
        this.error = 'Error loading data';
        this.loading = false;
        console.error('Error:', error);
      }
    },
    sortBy(field) {
      if (this.sortField === field) {
        this.sortOrder = this.sortOrder === 'asc' ? 'desc' : 'asc';
      } else {
        this.sortField = field;
        this.sortOrder = 'asc';
      }
    },
    formatDate(dateString) {
      const date = new Date(dateString);
      return date.toLocaleDateString('fr-FR', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
      });
    },
    viewDetails(student) {
      this.selectedStudent = student;
    }
  },
  mounted() {
    this.fetchStudents();
  }
};
</script>

<style scoped>
.student-history {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
}

.filters {
  display: flex;
  gap: 20px;
  margin-bottom: 20px;
}

.search-input, .major-select {
  padding: 8px;
  border: 1px solid #ddd;
  border-radius: 4px;
  font-size: 14px;
}

.student-table {
  width: 100%;
  border-collapse: collapse;
  margin-bottom: 20px;
}

.student-table th, .student-table td {
  padding: 12px;
  text-align: left;
  border-bottom: 1px solid #ddd;
}

.student-table th {
  background-color: #f5f5f5;
  cursor: pointer;
}

.student-table th:hover {
  background-color: #e9e9e9;
}

.pagination {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 20px;
  margin-top: 20px;
}

.pagination-btn {
  padding: 8px 16px;
  border: none;
  background-color: #4CAF50;
  color: white;
  cursor: pointer;
  border-radius: 4px;
}

.pagination-btn:disabled {
  background-color: #cccccc;
  cursor: not-allowed;
}

.modal {
  display: block;
  position: fixed;
  z-index: 1;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  background-color: rgba(0,0,0,0.4);
}

.modal-content {
  background-color: #fefefe;
  margin: 5% auto;
  padding: 20px;
  border: 1px solid #888;
  width: 80%;
  max-width: 600px;
  border-radius: 8px;
}

.close {
  color: #aaa;
  float: right;
  font-size: 28px;
  font-weight: bold;
  cursor: pointer;
}

.close:hover {
  color: black;
}

.student-details {
  display: flex;
  gap: 20px;
  margin-top: 20px;
}

.student-image {
  width: 150px;
  height: 150px;
  object-fit: cover;
  border-radius: 8px;
}

.details-info {
  flex: 1;
}

.qr-code {
  width: 150px;
  height: 150px;
  margin-top: 20px;
}

.view-btn {
  padding: 6px 12px;
  background-color: #2196F3;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
}

.view-btn:hover {
  background-color: #0b7dda;
}

.loading, .error {
  text-align: center;
  padding: 20px;
  font-size: 18px;
}

.error {
  color: red;
}
</style> 