const express = require('express');
const cookieParser = require('cookie-parser');
const session = require('express-session');
const app = express();

// Nécessaire sur Render : le backend est derrière un reverse proxy HTTPS
app.set('trust proxy', 1);

app.use(cookieParser());

// c'est pour utiliser le body pour les requêtes JSON
app.use(express.json());

// Configuration de la session
// En production sur Render : HTTPS actif → secure: true, sameSite: 'none' pour mobile
const isProduction = process.env.NODE_ENV === 'production';
app.use(session({
    secret: process.env.SESSION_SECRET || 'min_max_dev_only',
    resave: false,
    saveUninitialized: false,
    cookie: {
        secure: isProduction,       // true sur Render (HTTPS)
        sameSite: isProduction ? 'none' : 'lax', // 'none' requis pour l'app mobile cross-origin
        maxAge: 24 * 60 * 60 * 1000 // session expire après 24h
    }
}));

const path = require('path');
const cors = require('cors');

// CORS : autorise le site web local et toutes les origines pour l'application mobile Android
const allowedOrigins = process.env.ALLOWED_ORIGINS
    ? process.env.ALLOWED_ORIGINS.split(',')
    : ['http://127.0.0.1:5500'];

app.use(cors({
    origin: (origin, callback) => {
        // Autoriser les requêtes sans origine (ex: app mobile, Postman)
        if (!origin) return callback(null, true);
        if (allowedOrigins.includes(origin)) return callback(null, true);
        return callback(null, true); // En prod mobile, tout autoriser
    },
    credentials: true
}));

// Middleware pour parser les données du formulaire
app.use(express.urlencoded({ extended: true }));

// Servir les fichiers statiques du dossier Vue
app.use(express.static(path.join(__dirname, 'Vue')));


// Importation des routes
const AuthentificationRoutes = require('./Controller/AuthentificationController');
const FilmRoutes = require('./Controller/FilmController');
const LocationRoutes = require('./Controller/LocationController');
const ProfilRoutes = require('./Controller/ProfilController');

// Association des routes 
app.use('/api/auth', AuthentificationRoutes);   
app.use('/api/films', FilmRoutes); 
app.use('/api/rentals', LocationRoutes);
app.use('/api/profil', ProfilRoutes);



// Démarrage du serveur - Render injecte automatiquement process.env.PORT
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});

// Export de l'application 
module.exports = app;
