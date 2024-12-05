-- ****************************************************** --
-- Initialisation avant exercice                          --
-- ****************************************************** --
USE caisse;

-- ****************************************************** --
-- Exercice Vue :                                         --
-- ****************************************************** --
-- 1 Créer une vue qui affiche les tickets avec : id du ticket, nom vendeur, prenom vendeur, le montant TTC du ticket,
DROP VIEW IF EXISTS vw_ticket_detail;
CREATE VIEW vw_ticket_detail AS
	SELECT t.id_ticket AS `Identifiant`, v.nom_vendeur AS `Nom du vendeur`, v.prenom_vendeur AS `Prénom du vendeur`, CONCAT(ROUND(SUM(p.tarif * pt.quantite), 2), ' €') AS `Total ticket TTC` 
	FROM ticket AS t
	INNER JOIN vendeur AS v ON v.id_vendeur = t.id_vendeur
	INNER JOIN produit_ticket AS pt ON pt.id_ticket = t.id_ticket
	INNER JOIN produit AS p ON p.id_produit = pt.id_produit
	GROUP BY t.id_ticket
;
SELECT * FROM vw_ticket_detail;


-- 2 Créer une vue qui va retourner les 5 produits les plus vendus,
DROP VIEW IF EXISTS vw_top_5_produits;
CREATE VIEW vw_top_5_produits AS
	SELECT DISTINCT p.id_produit AS `Identifiant`, p.nom_produit AS `Produit`, SUM(pt.quantite) AS `Nb vendus`
	FROM produit AS p 
	INNER JOIN produit_ticket AS pt ON pt.id_produit = p.id_produit
	INNER JOIN ticket AS t ON t.id_ticket = pt.id_ticket
	GROUP BY p.id_produit
	ORDER BY SUM(pt.quantite) DESC LIMIT 5
;
SELECT * FROM vw_top_5_produits;


-- 3 Créer une vue qui va afficher le chiffre d'affaire des vendeurs avec : chiffre affaire, nom et le prénom du vendeur.
DROP VIEW IF EXISTS vw_ca_vendeur;
CREATE VIEW vw_ca_vendeur AS
	SELECT DISTINCT CONCAT(ROUND(SUM(p.tarif * pt.quantite), 2), ' €') AS `CA vendeur TTC`, v.nom_vendeur AS `Nom du vendeur`, v.prenom_vendeur AS `Prénom du vendeur`
	FROM vendeur AS v 
	INNER JOIN ticket AS t ON t.id_vendeur = v.id_vendeur
	INNER JOIN produit_ticket AS pt ON pt.id_ticket = t.id_ticket 
	INNER JOIN produit AS p ON p.id_produit = pt.id_produit 
	GROUP BY v.id_vendeur
;
SELECT * FROM vw_ca_vendeur;

-- ****************************************************** --
-- Exercice Droits SQL :                                  --
-- ****************************************************** --
-- Depuis la base de données ticket de caisse vous aller créer les comptes qui possèdent les droits suivants :
-- Administrateur qui peut : ajouter, modifier, supprimer, afficher, créer des vues, créer la structure de la base de données,
DROP USER IF EXISTS Administrateur;
CREATE USER 'Administrateur'@'%' IDENTIFIED BY 'AdminPasswd';
GRANT INSERT, UPDATE, DELETE, SELECT, CREATE VIEW, CREATE ON caisse.* TO 'Administrateur'@'%';
-- Gérant qui peut : ajouter, modifier, supprimer, afficher (toutes les tables), voir les vues,
DROP USER IF EXISTS Gerant;
CREATE USER 'Gerant'@'%' IDENTIFIED BY 'GerantPasswd';
GRANT INSERT, UPDATE, DELETE, SELECT, SHOW VIEW ON caisse.* TO 'Gerant'@'%';
-- Vendeur qui peut : afficher (toutes les tables), ajouter dans (ticket, produit_ticket), modifier (produit_ticket), voir les vues.
DROP USER IF EXISTS Vendeur;
CREATE USER 'Vendeur'@'%' IDENTIFIED BY 'VendeurPasswd';
GRANT SELECT, SHOW VIEW ON caisse.* TO 'Vendeur'@'%';
GRANT INSERT ON caisse.ticket TO 'Vendeur'@'%';
GRANT INSERT, UPDATE ON caisse.produit_ticket TO 'Vendeur'@'%';


