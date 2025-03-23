module.exports = {
    adminDb: {
        host: 'localhost',
        user: 'root',
        password: '',
        database: 'admin_db',
        waitForConnections: true,
        connectionLimit: 10,
        queueLimit: 0
    },
    studentDb: {
        host: 'localhost',
        user: 'root',
        password: '',
        database: 'student_db',
        waitForConnections: true,
        connectionLimit: 10,
        queueLimit: 0
    },
    HOST: "localhost",
    USER: "root",
    PASSWORD: "", // Laissez vide si pas de mot de passe
    DB: "student_db",
    dialect: "mysql",
    pool: {
        max: 5,
        min: 0,
        acquire: 30000,
        idle: 10000
    }
}; 