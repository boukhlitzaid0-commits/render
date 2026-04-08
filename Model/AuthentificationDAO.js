const db = require('./Db_Connexion');
const bcrypt = require('bcrypt');

class AuthentificationDAO {

    /**
     * Inscrit un nouvel utilisateur s'il n'existe pas déjà dans la base.
     */
    static SetInscription(user, callback) {

        const checkSql = "SELECT id FROM users WHERE email = $1";

        db.query(checkSql, [user.email], (err, results) => {
            if (err) {
                console.error("Erreur lors de la vérification de l'email : " + err.stack);
                return callback(err, null);
            }

            if (results.rows.length > 0) {
                // L'utilisateur existe déjà
                return callback(null, { exists: true });
            }

            // L'utilisateur n'existe pas, on fait une insertion
            const insertSql = "INSERT INTO users (name, email, password) VALUES ($1, $2, $3) RETURNING id";
            db.query(insertSql, [user.name, user.email, user.password], (err, insertResults) => {
                if (err) {
                    console.error("Erreur d'inscription : " + err.stack);
                    return callback(err, null);
                }

                callback(null, { success: true, insertId: insertResults.rows[0].id });
            });
        });
    }

    /**
     * Vérifie si les identifiants fournis correspondent à un utilisateur existant.
     */
    static SetLogin(user, callback) {
        const sql = "SELECT id, email, password, name FROM users WHERE email = $1";
        db.query(sql, [user.email], async (err, results) => {
            if (err) {
                console.error('Erreur lors de la connexion : ' + err.stack);
                return callback(err, null);
            }

            if (results.rows.length === 0) {
                return callback(null, false);
            }

            const dbUser = results.rows[0];

            try {
                const isMatch = await bcrypt.compare(user.password, dbUser.password);
                if (!isMatch) return callback(null, false);

                callback(null, dbUser);

            } catch (e) {
                callback(e, null);
            }
        });
    }

    // pour la Déconnexion
    static Logout(callback) {
        callback(null, callback);
    }
}

module.exports = AuthentificationDAO;
