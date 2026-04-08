-- ============================================================
-- Schéma PostgreSQL compatible Render
-- Remplace conception_BD.txt (MySQL) pour le déploiement cloud
-- ============================================================

-- Suppression des tables si elles existent déjà (pour ré-initialisation propre)
DROP TABLE IF EXISTS rentals;
DROP TABLE IF EXISTS films;
DROP TABLE IF EXISTS users;

-- Table users
-- SERIAL remplace INT AUTO_INCREMENT (PostgreSQL)
-- TIMESTAMP remplace DATETIME
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    date_inscription DATE DEFAULT CURRENT_DATE
);

-- Table films
-- id est fourni manuellement (pas d'auto-incrément)
-- SMALLINT remplace le type YEAR (non supporté en PostgreSQL)
CREATE TABLE films (
    id INTEGER PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    genre VARCHAR(255),
    annee_sortie SMALLINT,
    langue_originale VARCHAR(100),
    pays_productions VARCHAR(255),
    acteurs TEXT,
    realisateurs VARCHAR(255),
    available_copies INTEGER DEFAULT 0,
    imgpath VARCHAR(500),
    trailer VARCHAR(500)
);

-- Table rentals
-- TIMESTAMP remplace DATETIME
-- Clés étrangères vers users et films
CREATE TABLE rentals (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    film_id INTEGER NOT NULL,
    rental_date TIMESTAMP NOT NULL,
    return_date TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (film_id) REFERENCES films(id)
);

-- ============================================================
-- Données de test : utilisateurs
-- Mots de passe hashés avec bcrypt (coût 12)
-- ============================================================
INSERT INTO users (name, email, password) VALUES
('Jean Dupont', 'jean.dupont@example.com', '$2a$12$hcDwUii.IN.ugY9F9vmp3OBwQtrssRhI0NTAXELo92nO6TOLTnqzu'),
('Marie Martin', 'marie.martin@example.com', '$2a$12$vjTXIrVboLAKcuVY55i6Mub8lU0PChmbrQ4zDou0PPFqc9Pf6bnAK'),
('Lucie Bernard', 'lucie.bernard@example.com', '$2a$12$Bsm3cyteTJ8JDYCFQAlvGuukxNlqEsZDfqDZu8JP5WTi.Uo0CPUH6'),
('Pierre Moreau', 'pierre.moreau@example.com', '$2b$10$6zmbzeI67s8lBXR9srjnFuiqmCGkbLNlVL2ccnPkdZMI36cxtdhY2');

-- ============================================================
-- Données de test : films
-- ============================================================
INSERT INTO films (id, title, genre, annee_sortie, langue_originale, pays_productions, acteurs, realisateurs, available_copies, imgpath, trailer)
VALUES (
  100758,
  'Teenage Mutant Ninja Turtles',
  'Action, Adventure, Comedy, Crime, Drama, Family, Sci-Fi',
  1990,
  'English',
  'Hong Kong, USA',
  'Brian Tochi, Corey Feldman, David Forman, David McCharen, Elias Koteas, James Saito, Josh Pais, Judith Hoag, Kevin Clash, Leif Tilden, Michael McConnohie, Michael Turney, Michelan Sisti, Robbie Rist, Toshirô Obata',
  'Steve Barron',
  7,
  'https://www.themoviedb.org/t/p/w1280/eLNxn5R7xngthiRc6HoQC4dqzbF.jpg',
  'https://www.youtube.com/embed/zxkqixUKZt8?si=rzuudzSmM9n9AZm9'
);

INSERT INTO films (id, title, genre, annee_sortie, langue_originale, pays_productions, acteurs, realisateurs, available_copies, imgpath, trailer)
VALUES (
  1013752,
  'Fast & Furious',
  'Action, Crime, Drama, Thriller',
  2009,
  'English',
  'USA',
  'Gal Gadot, Greg Cipes, Jack Conley, John Ortiz, Jordana Brewster, Laz Alonso, Liza Lapira, Michelle Rodriguez, Mirtha Michelle, Paul Walker, Shea Whigham, Sung Kang, Vin Diesel',
  'Justin Lin',
  15,
  'https://www.themoviedb.org/t/p/w1280/wtn3emVfshQIt7Y9pXYRFw4xCuF.jpg',
  'https://www.youtube.com/embed/k98tBkRsGl4?si=JR7psyc-ZOoD4Ldo'
);

INSERT INTO films (id, title, genre, annee_sortie, langue_originale, pays_productions, acteurs, realisateurs, available_copies, imgpath, trailer)
VALUES (
  102057,
  'Hook',
  'Adventure, Family, Fantasy',
  1991,
  'English',
  'USA',
  'Amber Scott, Arthur Malet, Bob Hoskins, Caroline Goodall, Charlie Korsmo, Dante Basco, Dustin Hoffman, Isaiah Robinson, Jasen Fisher, Julia Roberts, Maggie Smith, Phil Collins, Raushan Hammond, Robin Williams',
  'Steven Spielberg',
  9,
  'https://www.themoviedb.org/t/p/w1280/4iX6zocr2bd1GfjdDjLm6DHz6OR.jpg',
  'https://www.youtube.com/embed/c-vwgt8cwEM?si=KQ8X6bNXGZVgK9AO'
);

INSERT INTO films (id, title, genre, annee_sortie, langue_originale, pays_productions, acteurs, realisateurs, available_copies, imgpath, trailer)
VALUES (
  105417,
  'Sister Act',
  'Comedy, Crime, Music',
  1992,
  'English',
  'USA',
  'Bill Nunn, Carmen Zapata, Ellen Albertini Dow, Georgia Creighton, Harvey Keitel, Kathy Najimy, Maggie Smith, Mary Wickes, Pat Crawford Brown, Prudence Wright Holmes, Susan Johnson-Kehn, Wendy Makkena, Whoopi Goldberg',
  'Emile Ardolino',
  30,
  'https://www.themoviedb.org/t/p/w1280/nn0XTBqZf8Q3iXPApE9OQevrYZY.jpg',
  'https://www.youtube.com/embed/lCBjHkCK1Vw?si=ZAAVGVW1VAs6U9Rg'
);

INSERT INTO films (id, title, genre, annee_sortie, langue_originale, pays_productions, acteurs, realisateurs, available_copies, imgpath, trailer)
VALUES (
  108052,
  'Schindler''s List',
  'Biography, Drama, History, War',
  1993,
  'English',
  'USA',
  'Andrzej Seweryn, Ben Kingsley, Caroline Goodall, Embeth Davidtz, Liam Neeson, Norbert Weisser, Ralph Fiennes',
  'Steven Spielberg',
  18,
  'https://www.themoviedb.org/t/p/w1280/sF1U4EUQS8YHUYjNl3pMGNIQyr0.jpg',
  'https://www.youtube.com/embed/gG22XNhtnoY?si=aAS5RRz0fZv--5s3'
);

INSERT INTO films (id, title, genre, annee_sortie, langue_originale, pays_productions, acteurs, realisateurs, available_copies, imgpath, trailer)
VALUES (
  1099212,
  'Twilight',
  'Drama, Fantasy, Romance',
  2008,
  'English',
  'USA',
  'Anna Kendrick, Ashley Greene, Billy Burke, Christian Serratos, Gil Birmingham, Justin Chon, Kellan Lutz, Kristen Stewart, Michael Welch, Nikki Reed, Robert Pattinson, Sarah Clarke, Taylor Lautner',
  'Catherine Hardwicke',
  32,
  'https://www.themoviedb.org/t/p/w1280/8phJ4i9m1tBDJbOwwQPvdeWhN2h.jpg',
  'https://www.youtube.com/embed/uxjNDE2fMjI?si=9bYvNwKcaxUhcuIp'
);

INSERT INTO films (id, title, genre, annee_sortie, langue_originale, pays_productions, acteurs, realisateurs, available_copies, imgpath, trailer)
VALUES (
  110413,
  'Léon',
  'Crime, Thriller',
  1994,
  'English',
  'France',
  'Danny Aiello, Gary Oldman, Jean Reno, Natalie Portman, Peter Appel',
  'Luc Besson',
  16,
  'https://www.themoviedb.org/t/p/w1280/oBhmd3261OkJ4Yg2FdSiD2wnyfe.jpg',
  'https://www.youtube.com/embed/rNw0D7Hh0DY?si=NVeg7NrABBhRNK5u'
);

INSERT INTO films (id, title, genre, annee_sortie, langue_originale, pays_productions, acteurs, realisateurs, available_copies, imgpath, trailer)
VALUES (
  111503,
  'True Lies',
  'Action, Comedy, Romance, Thriller',
  1994,
  'English',
  'USA',
  'Arnold Schwarzenegger, Art Malik, Bill Paxton',
  'James Cameron',
  11,
  'https://www.themoviedb.org/t/p/w1280/uCvYz3emqJIF9nIzoDJp7mKxHgG.jpg',
  'https://www.youtube.com/embed/3B7HG8_xbDw?si=QWU3QXWfIJ_2y9fm'
);

-- ============================================================
-- Données de test : locations
-- ============================================================
INSERT INTO rentals (user_id, film_id, rental_date, return_date) VALUES
(1, 100758, '2025-11-01 10:00:00', '2025-11-05 11:00:00'),
(2, 105417, '2025-11-02 14:30:00', NULL),
(3, 1099212, '2025-11-03 16:45:00', '2025-11-07 12:00:00'),
(4, 1013752, '2025-11-04 09:15:00', NULL),
(1, 105417, '2025-11-05 18:20:00', NULL);
