const mysql = require('mysql2');
const bcrypt = require('bcryptjs');
const dbConfig = require('../config/db.config');

// Créer une connexion sans spécifier de base de données
const connection = mysql.createConnection({
    host: dbConfig.adminDb.host,
    user: dbConfig.adminDb.user,
    password: dbConfig.adminDb.password
});

const password = 'admin123';
const saltRounds = 10;

async function createDatabase() {
    return new Promise((resolve, reject) => {
        connection.query('CREATE DATABASE IF NOT EXISTS admin_db', (err) => {
            if (err) {
                console.error('Erreur lors de la création de la base de données:', err);
                reject(err);
                return;
            }
            console.log('Base de données admin_db créée avec succès');
            resolve();
        });
    });
}

async function updatePasswords() {
    try {
        // Créer d'abord la base de données
        await createDatabase();
        
        // Utiliser la base de données
        connection.query('USE admin_db', async (err) => {
            if (err) {
                console.error('Erreur lors de la sélection de la base de données:', err);
                connection.end();
                return;
            }

            // Vérifier si la table existe
            connection.query('SHOW TABLES LIKE "administrators"', async (err, results) => {
                if (err) {
                    console.error('Erreur lors de la vérification de la table:', err);
                    connection.end();
                    return;
                }

                if (results.length === 0) {
                    console.log('La table administrators n\'existe pas. Création de la table...');
                    // Créer la table si elle n'existe pas
                    const createTableQuery = `
                        CREATE TABLE IF NOT EXISTS administrators (
                            id INT AUTO_INCREMENT PRIMARY KEY,
                            email VARCHAR(255) NOT NULL UNIQUE,
                            password VARCHAR(255) NOT NULL,
                            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                        )
                    `;
                    connection.query(createTableQuery, async (err) => {
                        if (err) {
                            console.error('Erreur lors de la création de la table:', err);
                            connection.end();
                            return;
                        }
                        await insertAdmins();
                    });
                } else {
                    await insertAdmins();
                }
            });
        });
    } catch (error) {
        console.error('Erreur:', error);
        connection.end();
    }
}

async function insertAdmins() {
    try {
        const hash = await bcrypt.hash(password, saltRounds);
        console.log('Hash généré:', hash);

        // D'abord, supprimer les administrateurs existants
        connection.query('DELETE FROM administrators', async (err) => {
            if (err) {
                console.error('Erreur lors de la suppression:', err);
                connection.end();
                return;
            }

            // Insérer les nouveaux administrateurs
            const insertQuery = `
                INSERT INTO administrators (email, password) VALUES 
                ('admin1@university.com', ?),
                ('admin2@university.com', ?),
                ('admin3@university.com', ?),
                ('admin4@university.com', ?),
                ('admin5@university.com', ?)
            `;

            connection.query(insertQuery, [hash, hash, hash, hash, hash], (err, results) => {
                if (err) {
                    console.error('Erreur lors de l\'insertion:', err);
                    connection.end();
                    return;
                }
                console.log('Administrateurs créés avec succès:', results);
                connection.end();
            });
        });
    } catch (error) {
        console.error('Erreur:', error);
        connection.end();
    }
}

updatePasswords(); 