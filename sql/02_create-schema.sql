-- =========================================================
-- Base : tifosi
-- Script : Création du schéma relationnel (aligné MCD)
-- Objectif : Implémentation physique + intégrité référentielle
--
-- Note sur les cardinalités 1,n (menu->boisson, focaccia->ingredient) :
-- MySQL ne peut pas garantir "au moins 1" uniquement via des FK.
-- Cette contrainte est assurée lors du peuplement / côté applicatif
-- (ou via trigger si explicitement demandé).
-- =========================================================

USE tifosi;

-- =========================================================
-- TABLE : ingredient
-- MCD : id_ingredient INT, nom VARCHAR(50)
-- =========================================================
CREATE TABLE ingredient (
    id_ingredient INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL UNIQUE
);

-- =========================================================
-- TABLE : focaccia
-- MCD : id_focaccia INT, nom VARCHAR(50), prix DECIMAL(5,2)
-- =========================================================
CREATE TABLE focaccia (
    id_focaccia INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL UNIQUE,
    prix DECIMAL(5,2) NOT NULL,
    CONSTRAINT chk_prix_focaccia CHECK (prix >= 0)
);

-- =========================================================
-- ASSOCIATION : comprend (focaccia <-> ingredient) avec quantite INT
-- =========================================================
CREATE TABLE focaccia_ingredient (
    id_focaccia INT NOT NULL,
    id_ingredient INT NOT NULL,
    quantite INT NOT NULL,
    PRIMARY KEY (id_focaccia, id_ingredient),

    CONSTRAINT chk_quantite_fi CHECK (quantite > 0),

    CONSTRAINT fk_fi_focaccia
        FOREIGN KEY (id_focaccia)
        REFERENCES focaccia(id_focaccia)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_fi_ingredient
        FOREIGN KEY (id_ingredient)
        REFERENCES ingredient(id_ingredient)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- =========================================================
-- TABLE : client
-- MCD : id_client INT, nom VARCHAR(50), email VARCHAR(50), code_postal INT
-- =========================================================
CREATE TABLE client (
    id_client INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    code_postal INT NOT NULL
);

-- =========================================================
-- TABLE : marque
-- MCD : id_marque INT, nom VARCHAR(50)
-- =========================================================
CREATE TABLE marque (
    id_marque INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL UNIQUE
);

-- =========================================================
-- TABLE : boisson
-- MCD : id_boisson INT, nom VARCHAR(50)
-- Relation : appartient (marque 0,n -> boisson 1,1)
-- =========================================================
CREATE TABLE boisson (
    id_boisson INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    id_marque INT NOT NULL,

    CONSTRAINT fk_boisson_marque
        FOREIGN KEY (id_marque)
        REFERENCES marque(id_marque)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- =========================================================
-- TABLE : menu
-- MCD : id_menu INT, nom VARCHAR(50), prix DECIMAL(5,2)
-- Relation : est_constitué (menu 1,1 -> focaccia 0,n)
-- => FK id_focaccia dans menu
-- =========================================================
CREATE TABLE menu (
    id_menu INT AUTO_INCREMENT PRIMARY KEY,
    nom VARCHAR(50) NOT NULL,
    prix DECIMAL(5,2) NOT NULL,
    id_focaccia INT NOT NULL,

    CONSTRAINT chk_prix_menu CHECK (prix >= 0),

    CONSTRAINT fk_menu_focaccia
        FOREIGN KEY (id_focaccia)
        REFERENCES focaccia(id_focaccia)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- =========================================================
-- ASSOCIATION : contient (menu <-> boisson)
-- Cardinalité MCD : menu 1,n ; boisson 0,n
-- =========================================================
CREATE TABLE menu_boisson (
    id_menu INT NOT NULL,
    id_boisson INT NOT NULL,
    PRIMARY KEY (id_menu, id_boisson),

    CONSTRAINT fk_mb_menu
        FOREIGN KEY (id_menu)
        REFERENCES menu(id_menu)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_mb_boisson
        FOREIGN KEY (id_boisson)
        REFERENCES boisson(id_boisson)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

-- =========================================================
-- ASSOCIATION : achete (client <-> menu) avec date_achat DATE
-- Cardinalité MCD : 0,n des deux côtés
-- =========================================================
CREATE TABLE achat (
    id_client INT NOT NULL,
    id_menu INT NOT NULL,
    date_achat DATE NOT NULL,
    PRIMARY KEY (id_client, id_menu, date_achat),

    CONSTRAINT fk_achat_client
        FOREIGN KEY (id_client)
        REFERENCES client(id_client)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_achat_menu
        FOREIGN KEY (id_menu)
        REFERENCES menu(id_menu)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);