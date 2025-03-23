const express = require('express');
const cors = require('cors');
const mysql = require('mysql2');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const QRCode = require('qrcode');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const dbConfig = require('./config/db.config');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Créer les dossiers nécessaires s'ils n'existent pas
const uploadsDir = path.join(__dirname, 'uploads');
const qrcodesDir = path.join(__dirname, 'qrcodes');

if (!fs.existsSync(uploadsDir)) {
    fs.mkdirSync(uploadsDir);
}

if (!fs.existsSync(qrcodesDir)) {
    fs.mkdirSync(qrcodesDir);
}

// Servir les fichiers statiques avec des chemins absolus
app.use('/uploads', express.static(uploadsDir));
app.use('/qrcodes', express.static(qrcodesDir));

// Configuration de Multer pour le stockage des images
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, uploadsDir);
    },
    filename: function (req, file, cb) {
        cb(null, Date.now() + path.extname(file.originalname));
    }
});

const upload = multer({ storage: storage });

// Connexion aux bases de données
const adminDb = mysql.createConnection(dbConfig.adminDb);
const studentDb = mysql.createConnection(dbConfig.studentDb);

// Routes d'authentification
app.post('/api/admin/login', async (req, res) => {
    const { email, password } = req.body;
    
    console.log('=== Nouvelle tentative de connexion ===');
    console.log('Email reçu:', email);
    console.log('Mot de passe reçu:', password);
    
    if (!email || !password) {
        console.log('Email ou mot de passe manquant');
        return res.status(400).json({ error: 'Email et mot de passe requis' });
    }

    adminDb.query('SELECT * FROM administrators WHERE email = ?', [email], async (err, results) => {
        if (err) {
            console.error('Erreur de base de données:', err);
            return res.status(500).json({ error: 'Erreur de base de données' });
        }
        
        console.log('Résultats de la requête:', results);
        
        if (results.length === 0) {
            console.log('Aucun administrateur trouvé avec cet email');
            return res.status(401).json({ error: 'Email ou mot de passe incorrect' });
        }

        console.log('Administrateur trouvé, vérification du mot de passe');
        console.log('Hash stocké dans la base de données:', results[0].password);

        try {
            const validPassword = await bcrypt.compare(password, results[0].password);
            console.log('Résultat de la comparaison des mots de passe:', validPassword);

            if (!validPassword) {
                console.log('Mot de passe incorrect');
                return res.status(401).json({ error: 'Email ou mot de passe incorrect' });
            }

            console.log('Connexion réussie pour:', email);
            const token = jwt.sign({ id: results[0].id }, 'your-secret-key', { expiresIn: '1h' });
            res.json({ token });
        } catch (error) {
            console.error('Erreur lors de la comparaison des mots de passe:', error);
            res.status(500).json({ error: 'Erreur lors de l\'authentification' });
        }
    });
});

// Routes pour la gestion des étudiants
app.post('/api/students', upload.single('profile_picture'), async (req, res) => {
    const { student_id, first_name, last_name, major } = req.body;
    const profile_picture = req.file ? `/uploads/${req.file.filename}` : null;
    
    // Génération du QR code
    const qr_code = `QR${Date.now()}`;
    const qrImagePath = path.join(qrcodesDir, `${qr_code}.png`);
    
    try {
        await QRCode.toFile(qrImagePath, qr_code);
        const qr_code_url = `http://localhost:3000/qrcodes/${qr_code}.png`;
        
        studentDb.query(
            'INSERT INTO students1 (student_id, first_name, last_name, major, profile_picture, qr_code) VALUES (?, ?, ?, ?, ?, ?)',
            [student_id, first_name, last_name, major, profile_picture, qr_code],
            (err, results) => {
                if (err) {
                    console.error('Erreur de base de données:', err);
                    return res.status(500).json({ error: 'Erreur de base de données' });
                }
                res.status(201).json({ 
                    message: 'Étudiant créé avec succès', 
                    qr_code_url 
                });
            }
        );
    } catch (error) {
        console.error('Erreur lors de la génération du QR code:', error);
        res.status(500).json({ error: 'Erreur lors de la génération du QR code' });
    }
});

// Route pour vérifier le QR code
app.get('/api/students/verify/:qr_code', (req, res) => {
    const { qr_code } = req.params;
    
    studentDb.query('SELECT * FROM students1 WHERE qr_code = ?', [qr_code], (err, results) => {
        if (err) {
            console.error('Erreur de base de données:', err);
            return res.status(500).json({ error: 'Erreur de base de données' });
        }
        
        if (results.length === 0) {
            return res.status(404).json({ error: 'QR code invalide' });
        }
        
        res.json(results[0]);
    });
});

// Démarrage du serveur
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
}); 