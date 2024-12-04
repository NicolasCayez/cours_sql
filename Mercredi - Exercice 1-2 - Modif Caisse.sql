-- ****************************************************** --
-- Initialisation avant exercice                          --
-- ****************************************************** --
USE caisse;

-- ****************************************************** --
-- Exercice 1 Requête de Consultation                     --
-- ****************************************************** --
-- Afficher la liste des tickets de 2024 (id_ticket et la date_creation),
SELECT t.id_ticket AS `identifiant ticket`, t.date_creation AS `date du ticket`, t.id_vendeur AS `identifiant vendeur`
FROM ticket AS t
WHERE t.date_creation >= '2024-01-01'
AND t.date_creation <= '2024-12-31';
-- avec YEAR
SELECT t.id_ticket AS `identifiant ticket`, t.date_creation AS `date du ticket`, t.id_vendeur AS `identifiant vendeur`
FROM ticket AS t
WHERE YEAR(t.date_creation) = '2024';
-- avec BETWEEN
SELECT t.id_ticket AS `identifiant ticket`, t.date_creation AS `date du ticket`, t.id_vendeur AS `identifiant vendeur`
FROM ticket AS t
WHERE t.date_creation BETWEEN '2024-01-01' AND '2024-12-31';

-- Afficher la liste des produits de type 'Alimentaire' (id_produit, nom_produit, tarif), FROMAGE dans mon exemple
SELECT p.id_produit AS `identifiant produit`, p.nom_produit AS `nom du produit`, p.tarif
FROM produit AS p
INNER JOIN categorie AS c ON p.id_categorie = c.id_categorie 
WHERE c.nom_categorie = 'fromage';

-- Afficher la liste des produits dont le tarif est supérieur à 2 € (id_produit, nom_produit, tarif, nom_categorie),
SELECT p.id_produit AS `identifiant produit`, p.nom_produit AS `nom du produit`, p.tarif, c.nom_categorie  AS `catégorie`
FROM produit AS p
INNER JOIN categorie AS c ON p.id_categorie = c.id_categorie 
WHERE p.tarif > 2;

-- Afficher la liste des produits de type 'Alimentaire' (nom_produit, tarif, nom_categorie). FROMAGE dans mon exemple
SELECT p.nom_produit AS `nom du produit`, p.tarif, c.nom_categorie  AS `catégorie`
FROM produit AS p
INNER JOIN categorie AS c ON p.id_categorie = c.id_categorie 
WHERE c.nom_categorie = 'fromage';

-- Bonus :
-- Afficher la liste des produits dont le nom est inférieur à J et dont le prix est supérieur à 1.50 € (id_produit, nom_produit, tarif),
SELECT p.id_produit AS `identifiant produit`, p.nom_produit AS `nom du produit`, p.tarif
FROM produit AS p
WHERE p.nom_produit < 'J'
AND p.tarif > 1.50;

-- Afficher les tickets de 2023 (id_ticket, date_creation, nom_vendeur, prenom_vendeur),
SELECT t.id_ticket AS `identifiant ticket`, t.date_creation AS `date du ticket`, v.nom_vendeur AS `nom du vendeur`, v.prenom_vendeur AS `prénom du vendeur`
FROM ticket AS t
INNER JOIN vendeur AS v ON t.id_vendeur = v.id_vendeur 
WHERE YEAR(t.date_creation) = '2023';
-- Afficher les 5 produits les plus cher (id_produit, nom_produit, tarif)
SELECT p.id_produit AS `identifiant produit`, p.nom_produit AS `nom du produit`, p.tarif
FROM produit AS p
ORDER BY p.tarif DESC LIMIT 5;

-- ****************************************************** --
-- Exercice 2 Requête de Consultation et Jointure :       --
-- ****************************************************** --
-- Afficher la liste des produits vendu sur le ticket : 1 (nom_produit, tarif, quantite),
SELECT p.nom_produit AS `Nom du produit`, p.tarif AS `Tarif`, pt.quantite AS 'Quantité'
FROM produit AS p
INNER JOIN produit_ticket AS pt ON p.id_produit = pt.id_produit 
WHERE pt.id_ticket = 1;

-- Afficher la liste des produits vendu en 2024 (nom_produit, tarif, nom_categorie),
SELECT DISTINCT p.nom_produit AS `Nom du produit`, p.tarif AS `Tarif`, c.nom_categorie AS `Catégorie`
FROM produit AS p
INNER JOIN categorie AS c ON p.id_categorie = c.id_categorie
INNER JOIN produit_ticket AS pt ON p.id_produit = pt.id_produit
INNER JOIN ticket AS t ON pt.id_ticket = t.id_ticket 
WHERE YEAR(t.date_creation) = '2024';

-- Afficher la liste des produits vendu par le vendeur : 4 (nom_produit, tarif, nom_vendeur, prenom_vendeur),
SELECT DISTINCT p.nom_produit AS `Nom du produit`, p.tarif AS `Tarif`, v.nom_vendeur AS `nom du vendeur`, v.prenom_vendeur AS `prénom du vendeur`
FROM produit AS p
INNER JOIN produit_ticket AS pt ON p.id_produit = pt.id_produit
INNER JOIN ticket AS t ON pt.id_ticket = t.id_ticket
INNER JOIN vendeur AS v ON t.id_vendeur = v.id_vendeur
WHERE v.id_vendeur = 4;
-- Afficher la liste des produits de type Alimentation vendu (nom_produit, tarif, nom_categorie). Ici FROMAGE
SELECT DISTINCT p.nom_produit AS `Nom du produit`, p.tarif AS `Tarif`, c.nom_categorie AS `Catégorie`
FROM produit AS p
INNER JOIN categorie AS c ON p.id_categorie = c.id_categorie
WHERE c.nom_categorie = 'fromage';



















