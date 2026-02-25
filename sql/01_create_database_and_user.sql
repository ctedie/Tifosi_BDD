-- =========================================================
-- Script : Création de la base de données et de l'utilisateur
-- Projet : TIFOSI
-- Objectif :
--   - Créer la base de données tifosi
--   - Créer un utilisateur dédié
--   - Attribuer les droits nécessaires
-- =========================================================

-- ---------------------------------------------------------
-- Suppression préalable (sécurisée pour environnement local)
-- À utiliser uniquement en environnement de développement
-- ---------------------------------------------------------

DROP DATABASE IF EXISTS tifosi;

-- ---------------------------------------------------------
-- Création de la base de données
-- Encodage UTF8MB4 recommandé pour compatibilité complète
-- ---------------------------------------------------------

CREATE DATABASE tifosi
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

-- ---------------------------------------------------------
-- Sélection de la base
-- ---------------------------------------------------------

USE tifosi;