-- Tester les comptes pour vérifier que  vos utilisateurs puissent uniquement utiliser les droits que vous avez déclarez.
SHOW GRANTS FOR 'root'@'localhost';
SHOW GRANTS FOR 'Administrateur'@'%';
SHOW GRANTS FOR 'Gerant'@'%';
SHOW GRANTS FOR 'Vendeur'@'%';


-- ****************************************************** --
-- Exercice Procédure stockée :                           --
-- ****************************************************** --
-- nettoyage
DROP PROCEDURE IF EXISTS addCategorie;
DROP PROCEDURE IF EXISTS addProduit;
DROP PROCEDURE IF EXISTS addTicket;
DROP PROCEDURE IF EXISTS addVendeur;
DROP PROCEDURE IF EXISTS checkExistingEmail;
DROP PROCEDURE IF EXISTS addUser;
DROP PROCEDURE IF EXISTS checkUser;
DROP PROCEDURE IF EXISTS changePasswd;
-- Créer pour la base ticket de caisse les procédures suivantes :


-- Créer une categorie en vérifiant qu'elle n'existe pas déjà,
DELIMITER $$
CREATE PROCEDURE addCategorie(
		IN nom VARCHAR(50)
	)
	BEGIN
		START TRANSACTION;
		-- test si la catégorie existe déjà
		IF (SELECT c.id_categorie FROM categorie AS c WHERE c.nom_categorie = nom) > 0 THEN
			ROLLBACK;
			-- Afficher un message d'erreur
			SIGNAL SQLSTATE '10000' SET MESSAGE_TEXT = 'La catégorie existe déjà';
		-- Si OK
		ELSE
			-- Ajout en BDD
			INSERT INTO categorie (nom_categorie)
			VALUES (nom);
			COMMIT;
		END IF;
	END $$;
-- TEST
DELETE FROM categorie WHERE nom_categorie = 'test';
CALL addCategorie('test'); -- OK
CALL addCategorie('test'); -- Erreur


-- Créer un produit en vérifiant : si il n'existe pas, si le prix est supérieur à 0,
DELIMITER $$
CREATE PROCEDURE addProduit(
		IN nom VARCHAR(50),
		IN `desc` VARCHAR(255),
		IN prix DECIMAL(6,2),
		IN categorie VARCHAR(50)
	)
	BEGIN
		START TRANSACTION;
		-- test si le produit existe déjà
		IF (SELECT p.id_produit	FROM produit AS p WHERE p.nom_produit = nom) > 0 THEN
			ROLLBACK;
			-- Afficher un message d'erreur
			SIGNAL SQLSTATE '10000' SET MESSAGE_TEXT = 'Le produit existe déjà';
		-- Test prix saisi > 0
		ELSEIF prix <= 0 THEN
			ROLLBACK;
			-- Afficher un message d'erreur
			SIGNAL SQLSTATE '10000' SET MESSAGE_TEXT = 'Le prix n\'est pas supérieur à 0';
		-- Test catégorie inexistante
		ELSEIF (SELECT c.id_categorie FROM categorie AS c WHERE nom_categorie = categorie) < 0 THEN
			ROLLBACK;
			-- Afficher un message d'erreur
			SIGNAL SQLSTATE '10000' SET MESSAGE_TEXT = 'Attention la catégorie n\'existe pas';
		-- Si OK
		ELSE
			-- Ajout en BDD
			INSERT INTO produit (nom_produit, description, tarif, id_categorie)
			VALUES (nom, `desc`, prix, (SELECT c.id_categorie FROM categorie AS c WHERE c.nom_categorie = categorie));
			COMMIT;
		END IF;
	END $$;
