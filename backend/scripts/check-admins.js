const mysql = require('mysql2');
const dbConfig = require('../config/db.config');

const connection = mysql.createConnection(dbConfig.adminDb);

connection.query('SELECT * FROM administrators', (err, results) => {
    if (err) {
        console.error('Erreur lors de la vérification des administrateurs:', err);
        connection.end();
        return;
    }

    console.log('=== Contenu de la table administrators ===');
    console.log('Nombre d\'administrateurs:', results.length);
    results.forEach((admin, index) => {
        console.log(`\nAdministrateur ${index + 1}:`);
        console.log('ID:', admin.id);
        console.log('Email:', admin.email);
        console.log('Hash du mot de passe:', admin.password);
        console.log('Date de création:', admin.created_at);
    });

    connection.end();
}); 