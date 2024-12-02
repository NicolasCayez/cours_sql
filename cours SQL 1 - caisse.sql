-- Création de la base de données
CREATE DATABASE IF NOT EXISTS caisse CHARSET utf8mb4;

-- Utiliser la base de données
USE caisse;

-- Création des tables (possible ajouter CHARSET après ENGINE=... si caractères spéciaux style russe etc)
CREATE TABLE IF NOT EXISTS categorie(
id_categorie INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nom_categorie VARCHAR(50) NOT NULL
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS vendeur(
id_vendeur INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nom_vendeur VARCHAR(50) NOT NULL,
prenom_vendeur VARCHAR(50) NOT NULL
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS produit(
id_produit INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nom_produit VARCHAR(50) NOT NULL,
description_produit VARCHAR(255) NOT NULL,
prix_produit DECIMAL(6,2),
id_categorie INT NOT NULL
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS ticket(
id_ticket INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
DATE_ticket DATETIME NOT NULL,
id_vendeur INT NOT NULL
)ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS produit_ticket(
id_produit INT NOT NULL,
id_ticket INT NOT NULL,
quantite INT NOT NULL,
PRIMARY KEY(id_produit, id_ticket)
)ENGINE=InnoDB;

-- Ajout des contraintes
ALTER TABLE produit
ADD CONSTRAINT fk_ajouter_categorie
FOREIGN KEY(id_categorie)
REFERENCES categorie(id_categorie)
ON DELETE CASCADE;

ALTER TABLE ticket
ADD CONSTRAINT fk_vendre_vendeur
FOREIGN KEY(id_vendeur)
REFERENCES vendeur(id_vendeur)
ON DELETE CASCADE;

ALTER TABLE produit_ticket
ADD CONSTRAINT fk_produit_ticket_produit
FOREIGN KEY(id_produit)
REFERENCES produit(id_produit)
ON DELETE CASCADE;

ALTER TABLE produit_ticket
ADD CONSTRAINT fk_produit_ticket_ticket
FOREIGN KEY(id_ticket)
REFERENCES ticket(id_ticket)
ON DELETE CASCADE;