-- TEST
DELETE FROM produit WHERE nom_produit = 'testNomP';
CALL addProduit('testNomP', 'testDescP', 20.5, 'test'); -- OK
CALL addProduit('testNomP', 'testDescP', 20.5, 'test'); -- Erreur
DELETE FROM produit WHERE nom_produit = 'testNomP2';
CALL addProduit('testNomP2', 'testDescP2', 0, 'test'); -- Erreur


-- Créer un ticket dont la date est égale ou inférieure à la date du jour,
DELIMITER $$
CREATE PROCEDURE addTicket(
		IN `date` DATE,
		IN vendeur INT
	)
	BEGIN
		START TRANSACTION;
		-- test si la date est supérieure au jour actuel
		IF `date` > CURDATE() THEN
			ROLLBACK;
			-- Afficher un message d'erreur
			SIGNAL SQLSTATE '10000' SET MESSAGE_TEXT = 'La date saisie est une date future';
		-- Si OK
		ELSE
			-- Ajout en BDD
			INSERT INTO ticket (date_creation , id_vendeur)
			VALUES (`date`, vendeur);
			COMMIT;
		END IF;
	END $$;
-- TEST
CALL addTicket(CURDATE(), 2); -- OK
CALL addTicket('2024-12-22', 2); -- erreur


-- Créer un vendeur dont le nom et le prénom n'existe pas déja.
DELIMITER $$
CREATE PROCEDURE addVendeur(
		IN nom VARCHAR(50),
		IN prenom VARCHAR(50)
	)
	BEGIN
		START TRANSACTION;
		-- test si le vendeur existe déjà (nom ET prénom)
		IF (SELECT v.id_vendeur FROM vendeur AS v WHERE v.nom_vendeur = nom) > 0
			&& (SELECT v.id_vendeur FROM vendeur AS v WHERE v.prenom_vendeur = prenom) > 0 THEN
			ROLLBACK;
			-- Afficher un message d'erreur
			SIGNAL SQLSTATE '10000' SET MESSAGE_TEXT = 'Le vendeur avec les mêmes nom et prenom existe déjà';
		-- Si OK
		ELSE
			-- Ajout en BDD
			INSERT INTO vendeur (nom_vendeur , prenom_vendeur)
			VALUES (nom, prenom);
			COMMIT;
		END IF;
	END $$;
-- TEST
DELETE FROM vendeur WHERE nom_vendeur = 'Toto' AND prenom_vendeur = 'Tata';
CALL addVendeur('Toto', 'Tata'); -- OK
CALL addVendeur('Toto', 'Tata'); -- erreur


-- Créer une table utilisateur avec id, email, mot de passe :
DROP TABLE IF EXISTS utilisateur;
CREATE TABLE IF NOT EXISTS utilisateur(
	id_utilisateur INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	email_utilisateur VARCHAR(100) UNIQUE NOT NULL,
	mot_de_passe VARCHAR(255) NOT NULL
)Engine=InnoDB;

-- Créer une procédure qui va vérifier si le compte n'existe pas déja (email),

DELIMITER $$
CREATE PROCEDURE checkExistingEmail(
		IN email VARCHAR(100)
	)
	BEGIN
		START TRANSACTION;
		-- test si l'email existe déjà
		IF (SELECT COUNT(u.email_utilisateur) FROM utilisateur AS u WHERE u.email_utilisateur = email) > 0 THEN
			ROLLBACK;
			-- Afficher un message d'erreur
			SIGNAL SQLSTATE '10000' SET MESSAGE_TEXT = 'Compte déjà existant';
		END IF;
	END $$;
-- TEST
INSERT INTO utilisateur(email_utilisateur, mot_de_passe) VALUES ('testUser', 'testpasswd');
CALL checkExistingEmail('testUser'); -- OK
DELETE FROM utilisateur WHERE email_utilisateur = 'testUser';


-- Créer une procédure qui va créer le compte et hasher son mot de passe en MD5,

