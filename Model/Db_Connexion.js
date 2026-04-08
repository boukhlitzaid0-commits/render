const { Pool } = require('pg');
require('dotenv').config();

// En production (Render), DATABASE_URL contient l'Internal Database URL PostgreSQL.
// En local, DATABASE_URL peut pointer vers une instance PostgreSQL locale.
const db = new Pool({
    connectionString: process.env.DATABASE_URL,
    ssl: process.env.NODE_ENV === 'production' ? { rejectUnauthorized: false } : false
});

// Test de la connexion au démarrage
db.connect((err, client, release) => {
    if (err) {
        console.error('Erreur de connexion à la base de données : ' + err.stack);
        return;
    }
    console.log('Connecté à la base de données PostgreSQL');
    release();
});

module.exports = db;
