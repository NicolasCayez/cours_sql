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
INSERT INTO categorie(nom_categorie) VALUES ('légumes'),('fruits'),('fromage'),('viande'),('meuble');
-- 10 produits (nom, description, tarif et un id_categorie)
INSERT INTO produit(nom_produit, `description`, tarif, id_categorie) VALUES ('tomate','en fait c\'est un fruit de couleur rouge',3.52,1);
INSERT INTO produit(nom_produit, `description`, tarif, id_categorie) VALUES ('courgette','légume vert',2.12,1);
INSERT INTO produit(nom_produit, `description`, tarif, id_categorie) VALUES ('carotte','les lapins en rafollent',2.32,1);
INSERT INTO produit(nom_produit, `description`, tarif, id_categorie) VALUES ('orange','plein de vitamines',4.02,2);
INSERT INTO produit(nom_produit, `description`, tarif, id_categorie) VALUES ('pomme','miam',2.20,2);
INSERT INTO produit(nom_produit, `description`, tarif, id_categorie) VALUES ('reblochon','In Tartiflette we trust',8.63,3);
INSERT INTO produit(nom_produit, `description`, tarif, id_categorie) VALUES ('camembert','sent fort',6.36,3);
INSERT INTO produit(nom_produit, `description`, tarif, id_categorie) VALUES ('kiri','pour les enfants qui n\'ont pas de goût',4.50,3);
INSERT INTO produit(nom_produit, `description`, tarif, id_categorie) VALUES ('Steack de cheval','Il y en a des fois dans les lasagnes',18.58,4);
INSERT INTO produit(nom_produit, `description`, tarif, id_categorie) VALUES ('armoire','en bois',359.99,5);
-- 5 vendeurs (nom_vendeurs, prenom_vendeur),
INSERT INTO vendeur(nom_vendeur, prenom_vendeur) VALUES ('Duck', 'Donald'),('Duck', 'Daisy'),('Duck', 'Riri'),('Duck', 'Fifi'),('Durand', 'Sophie');
-- 10 tickets de caisse (date_ticket, id_vendeur),
INSERT INTO ticket(date_creation , id_vendeur) VALUES ('2023-10-01', 1),('2023-10-01', 2),('2024-10-03', 1),('2024-10-03', 3),('2024-10-03', 5),('2024-10-04', 2),('2024-10-06', 5),('2024-10-07', 4),('2024-10-07', 4),('2024-10-08', 2);
-- Ajouter 3 produits (quantite, id_produit) à chaque ticket de caisse. Dans la table produit_ticket
INSERT INTO produit_ticket(id_ticket, quantite, id_produit) VALUES (1,2,3),(1,3,1),(1,5,2);
INSERT INTO produit_ticket(id_ticket, quantite, id_produit) VALUES (2,3,2),(2,4,1),(2,2,3);
INSERT INTO produit_ticket(id_ticket, quantite, id_produit) VALUES (3,12,4),(3,5,1),(3,1,2);
INSERT INTO produit_ticket(id_ticket, quantite, id_produit) VALUES (4,8,3),(4,1,1),(4,1,4);
INSERT INTO produit_ticket(id_ticket, quantite, id_produit) VALUES (5,9,5),(5,15,1),(5,2,4);
INSERT INTO produit_ticket(id_ticket, quantite, id_produit) VALUES (6,6,7),(6,4,1),(6,3,5);
INSERT INTO produit_ticket(id_ticket, quantite, id_produit) VALUES (7,2,5),(7,2,1),(7,1,2);
INSERT INTO produit_ticket(id_ticket, quantite, id_produit) VALUES (8,1,4),(8,2,1),(8,1,5);
INSERT INTO produit_ticket(id_ticket, quantite, id_produit) VALUES (9,7,4),(9,1,1),(9,4,3);
INSERT INTO produit_ticket(id_ticket, quantite, id_produit) VALUES (10,2,2),(10,1,1),(10,3,6);

-- ****************************************************** --
-- Exercice 3 Requêtes MAJ Update :                       --
-- ****************************************************** --
-- Mettre à jour le nom du vendeur 2 par 'Albert',
UPDATE vendeur SET nom_vendeur = 'Albert'
WHERE id_vendeur = 2;
-- Augmenter le tarif de  1 € pour tous les produits dont le tarif est inférieur à 2 €,
UPDATE produit SET tarif = tarif + 1
WHERE tarif < 2;
-- modifier le vendeur 2 des tickets de caisse, remplacer le par le vendeur 5,
UPDATE ticket SET id_vendeur = 5
WHERE id_vendeur = 2;
-- mettre à jour le nom des categories qui ont un nom plus petit que C par nouveau.
UPDATE categorie SET nom_categorie = 'nouveau'
WHERE nom_categorie < 'C';
-- Bonus :
-- Augmenter la quantité de tous les  produits, pour les tickets du vendeur Sophie Durand  de 3.
-- on ajoute + 3 à la valeur existante.
UPDATE produit_ticket SET quantite  = quantite + 3
WHERE id_ticket IN (
	SELECT DISTINCT id_ticket FROM ticket 
	INNER JOIN vendeur ON ticket.id_vendeur = vendeur.id_vendeur
	WHERE vendeur.nom_vendeur = 'Durand'
	AND vendeur.prenom_vendeur = 'Sophie'
);
-- Diminuer le montant de tous les produits de type meuble de 10 %,
UPDATE produit SET tarif = tarif * 0.9
WHERE id_categorie IN(
	SELECT id_categorie FROM categorie
	WHERE nom_categorie = 'meuble'
);
-- Ajouter 2 jours à tous les tickets dont la date est supérieure au :
-- 1 janvier 2024.
UPDATE ticket SET date_creation = date_creation + INTERVAL 2 DAY
WHERE date_creation > '2024-01-01';

-- ****************************************************** --
-- Exercice 4 requêtes de MAJ DELETE :                    --
-- ****************************************************** --
-- Supprimer la categorie 'Électronique', (avec mes exemples : 'fruits')
-- Supprimer la categorie 'Jouets', (avec mes exemples : 'fromage')
ALTER TABLE produit_ticket
DROP CONSTRAINT fk_ajouter_produit;

DELETE FROM categorie
WHERE nom_categorie = 'fruits';
DELETE FROM categorie
WHERE nom_categorie = 'fromage';

-- Supprimer le vendeur 1,
-- Supprimer tous les tickets qui ont une date inferieure au 1 janvier 2024,
ALTER TABLE produit_ticket
DROP CONSTRAINT fk_ajouter_ticket;

DELETE FROM vendeur
WHERE id_vendeur = 1;
DELETE FROM ticket
WHERE date_creation < '2024-01-01';


-- Supprimer tous les produits de la table produit_ticket qui ont une quantite supérieure à 9
DELETE FROM produit_ticket
WHERE quantite > 9;
-- OK