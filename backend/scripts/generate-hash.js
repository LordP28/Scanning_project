const bcrypt = require('bcryptjs');

const password = 'admin123'; // Mot de passe par défaut pour tous les administrateurs
const saltRounds = 10;

bcrypt.hash(password, saltRounds, function(err, hash) {
    if (err) {
        console.error('Erreur lors du hashage:', err);
        return;
    }
    console.log('Mot de passe hashé:', hash);
}); 