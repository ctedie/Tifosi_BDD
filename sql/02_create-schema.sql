-- =========================================================
-- Base : tifosi
-- Script : Création du schéma relationnel
-- Objectif : Implémentation physique sécurisée
-- =========================================================

USE tifosi;

-- =========================================================
-- TABLE : client
-- Rôle : Stocke les clients du restaurant
-- Contraintes :
-- - Email unique
-- - Champs obligatoires
-- =========================================================

CREATE TABLE client (
    id_client INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    code_postal VARCHAR(10) NOT NULL
);

-- =========================================================
-- TABLE : marque
-- Rôle : Stocke les marques des boissons
-- =========================================================

CREATE TABLE marque (
    id_marque INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL UNIQUE
);

-- =========================================================
-- TABLE : boisson
-- Rôle : Stocke les boissons
-- Contraintes :
-- - Appartient obligatoirement à une marque
-- =========================================================

CREATE TABLE boisson (
    id_boisson INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    id_marque INT NOT NULL,

    CONSTRAINT fk_boisson_marque
        FOREIGN KEY (id_marque)
        REFERENCES marque(id_marque)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- =========================================================
-- TABLE : focaccia
-- Rôle : Stocke les focaccias vendues
-- Contraintes :
-- - Nom unique
-- - Prix positif
-- =========================================================

CREATE TABLE focaccia (
    id_focaccia INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL UNIQUE,
    prix DECIMAL(6,2) NOT NULL,
    
    CONSTRAINT chk_prix_focaccia
        CHECK (prix >= 0)
);

-- =========================================================
-- TABLE : ingredient
-- Rôle : Stocke les ingrédients
-- =========================================================

CREATE TABLE ingredient (
    id_ingredient INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL UNIQUE
);

-- =========================================================
-- TABLE D'ASSOCIATION : focaccia_ingredient
-- Relation N:N entre focaccia et ingredient
-- =========================================================

CREATE TABLE focaccia_ingredient (
    id_focaccia INT NOT NULL,
    id_ingredient INT NOT NULL,
    quantite INT NOT NULL CHECK (quantite > 0),

    PRIMARY KEY (id_focaccia, id_ingredient),

    CONSTRAINT fk_fi_focaccia
        FOREIGN KEY (id_focaccia)
        REFERENCES focaccia(id_focaccia)
        ON DELETE CASCADE,

    CONSTRAINT fk_fi_ingredient
        FOREIGN KEY (id_ingredient)
        REFERENCES ingredient(id_ingredient)
        ON DELETE RESTRICT
);

-- =========================================================
-- TABLE : menu
-- Rôle : Stocke les menus
-- Hypothèse : Un menu contient une focaccia
-- =========================================================

CREATE TABLE menu (
    id_menu INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prix DECIMAL(6,2) NOT NULL,
    id_focaccia INT NOT NULL,

    CONSTRAINT chk_prix_menu
        CHECK (prix >= 0),

    CONSTRAINT fk_menu_focaccia
        FOREIGN KEY (id_focaccia)
        REFERENCES focaccia(id_focaccia)
        ON DELETE RESTRICT
);

-- =========================================================
-- TABLE D'ASSOCIATION : menu_boisson
-- Relation N:N entre menu et boisson
-- =========================================================

CREATE TABLE menu_boisson (
    id_menu INT NOT NULL,
    id_boisson INT NOT NULL,

    PRIMARY KEY (id_menu, id_boisson),

    CONSTRAINT fk_mb_menu
        FOREIGN KEY (id_menu)
        REFERENCES menu(id_menu)
        ON DELETE CASCADE,

    CONSTRAINT fk_mb_boisson
        FOREIGN KEY (id_boisson)
        REFERENCES boisson(id_boisson)
        ON DELETE RESTRICT
);

-- =========================================================
-- TABLE D'ASSOCIATION : achat
-- Relation N:N entre client et menu
-- =========================================================

CREATE TABLE achat (
    id_client INT NOT NULL,
    id_menu INT NOT NULL,
    date_achat DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (id_client, id_menu, date_achat),

    CONSTRAINT fk_achat_client
        FOREIGN KEY (id_client)
        REFERENCES client(id_client)
        ON DELETE CASCADE,

    CONSTRAINT fk_achat_menu
        FOREIGN KEY (id_menu)
        REFERENCES menu(id_menu)
        ON DELETE RESTRICT
);