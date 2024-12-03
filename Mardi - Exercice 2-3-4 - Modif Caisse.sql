-- ****************************************************** --
-- Initialisation avant exercice                          --
-- ****************************************************** --
-- Suppression ancienne version
DROP DATABASE IF EXISTS caisse;
-- Création de la base de données
CREATE DATABASE IF NOT EXISTS caisse CHARSET utf8mb4;
USE caisse;

-- Création des tables
CREATE TABLE IF NOT EXISTS categorie(
id_categorie INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nom_categorie VARCHAR(50) UNIQUE NOT NULL
)Engine=InnoDB;

CREATE TABLE IF NOT EXISTS vendeur(
id_vendeur INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nom_vendeur VARCHAR(50) NOT NULL,
prenom_vendeur VARCHAR(50) NOT NULL
)Engine=InnoDB;

CREATE TABLE IF NOT EXISTS ticket(
id_ticket INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
date_creation DATETIME NOT NULL,
id_vendeur INT NOT NULL
)Engine=InnoDB;

CREATE TABLE IF NOT EXISTS produit(
id_produit INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
nom_produit VARCHAR(50) NOT NULL,
`description` VARCHAR(255) NOT NULL,
tarif DECIMAL(3,2) NOT NULL,
id_categorie INT NOT NULL
)Engine=InnoDB;

-- Création de la table association
CREATE TABLE IF NOT EXISTS produit_ticket(
id_ticket INT,
id_produit INT,
quantite INT NOT NULL,
PRIMARY KEY(id_ticket, id_produit)
)Engine=InnoDB;

-- Ajouter les contraintes foreign key
ALTER TABLE produit
ADD CONSTRAINT fk_lier_categorie
FOREIGN KEY(id_categorie)
REFERENCES categorie(id_categorie)
ON DELETE CASCADE;

ALTER TABLE ticket
ADD CONSTRAINT fk_vendre_vendeur
FOREIGN KEY(id_vendeur)
REFERENCES vendeur(id_vendeur)
ON DELETE CASCADE;

ALTER TABLE produit_ticket
ADD CONSTRAINT fk_ajouter_produit
FOREIGN KEY(id_produit)
REFERENCES produit(id_produit);

ALTER TABLE produit_ticket
ADD CONSTRAINT fk_ajouter_ticket
FOREIGN KEY(id_ticket)
REFERENCES ticket(id_ticket);

-- ****************************************************** --
-- Exercice 2 INSERT :                                    --
-- ****************************************************** --
-- Dans la base caisse (voir correction code requêtes de ci-dessous).
-- Vous allez ajouter des enregistrements dans les tables suivantes :
-- 5 catégories (nom_categorie),
-- 10 produits (nom, description, tarif et un id_categorie)
-- 5 vendeurs (nom_vendeurs, prenom_vendeur),
-- 10 tickets de caisse (date_ticket, id_vendeur),
-- Ajouter 3 produits (quantite, id_produit) à chaque ticket de caisse. Dans la table produit_ticket

-- ****************************************************** --
-- Exercice 3 Requêtes MAJ Update :                       --
-- ****************************************************** --
-- Mettre à jour le nom du vendeur 2 par 'Albert',
-- Augmenter le tarif de  1 € pour tous les produits dont le tarif est inférieur à 2 €,
-- modifier le vendeur 2 des tickets de caisse, remplacer le par le vendeur 5,
-- mettre à jour le nom des categories qui ont un nom plus petit que C par nouveau.
-- Bonus :
-- Augmenter la quantité de tous les  produits, pour les tickets du vendeur Sophie Durand  de 3.
-- on ajoute + 3 à la valeur existante.
-- Diminuer le montant de tous les produits de type meuble de 10 %,
-- Ajouter 2 jours à tous les tickets dont la date est supérieure au :
-- 1 janvier 2024.
-- ****************************************************** --
-- Exercice 4 requêtes de MAJ DELETE :                    --
-- ****************************************************** --
-- Supprimer la categorie 'Électronique',
-- Supprimer la categorie 'Jouets',
-- Supprimer le vendeur 1,
-- Supprimer tous les tickets qui ont une date inferieure au 1 janvier 2024,
-- Supprimer tous les produits de la table produit_ticket qui ont une quantite supérieure à 9