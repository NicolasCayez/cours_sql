-- Nettoyage si relance du script
DROP DATABASE IF EXISTS lundi_exercice_1_blog;
-- Création de la base de données
CREATE DATABASE IF NOT EXISTS lundi_exercice_1_blog CHARSET utf8mb4;
-- Utilisation de la base de donnée pour les scripts suivants
USE lundi_exercice_1_blog;

-- Création des tables
CREATE TABLE roles(
	Id_roles INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	roles_name VARCHAR(50) NOT NULL
)ENGINE=Innodb;

CREATE TABLE account(
	Id_account INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	account_firstname VARCHAR(50) NOT NULL,
	account_lastname VARCHAR(50) NOT NULL,
	account_email VARCHAR(50) NOT NULL UNIQUE,
	account_password VARCHAR(100) NOT NULL,
	account_nickname VARCHAR(50) NOT NULL UNIQUE,
	account_avatar VARCHAR(255),
	account_activation TINYINT(1) NOT NULL,
	account_desactivation_date DATE,
	roles_id_fk INT NOT NULL
)ENGINE=Innodb;

CREATE TABLE note(
	Id_note INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	note_value INT,
	note_reaction TINYINT(1),
	article_id_fk INT NOT NULL,
	account_id_fk INT NOT NULL
)ENGINE=Innodb;

CREATE TABLE media(
	Id_media INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	media_url VARCHAR(255)NOT NULL,
	media_clug VARCHAR(50) NOT NULL
)ENGINE=Innodb;

CREATE TABLE article_media(
	article_id INT NOT NULL,
	media_id INT NOT NULL,
	PRIMARY KEY (article_id, media_id)
)ENGINE=Innodb;

CREATE TABLE category(
	Id_category INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	category_name VARCHAR(50) NOT NULL
)ENGINE=Innodb;

CREATE TABLE article_category(
	article_id INT NOT NULL,
	category_id INT NOT NULL,
	PRIMARY KEY (article_id, category_id)
)ENGINE=Innodb;

CREATE TABLE article(
	Id_article INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	article_title VARCHAR(50) NOT NULL,
	article_content TEXT NOT NULL,
	article_creation_date DATE NOT NULL,
	article_update_date DATE,
	article_slug VARCHAR(50) NOT NULL,
	article_validation TINYINT(1) NOT NULL,
	article_author_fk INT NOT NULL
)ENGINE=Innodb;

CREATE TABLE commentary(
	Id_commentary INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
	commentary_content VARCHAR(50) NOT NULL,
	commentary_creation_date DATETIME NOT NULL,
	commentary_validation TINYINT(1) NOT NULL,
	commentary_author_fk INT NOT NULL,
	article_id_fk INT NOT NULL
)ENGINE=Innodb;

-- Création des contraintes
ALTER TABLE account
ADD CONSTRAINT fk_to_have_roles
FOREIGN KEY (roles_id_fk) REFERENCES roles(Id_roles) 
ON DELETE CASCADE;

ALTER TABLE note
ADD CONSTRAINT fk_to_rate_article
FOREIGN KEY (article_id_fk) REFERENCES article(Id_article) 
ON DELETE CASCADE,
ADD CONSTRAINT fk_to_score_account
FOREIGN KEY (account_id_fk) REFERENCES account(Id_account) 
ON DELETE CASCADE;

ALTER TABLE article_media
ADD CONSTRAINT fk_article_media_article
FOREIGN KEY (article_id) REFERENCES article(Id_article) 
ON DELETE CASCADE,
ADD CONSTRAINT fk_article_media_media
FOREIGN KEY (media_id) REFERENCES media(Id_media) 
ON DELETE CASCADE;

ALTER TABLE article_category
ADD CONSTRAINT fk_article_category_article
FOREIGN KEY (article_id) REFERENCES article(Id_article) 
ON DELETE CASCADE,
ADD CONSTRAINT fk_article_category_category
FOREIGN KEY (category_id) REFERENCES category(Id_category) 
ON DELETE CASCADE;

ALTER TABLE article
ADD CONSTRAINT fk_to_write_account
FOREIGN KEY (article_author_fk) REFERENCES account(Id_account) 
ON DELETE CASCADE;

ALTER TABLE commentary
ADD CONSTRAINT fk_to_comment_account
FOREIGN KEY (commentary_author_fk) REFERENCES account(Id_account) 
ON DELETE CASCADE,
ADD CONSTRAINT fk_to_add_article
FOREIGN KEY (article_id_fk) REFERENCES article (Id_article) 
ON DELETE CASCADE;





















