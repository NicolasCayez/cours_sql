-- ****************************************************** --
-- Initialisation avant exercice                          --
-- ****************************************************** --
USE caisse;

-- ****************************************************** --
-- Exercice 3 Jointures :                                 --
-- ****************************************************** --
-- Réaliser les requêtes suivantes :
-- Afficher la liste des produits qui n'ont jamais été dans un ticket de caisse.
SELECT DISTINCT p.id_produit AS `Identifiant`, p.nom_produit AS `Produit`
FROM produit AS p
LEFT JOIN produit_ticket AS pt ON p.id_produit = pt.id_produit
WHERE p.id_produit NOT IN (
	SELECT DISTINCT id_produit FROM produit_ticket 
);
-- Afficher la liste des vendeurs qui n'ont jamais vendu un produit
SELECT DISTINCT v.id_vendeur AS `Identifiant`, v.nom_vendeur AS `Nom`, v.prenom_vendeur AS `Prénom`
FROM vendeur AS v
LEFT JOIN ticket AS t ON v.id_vendeur = t.id_vendeur
WHERE v.id_vendeur NOT IN (
	SELECT DISTINCT id_vendeur FROM ticket 
);
-- Afficher les 3 produits qui sont le plus vendus.
SELECT p.id_produit AS `identifiant produit`, p.nom_produit AS `nom du produit`, SUM(pt.quantite) AS `somme`
FROM produit AS p
INNER JOIN produit_ticket AS pt ON p.id_produit = pt.id_produit
GROUP BY p.id_produit 
ORDER BY `somme` DESC LIMIT 3;

-- ****************************************************** --
-- Exercice Bonus  agrégation  :                          --
-- ****************************************************** --
-- Réaliser les requêtes suivantes :
-- Afficher le chiffre d'affaire global (tous les tickets) avec le montant TTC
SELECT SUM(pt.quantite * p.tarif) AS `CA TTC`
FROM produit_ticket pt
INNER JOIN produit AS p ON pt.id_produit = p.id_produit;

-- Afficher tous les tickets avec : date_creation, le montant TTC du ticket,
SELECT t.date_creation AS `Date du ticket`, SUM(pt.quantite * p.tarif) AS `Total TTC du Ticket`
FROM ticket AS t
INNER JOIN produit_ticket AS pt ON t.id_ticket = pt.id_ticket
INNER JOIN produit AS p ON pt.id_produit = p.id_produit
GROUP BY t.id_ticket;

-- Afficher le ticket 1 avec le nom_produit, quantite, sous-total (quantitetarif*),
SELECT p.nom_produit AS `Nom du produit`, pt.quantite AS `Qté`, pt.quantite * p.tarif AS `Sous-total`
FROM produit AS p
INNER JOIN produit_ticket AS pt ON p.id_produit = pt.id_produit
WHERE pt.id_ticket = 1;

-- Afficher le chiffre d'affaire par année en affichant : année, montant du chiffre affaire,
SELECT YEAR(t.date_creation) AS `Année`, SUM(pt.quantite * p.tarif) AS `CA TTC`
FROM ticket AS t
INNER JOIN produit_ticket AS pt ON pt.id_ticket = t.id_ticket
INNER JOIN produit AS p ON p.id_produit = pt.id_produit
GROUP BY YEAR(t.date_creation)
ORDER BY YEAR(t.date_creation) DESC;

-- Afficher le vendeur qui à réalisé le chiffre d'affaire le plus important avec : nom_vendeur, prenom_vendeur, chiffre affaire,
SELECT v.nom_vendeur AS `Nom du vendeur`, v.prenom_vendeur AS `Prénom du vendeur`, SUM(p.tarif * pt.quantite) AS `CA TTC Vendeur`
FROM vendeur AS v
INNER JOIN ticket AS t ON v.id_vendeur = t.id_vendeur
INNER JOIN produit_ticket AS pt ON t.id_ticket = pt.id_ticket
INNER JOIN produit AS p ON p.id_produit =pt.id_produit
GROUP BY v.id_vendeur
ORDER BY `CA TTC Vendeur` DESC LIMIT 1;

-- Afficher les 3 produits qui sont le plus vendus avec nom_produit, nom_categorie, le chiffre d'affaire du produit,
SELECT p.nom_produit AS `Nom du produit`, c.nom_categorie AS `Catégorie`,  SUM(p.tarif * pt.quantite) AS `CA TTC Produit`
FROM produit AS p
INNER JOIN produit_ticket AS pt ON p.id_produit = pt.id_produit
INNER JOIN categorie AS c ON c.id_categorie = p.id_categorie 
GROUP BY p.id_produit 
ORDER BY `CA TTC Produit` DESC LIMIT 3;

-- Afficher par catégorie le chiffre d'affaire avec : nom_categorie, le montant TTC du chiffre d'affaire de la catégorie.
SELECT c.nom_categorie AS `Nom catégorie`, SUM(p.tarif * pt.quantite) AS `CA TTC Catégorie`
FROM categorie AS c
INNER JOIN produit AS p ON p.id_categorie = c.id_categorie
INNER JOIN produit_ticket AS pt ON p.id_produit = pt.id_produit
GROUP BY c.id_categorie
ORDER BY `CA TTC Catégorie` DESC;