DELIMITER $$
CREATE PROCEDURE addUser(
		IN email VARCHAR(100),
		IN passwd VARCHAR(255)
	)
	BEGIN
		START TRANSACTION;
		-- test si le compte existe déjà
		IF (SELECT COUNT(u.email_utilisateur) FROM utilisateur AS u WHERE u.email_utilisateur = email) > 0 THEN
			ROLLBACK;
			-- Afficher un message d'erreur
			SIGNAL SQLSTATE '10000' SET MESSAGE_TEXT = 'Compte déjà existant';
		-- Si OK
		ELSE
			-- Ajout en BDD
			INSERT INTO utilisateur (email_utilisateur, mot_de_passe)
			VALUES (email, HEX(MD5(passwd)));
			COMMIT;
		END IF;
	END $$;
-- TEST
DELETE FROM utilisateur WHERE email_utilisateur = 'testUserEmail';
CALL addUser ('testUserEmail', 'azerty'); -- OK


-- Créer une procédure qui va vérifier si le compte est valide et le mot de passe est correct (vérifier le hash MD5),
DELIMITER $$
CREATE PROCEDURE checkUser(
		IN email VARCHAR(100),
		IN passwd VARCHAR(100)
	)
	BEGIN
		START TRANSACTION;
		-- test si le compte est non valide
		IF (SELECT COUNT(u.email_utilisateur) FROM utilisateur AS u WHERE u.email_utilisateur = email) = 0 THEN
			ROLLBACK;
			-- Afficher un message d'erreur
			SIGNAL SQLSTATE '10000' SET MESSAGE_TEXT = 'Email erronné';
		-- test hash MD5
		ELSEIF (SELECT COUNT(u.id_utilisateur) FROM utilisateur AS u WHERE u.email_utilisateur = email AND u.mot_de_passe = HEX(MD5(passwd))) <= 0 THEN
			ROLLBACK;
			-- Afficher un message d'erreur
			SIGNAL SQLSTATE '10000' SET MESSAGE_TEXT = 'Mot de passe erroné';
		END IF;
	END $$;
-- TEST
CALL checkUser ('testUserEmail', 'azerty'); -- OK
CALL checkUser ('testUserEmail', 'azertaaaa'); -- Erreur MDP
CALL checkUser ('testUserEmail1', 'azerty'); -- Erreur email


-- Créer une procédure qui va permettre de mettre à jour le mot de passe en vérifiant l'ancien mot de passe (Hash md5) et le remplacer par le nouveau (hasher également en MD5).
DELIMITER $$
CREATE PROCEDURE changePasswd(
		IN email VARCHAR(100),
		IN oldPasswd VARCHAR(255),
		IN newPasswd VARCHAR(255)
	)
	BEGIN
		START TRANSACTION;
		-- test si le compte est non valide
		IF (SELECT COUNT(u.email_utilisateur) FROM utilisateur AS u WHERE u.email_utilisateur = email) = 0 THEN
			ROLLBACK;
			-- Afficher un message d'erreur
			SIGNAL SQLSTATE '10000' SET MESSAGE_TEXT = 'Email erronné';
		-- test hash MD5
		ELSEIF (SELECT COUNT(u.id_utilisateur) FROM utilisateur AS u WHERE u.email_utilisateur = email AND u.mot_de_passe = HEX(MD5(oldPasswd))) <= 0 THEN
			ROLLBACK;
			-- Afficher un message d'erreur
			SIGNAL SQLSTATE '10000' SET MESSAGE_TEXT = 'Ancien mot de passe erroné';
		ELSE
			-- Mise a jour
			UPDATE utilisateur
			SET mot_de_passe = HEX(MD5(newPasswd))
			WHERE email_utilisateur = email;
			COMMIT;
		END IF;
	END $$;
-- TEST
DELETE FROM utilisateur WHERE email_utilisateur = 'testUserEmail';
CALL addUser ('testUserEmail', 'azerty'); -- OK
CALL changePasswd ('testUserEmail', 'azerty', 'qsdfgh');
CALL checkUser ('testUserEmail', 'azerty'); -- Erreur MDP
CALL checkUser ('testUserEmail', 'qsdfgh'); -- OK