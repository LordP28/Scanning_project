const mysql = require('mysql2/promise');
const bcrypt = require('bcryptjs');

const dbConfig = {
  host: 'localhost',
  user: 'root',
  password: '', // Laissez vide si pas de mot de passe
};

async function initializeDatabase() {
  try {
    // Créer la connexion
    const connection = await mysql.createConnection(dbConfig);

    // Créer la base de données admin_db
    await connection.query('CREATE DATABASE IF NOT EXISTS admin_db');
    await connection.query('USE admin_db');

    // Créer la table administrators
    await connection.query(`
      CREATE TABLE IF NOT EXISTS administrators (
        id INT AUTO_INCREMENT PRIMARY KEY,
        email VARCHAR(255) NOT NULL UNIQUE,
        password VARCHAR(255) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);

    // Créer la base de données student_db
    await connection.query('CREATE DATABASE IF NOT EXISTS student_db');
    await connection.query('USE student_db');

    // Créer la table students1
    await connection.query(`
      CREATE TABLE IF NOT EXISTS students1 (
        id INT AUTO_INCREMENT PRIMARY KEY,
        student_id VARCHAR(50) NOT NULL UNIQUE,
        first_name VARCHAR(100) NOT NULL,
        last_name VARCHAR(100) NOT NULL,
        major VARCHAR(100) NOT NULL,
        profile_picture VARCHAR(255),
        qr_code VARCHAR(255),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    `);

    // Générer le hash du mot de passe admin
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash('admin123', salt);

    // Insérer l'administrateur par défaut
    await connection.query('USE admin_db');
    await connection.query(`
      INSERT INTO administrators (email, password)
      VALUES ('admin1@university.com', ?)
      ON DUPLICATE KEY UPDATE password = ?
    `, [hashedPassword, hashedPassword]);

    console.log('Database initialized successfully');
    await connection.end();
  } catch (error) {
    console.error('Error initializing database:', error);
  }
}

initializeDatabase(); 