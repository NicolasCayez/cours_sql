-- Nettoyage si relance du script
DROP DATABASE IF EXISTS exercice_4_gestion;
-- Création de la base de données
CREATE DATABASE IF NOT EXISTS exercice_4_gestion CHARSET utf8mb4;
-- Utilisation de la base de donnée pour les scripts suivants
USE exercice_4_gestion ;

-- Création des tables
CREATE TABLE IF NOT EXISTS utilisateur(
	id_utilisateur INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	email VARCHAR(50) NOT NULL UNIQUE,
	mdp VARCHAR(100) NOT NULL,
	id_role INT NOT NULL
)ENGINE=Innodb;

CREATE TABLE IF NOT EXISTS `role`(
	id_role INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	nom_role VARCHAR(50) NOT NULL UNIQUE
)ENGINE=Innodb;

CREATE TABLE IF NOT EXISTS matiere_premiere(
	id_matiere_premiere INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	nom_matiere_premiere VARCHAR(50) NOT NULL,
	quantite_matiere INT NOT NULL,
	prix_achat DECIMAL(5,2)
)ENGINE=Innodb;

CREATE TABLE IF NOT EXISTS fournisseur(
	id_fournisseur INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	nom_fournisseur VARCHAR(50) NOT NULL UNIQUE,
	telephone_fournisseur INT NOT NULL,
	id_adresse INT NOT NULL
)ENGINE=Innodb;

CREATE TABLE IF NOT EXISTS adresse(
	id_adresse INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	nom_rue VARCHAR(50) NOT NULL,
	num_rue INT NOT NULL,
	code_postal INT NOT NULL UNIQUE,
	ville VARCHAR(50) NOT NULL,
	pays VARCHAR(50) NOT NULL UNIQUE
)ENGINE=Innodb;

CREATE TABLE IF NOT EXISTS client(
	id_client INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	nom_client VARCHAR(50) NOT NULL,
	prenom_client VARCHAR(50) NOT NULL,
	telephone_client INT NOT NULL,
	id_adresse INT NOT NULL
)ENGINE=Innodb;

CREATE TABLE IF NOT EXISTS commercial(
	id_commercial INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	nom_commercial VARCHAR(50) NOT NULL,
	prenom_commercial VARCHAR(50) NOT NULL
)ENGINE=Innodb;

CREATE TABLE IF NOT EXISTS produit(
	id_produit INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	nom_produit VARCHAR(50) NOT NULL,
	prix_vente DECIMAL(5,2),
	quantite_produit INT NOT NULL
)ENGINE=Innodb;

-- Création des tables association
CREATE TABLE IF NOT EXISTS fournir(
	id_matiere_premiere INT NOT NULL,
	id_fournisseur INT NOT NULL,
	PRIMARY KEY (id_matiere_premiere, id_fournisseur)
)ENGINE=Innodb;

CREATE TABLE IF NOT EXISTS concevoir(
	id_matiere_premiere INT NOT NULL,
	id_produit INT NOT NULL,
	PRIMARY KEY (id_matiere_premiere , id_produit)
)ENGINE=Innodb;

CREATE TABLE IF NOT EXISTS promouvoir(
	id_produit INT NOT NULL,
	id_commercial INT NOT NULL,
	PRIMARY KEY (id_produit , id_commercial)
)ENGINE=Innodb;

CREATE TABLE IF NOT EXISTS acheter(
	id_produit INT NOT NULL,
	id_client INT NOT NULL,
	quantite_achat INT NOT NULL,
	PRIMARY KEY (id_produit , id_client)
)ENGINE=Innodb;

CREATE TABLE IF NOT EXISTS fideliser(
	id_client INT NOT NULL,
	id_commercial INT NOT NULL,
	chiffre_affaire DECIMAL(10,2),
	PRIMARY KEY (id_client , id_commercial)
)ENGINE=Innodb;

-- Ajout des contraintes Foreign Key
ALTER TABLE utilisateur 
ADD CONSTRAINT fk_affecter_role
FOREIGN KEY (id_role) REFERENCES `role`(id_role)
ON DELETE CASCADE;

ALTER TABLE fournir 
ADD CONSTRAINT fk_fournir_matiere_premiere
FOREIGN KEY (id_matiere_premiere) REFERENCES matiere_premiere(id_matiere_premiere)
ON DELETE CASCADE, 
ADD CONSTRAINT fk_fournir_fournisseur
FOREIGN KEY (id_fournisseur) REFERENCES fournisseur(id_fournisseur)
ON DELETE CASCADE;

ALTER TABLE fournisseur
ADD CONSTRAINT fk_situer_adresse
FOREIGN KEY (id_adresse) REFERENCES adresse(id_adresse)
ON DELETE CASCADE;

ALTER TABLE client
ADD CONSTRAINT fk_localiser_adresse
FOREIGN KEY (id_adresse) REFERENCES adresse(id_adresse)
ON DELETE CASCADE;

ALTER TABLE fideliser 
ADD CONSTRAINT fk_fideliser_client
FOREIGN KEY (id_client) REFERENCES client(id_client)
ON DELETE CASCADE, 
ADD CONSTRAINT fk_fideliser_commercial
FOREIGN KEY (id_commercial) REFERENCES commercial(id_commercial)
ON DELETE CASCADE;

ALTER TABLE promouvoir 
ADD CONSTRAINT fk_promouvoir_produit
FOREIGN KEY (id_produit) REFERENCES produit(id_produit)
ON DELETE CASCADE, 
ADD CONSTRAINT fk_promouvoir_commercial
FOREIGN KEY (id_commercial) REFERENCES commercial(id_commercial)
ON DELETE CASCADE;

ALTER TABLE acheter 
ADD CONSTRAINT fk_acheter_produit
FOREIGN KEY (id_produit) REFERENCES produit(id_produit)
ON DELETE CASCADE, 
ADD CONSTRAINT fk_acheter_client
FOREIGN KEY (id_client) REFERENCES client(id_client)
ON DELETE CASCADE;

ALTER TABLE concevoir
ADD CONSTRAINT fk_concevoir_matiere_premiere
FOREIGN KEY (id_matiere_premiere) REFERENCES matiere_premiere(id_matiere_premiere)
ON DELETE CASCADE,
ADD CONSTRAINT fk_concevoir_produit
FOREIGN KEY (id_produit) REFERENCES produit(id_produit)
ON DELETE CASCADE;