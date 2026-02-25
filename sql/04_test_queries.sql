-- =========================================================
-- Script : Requêtes de vérification
-- Base : tifosi
-- =========================================================

USE tifosi;

-- =========================================================
-- 1. Liste des focaccias par ordre alphabétique
-- =========================================================
-- But : Vérifier l’insertion correcte des focaccias

SELECT nom
FROM focaccia
ORDER BY nom ASC;

-- Résultat attendu : Liste triée alphabétiquement
-- Résultat obtenu : À vérifier après exécution
-- Analyse : Aucun écart attendu


-- =========================================================
-- 2. Nombre total d’ingrédients
-- =========================================================

SELECT COUNT(*) AS total_ingredients
FROM ingredient;

-- Résultat attendu : Nombre correspondant au fichier Excel
-- Résultat obtenu : À vérifier
-- Analyse : Aucun écart attendu


-- =========================================================
-- 3. Prix moyen des focaccias
-- =========================================================

SELECT AVG(prix) AS prix_moyen
FROM focaccia;

-- Résultat attendu : Moyenne correcte des prix
-- Résultat obtenu : À vérifier
-- Analyse : Vérifier cohérence avec Excel


-- =========================================================
-- 4. Liste des boissons avec leur marque
-- =========================================================

SELECT b.nom AS boisson,
       m.nom AS marque
FROM boisson b
JOIN marque m ON b.id_marque = m.id_marque
ORDER BY b.nom ASC;

-- Résultat attendu : Chaque boisson associée à sa marque
-- Résultat obtenu : À vérifier
-- Analyse : Jointure interne correcte


-- =========================================================
-- 5. Liste des ingrédients pour la "Raclaccia"
-- =========================================================

SELECT i.nom
FROM focaccia f
JOIN focaccia_ingredient fi ON f.id_focaccia = fi.id_focaccia
JOIN ingredient i ON fi.id_ingredient = i.id_ingredient
WHERE f.nom = 'Raclaccia';

-- Résultat attendu : Liste des ingrédients correspondants
-- Résultat obtenu : À vérifier
-- Analyse : Vérifier cohérence avec Excel


-- =========================================================
-- 6. Nom et nombre d’ingrédients pour chaque focaccia
-- =========================================================

SELECT f.nom,
       COUNT(fi.id_ingredient) AS nombre_ingredients
FROM focaccia f
LEFT JOIN focaccia_ingredient fi
    ON f.id_focaccia = fi.id_focaccia
GROUP BY f.id_focaccia;

-- Résultat attendu : Nombre correct par focaccia
-- Résultat obtenu : À vérifier
-- Analyse : LEFT JOIN pour inclure toutes les focaccias


-- =========================================================
-- 7. Focaccia avec le plus d’ingrédients
-- =========================================================

SELECT f.nom,
       COUNT(fi.id_ingredient) AS nb
FROM focaccia f
JOIN focaccia_ingredient fi
    ON f.id_focaccia = fi.id_focaccia
GROUP BY f.id_focaccia
ORDER BY nb DESC
LIMIT 1;

-- Résultat attendu : La focaccia la plus garnie
-- Résultat obtenu : À vérifier
-- Analyse : Tri décroissant + LIMIT 1


-- =========================================================
-- 8. Focaccias contenant de l’ail
-- =========================================================

SELECT DISTINCT f.nom
FROM focaccia f
JOIN focaccia_ingredient fi
    ON f.id_focaccia = fi.id_focaccia
JOIN ingredient i
    ON fi.id_ingredient = i.id_ingredient
WHERE LOWER(i.nom) = 'ail';

-- Résultat attendu : Focaccias contenant l’ail
-- Résultat obtenu : À vérifier
-- Analyse : LOWER pour éviter problèmes casse


-- =========================================================
-- 9. Ingrédients inutilisés
-- =========================================================

SELECT i.nom
FROM ingredient i
LEFT JOIN focaccia_ingredient fi
    ON i.id_ingredient = fi.id_ingredient
WHERE fi.id_ingredient IS NULL;

-- Résultat attendu : Ingrédients non associés
-- Résultat obtenu : À vérifier
-- Analyse : LEFT JOIN obligatoire


-- =========================================================
-- 10. Focaccias sans champignons
-- =========================================================

SELECT f.nom
FROM focaccia f
WHERE f.id_focaccia NOT IN (
    SELECT f2.id_focaccia
    FROM focaccia f2
    JOIN focaccia_ingredient fi
        ON f2.id_focaccia = fi.id_focaccia
    JOIN ingredient i
        ON fi.id_ingredient = i.id_ingredient
    WHERE LOWER(i.nom) LIKE '%champignon%'
);

-- Résultat attendu : Focaccias sans champignons
-- Résultat obtenu : À vérifier
-- Analyse : Sous-requête d’exclusion