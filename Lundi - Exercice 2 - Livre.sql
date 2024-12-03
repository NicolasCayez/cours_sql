-- Nettoyage si relance du script
DROP DATABASE IF EXISTS exercice_2_livre;
-- Création de la base de données
CREATE DATABASE IF NOT EXISTS exercice_2_livre CHARSET utf8mb4;
-- Utilisation de la base de donnée pour les scripts suivants
USE exercice_2_livre ;

-- Création des tables
CREATE TABLE IF NOT EXISTS genre(
	id_genre INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	nom_genre VARCHAR(50) NOT NULL UNIQUE
)ENGINE=Innodb;

CREATE TABLE IF NOT EXISTS livre(
	id_livre INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	titre VARCHAR(50) NOT NULL,
	description VARCHAR(255) NOT NULL,
	nbr_page INT NOT NULL
)ENGINE=Innodb;

CREATE TABLE IF NOT EXISTS reservation(
	id_reservation INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	date_debut DATETIME NOT NULL,
	date_fin DATETIME NOT NULL,
	id_utilisateur INT NOT NULL,
	id_livre INT NOT NULL
)ENGINE=Innodb;

CREATE TABLE IF NOT EXISTS utilisateur(
	id_utilisateur INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	nom_utilisateur VARCHAR(50) NOT NULL,
	prenom_utilisateur VARCHAR(50) NOT NULL,
	email VARCHAR(50) NOT NULL UNIQUE,
	mdp VARCHAR(100) NOT NULL,
	id_role INT NOT NULL
)ENGINE=Innodb;

CREATE TABLE IF NOT EXISTS  `role`(
	id_role INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	nom_role VARCHAR(50) NOT NULL UNIQUE
)ENGINE=Innodb;

-- Création table d'association
CREATE TABLE IF NOT EXISTS livre_genre(
	id_livre INT NOT NULL,
	id_genre INT NOT NULL,
	PRIMARY KEY (id_livre, id_genre)
)ENGINE=Innodb;

-- Ajout des contraintes foreign key
ALTER TABLE livre_genre 
ADD CONSTRAINT fk_livre_genre_livre
FOREIGN KEY (id_livre) REFERENCES livre(id_livre), 
ADD CONSTRAINT fk_livre_genre_genre
FOREIGN KEY (id_genre) REFERENCES genre(id_genre);

ALTER TABLE reservation
ADD CONSTRAINT fk_reserver_utilisateur
FOREIGN KEY (id_utilisateur) REFERENCES utilisateur(id_utilisateur)
ON DELETE CASCADE,
ADD CONSTRAINT fk_inclure_livre
FOREIGN KEY (id_livre) REFERENCES livre(id_livre)
ON DELETE CASCADE;

ALTER TABLE utilisateur
ADD CONSTRAINT fk_posseder_role
FOREIGN KEY (id_role) REFERENCES `role`(id_role)
ON DELETE CASCADE;