-- Utilisation de la base de données
USE exercice_2_livre ;

-- ****************************************************** --
-- Exercice 1 Requête de MAJ INSERT:                      --
-- ****************************************************** --

-- Ajouter un attribut date_sortie de type date à la table livre,
ALTER TABLE livre
ADD IF NOT EXISTS date_sortie DATE;
-- Ajouter dans la table livre les enregistrements suivants :
-- Titre : Le Mystère de la Forêt Résumé : Un groupe d'amis découvre un secret ancien caché dans une forêt enchantée. Date : 2023-01-01
INSERT INTO livre(titre, description, date_sortie) VALUES ('Le Mystère de la Forêt', 'Un groupe d\'amis découvre un secret ancien caché dans une forêt enchantée.', '2023-01-01');
-- Titre : Les Secrets de l'Océan Résumé : Une jeune biologiste marine explore les profondeurs de l'océan et découvre une civilisation perdue. Date : 2023-02-01
INSERT INTO livre(titre, description, date_sortie) VALUES ('Les Secrets de l\'Océan', 'Une jeune biologiste marine explore les profondeurs de l\'océan et découvre une civilisation perdue.', '2023-02-01');
-- Titre : L'Énigme du Pharaon Résumé : Un archéologue tente de résoudre les mystères d'une ancienne pyramide égyptienne. Date : 2023-03-01
INSERT INTO livre(titre, description, date_sortie) VALUES ('L\'Énigme du Pharaon', 'Un archéologue tente de résoudre les mystères d\'une ancienne pyramide égyptienne.', '2023-03-01');
-- Titre : La Quête du Chevalier Résumé : Un chevalier part en quête pour sauver son royaume d'une menace imminente. Date : 2023-04-01
INSERT INTO livre(titre, description, date_sortie) VALUES ('La Quête du Chevalier', 'Un chevalier part en quête pour sauver son royaume d\'une menace imminente.', '2023-04-01');
-- Titre : Le Voyage Interstellaire Résumé : Un équipage spatial part à la découverte de nouvelles planètes et formes de vie. Date : 2023-05-01
INSERT INTO livre(titre, description, date_sortie) VALUES ('Le Voyage Interstellaire', 'Un équipage spatial part à la découverte de nouvelles planètes et formes de vie.', '2023-05-01');
-- Titre : Les Chroniques du Temps Résumé : Un scientifique invente une machine à voyager dans le temps et explore différentes époques. Date : 2023-06-01
INSERT INTO livre(titre, description, date_sortie) VALUES ('Les Chroniques du Temps', 'Un scientifique invente une machine à voyager dans le temps et explore différentes époques.', '2023-06-01');
-- Titre : La Cité Perdue Résumé : Une équipe d'explorateurs découvre une cité ancienne cachée dans la jungle. Date : 2023-07-01
INSERT INTO livre(titre, description, date_sortie) VALUES ('La Cité Perdue', 'Une équipe d\'explorateurs découvre une cité ancienne cachée dans la jungle.', '2023-07-01');
-- Titre : Le Trésor des Pirates Résumé : Un jeune garçon trouve une carte au trésor et part à l'aventure pour le trouver. Date : 2023-08-01
INSERT INTO livre(titre, description, date_sortie) VALUES ('Le Trésor des Pirates', 'Un jeune garçon trouve une carte au trésor et part à l\'aventure pour le trouver.', '2023-08-01');
-- Titre : L'Île Mystérieuse Résumé : Un groupe de naufragés découvre une île pleine de mystères et de dangers. Date : 2023-09-01
INSERT INTO livre(titre, description, date_sortie) VALUES ('L\'Île Mystérieuse', 'Un groupe de naufragés découvre une île pleine de mystères et de dangers.', '2023-09-01');
-- Titre : Les Gardiens de la Galaxie Résumé : Une équipe de super-héros protège la galaxie contre des menaces interstellaires. Date : 2023-10-01
INSERT INTO livre(titre, description, date_sortie) VALUES ('Les Gardiens de la Galaxie', 'Une équipe de super-héros protège la galaxie contre des menaces interstellaires.', '2023-10-01');

-- Ajouter dans la table genre les enregistrements suivants :
-- fanstastique, science-fiction, polar, drame, roman
INSERT INTO genre(nom_genre) VALUES ('fanstastique'),('science-fiction'),('polar'),('drame'),('roman');
-- Associer chaque enregistrement de livre à 2 genres différents (table livre_genre).
 
-- BONUS :

-- Modifier la colonne titre (table livre), la passer en unique,
ALTER TABLE livre
CHANGE titre titre VARCHAR(50) NOT NULL UNIQUE;

-- Tester d'ajouter des livres qui possède le même titre.
-- INSERT INTO livre(titre, description, date_sortie) VALUES ('Le Mystère de la Forêt', 'Un groupe d\'amis découvre un secret ancien caché dans une forêt enchantée.', '2023-01-01');
-- -> ERREUR Duplicate entry

-- Modifier la colonne libele (table genre), la passer en unique,
-- colonne "nom_genre" qui est déjà en UNIQUE (cf correction)

-- Ajouter une table auteur qui va contenir : id, nom, prénom,
CREATE TABLE auteur(
	id_auteur INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	nom VARCHAR(50) NOT NULL,
	prenom VARCHAR(50) NOT NULL
)ENGINE=Innodb;
-- Ajouter une colonne id_auteur (table livre) et sa contrainte foreign key,
ALTER TABLE livre
ADD id_auteur INT,
ADD CONSTRAINT fk_auteur_livre
FOREIGN KEY (id_auteur) REFERENCES auteur(id_auteur)
ON DELETE CASCADE;

-- Créer 5 enregistrements dans la table auteur,
INSERT INTO auteur(nom, prenom) VALUES ('Tolkien','JRR'),('King','Stephen'),('Oda','Eiichiro'),('Alice','Alex'),('Uderzo','Albert');

-- Créer 5 enregistrements dans la table livre qui inclus une référence à l'auteur (valeur de la clé primaire id_auteur).
INSERT INTO livre(titre, description, date_sortie, id_auteur) VALUES ('Le Mystère de la Forêt POCHE', 'Un groupe d\'amis découvre un secret ancien caché dans une forêt enchantée.', '2023-01-01', 1);
INSERT INTO livre(titre, description, date_sortie, id_auteur) VALUES ('Les Secrets de l\'Océan POCHE', 'Une jeune biologiste marine explore les profondeurs de l\'océan et découvre une civilisation perdue.', '2023-02-01', 2);
INSERT INTO livre(titre, description, date_sortie, id_auteur) VALUES ('L\'Énigme du Pharaon POCHE', 'Un archéologue tente de résoudre les mystères d\'une ancienne pyramide égyptienne.', '2023-03-01', 3);
INSERT INTO livre(titre, description, date_sortie, id_auteur) VALUES ('La Quête du Chevalier POCHE', 'Un chevalier part en quête pour sauver son royaume d\'une menace imminente.', '2023-04-01', 4);
INSERT INTO livre(titre, description, date_sortie, id_auteur) VALUES ('Le Voyage Interstellaire POCHE', 'Un équipage spatial part à la découverte de nouvelles planètes et formes de vie.', '2023-05-01', 5);






















