-- Utilisation de la base de donnée pour les scripts suivants
USE lundi_exercice_3_basket ;

-- Suppression des contraintes avant exécution des scripts
ALTER TABLE partie
DROP CONSTRAINT IF EXISTS score_equipe_1,
DROP CONSTRAINT IF EXISTS score_equipe_2;

ALTER TABLE equipe
DROP CONSTRAINT IF EXISTS longueur_nom_equipe;

ALTER TABLE adresse
DROP CONSTRAINT IF EXISTS longueur_code_postal;

-- Création des contraintes
ALTER TABLE partie
ADD CONSTRAINT score_equipe_1
CHECK (score_equipe_1 > 0),
ADD CONSTRAINT score_equipe_2
CHECK (score_equipe_2 > 0);

ALTER TABLE equipe
ADD CONSTRAINT longueur_nom_equipe
CHECK (LENGTH(nom_equipe) >= 4);

ALTER TABLE adresse
ADD CONSTRAINT longueur_code_postal
CHECK (LENGTH(code_postal) = 4);

















