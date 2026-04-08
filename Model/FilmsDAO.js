const db = require('./Db_Connexion');

class FilmsDAO {

    static getFilmById(Id, callback) {
        const sql = 'SELECT * FROM films WHERE id = $1';
        db.query(sql, [Id], (err, results) => {
            if (err) {
                console.error('Erreur : ' + err.stack);
                return callback(err, null);
            }
            callback(null, results.rows);
        });
    }

    static getFilmsByFilters(filters, callback) {
        let sql = 'SELECT * FROM films WHERE 1=1';
        const params = [];
        let paramIndex = 1;

        // Filtre par titre (recherche partielle insensible à la casse)
        if (filters.title) {
            sql += ` AND LOWER(title) LIKE LOWER($${paramIndex++})`;
            params.push(`%${filters.title}%`);
        }

        // Filtre par réalisateur ou acteur (recherche partielle insensible à la casse)
        if (filters.name) {
            sql += ` AND (LOWER(realisateurs) LIKE LOWER($${paramIndex}) OR LOWER(acteurs) LIKE LOWER($${paramIndex + 1}))`;
            const searchTerm = `%${filters.name}%`;
            params.push(searchTerm, searchTerm);
            paramIndex += 2;
        }

        // Filtre par genre (recherche partielle insensible à la casse)
        if (filters.genre) {
            sql += ` AND LOWER(genre) LIKE LOWER($${paramIndex++})`;
            params.push(`%${filters.genre}%`);
        }

        // Tri par défaut : titre
        sql += ' ORDER BY title ASC';

        db.query(sql, params, (err, results) => {
            if (err) {
                console.error('Erreur :', err.stack);
                return callback(err, null);
            }
            callback(null, results.rows);
        });
    }

    // Récupérer tous les genres uniques (PostgreSQL : unnest + string_to_array)
    static getAllGenres(callback) {
        const sql = `
            SELECT DISTINCT TRIM(unnest(string_to_array(genre, ','))) AS genre_name
            FROM films
            ORDER BY genre_name
        `;

        db.query(sql, (err, results) => {
            if (err) {
                console.error('Erreur lors de la récupération des genres :', err.stack);
                return callback(err, null);
            }
            callback(null, results.rows);
        });
    }
}

module.exports = FilmsDAO;
