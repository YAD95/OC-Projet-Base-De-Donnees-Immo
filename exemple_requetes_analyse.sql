-- ==============================================================================
-- PROJET LAPLACE IMMO : ANALYSE DES TRANSACTIONS (S1 2020)
-- ==============================================================================

-- 1. Les 20 communes avec le plus de transactions pour 1000 habitants (communes > 10 000 hab)
SELECT
  c.nom_commune,
  d.code_departement,
  r.nom_region,
  c.population_totale,
  COUNT(v.id_vente) AS nb_transactions,
  ROUND(1000.0 * COUNT(v.id_vente) / c.population_totale, 3) AS transactions_pour_1000_hab
FROM vente_clean v
JOIN commune c ON v.id_codedep_codecommune = c.id_codedep_codecommune
JOIN departement d ON c.code_departement = d.code_departement
JOIN region r ON d.code_region = r.code_region
WHERE v.nature_mutation = 'Vente'
  AND c.population_totale > 10000
GROUP BY c.nom_commune
ORDER BY transactions_pour_1000_hab DESC
LIMIT 20;

-- 2. Les moyennes de valeurs foncières pour le top 3 des communes des départements 6, 13, 33, 59 et 69. : 

WITH moyennes AS (
  SELECT
    d.code_departement,
    c.nom_commune,
    AVG(v.valeur_fonciere) AS valeur_fonciere_moy
  FROM vente_clean v
  JOIN commune c ON v.id_codedep_codecommune = c.id_codedep_codecommune
  JOIN departement d ON c.code_departement = d.code_departement
  WHERE v.nature_mutation = 'Vente'
    AND v.valeur_fonciere IS NOT NULL
    AND d.code_departement IN ('06','13','33','59','69')
  GROUP BY d.code_departement, c.nom_commune
),
classement AS (
  SELECT
    *,
    ROW_NUMBER() OVER (
      PARTITION BY code_departement
      ORDER BY valeur_fonciere_moy DESC
    ) AS rang
  FROM moyennes
)
SELECT
  code_departement,
  nom_commune,
  ROUND(valeur_fonciere_moy, 2) AS valeur_fonciere_moy
FROM classement
WHERE rang <= 3
ORDER BY code_departement, valeur_fonciere_moy DESC;


-- 3. Différence en pourcentage du prix au mètre carré entre un appartement de 2 pièces et un appartement de 3 pièces.

WITH prix_m2 AS (
  SELECT
    nb_pieces_principales AS nb_pieces,
    AVG(valeur_fonciere / surface_reelle_bati) AS prix_m2_moyen
  FROM vente_clean
  WHERE type_local = 'Appartement'
    AND nature_mutation = 'Vente'
    AND nb_pieces_principales IN (2, 3)
    AND valeur_fonciere IS NOT NULL
    AND surface_reelle_bati IS NOT NULL
    AND surface_reelle_bati > 0
  GROUP BY nb_pieces_principales
)

SELECT
  ROUND((SELECT prix_m2_moyen FROM prix_m2 WHERE nb_pieces = 2), 2) AS prix_m2_2p,
  ROUND((SELECT prix_m2_moyen FROM prix_m2 WHERE nb_pieces = 3), 2) AS prix_m2_3p,

  ROUND(
    100.0 *
    (
      (SELECT prix_m2_moyen FROM prix_m2 WHERE nb_pieces = 3)
      -
      (SELECT prix_m2_moyen FROM prix_m2 WHERE nb_pieces = 2)
    )
    /
    (SELECT prix_m2_moyen FROM prix_m2 WHERE nb_pieces = 2)
  , 2) AS diff_pct_3p_vs_2p;



-- 4. Le classement des régions par rapport au prix au mètre carré des
appartement de plus de 4 pièces.

SELECT
  r.nom_region AS region,
  ROUND(AVG(v.valeur_fonciere / v.surface_reelle_bati), 2) AS prix_m2_moyen
FROM vente_clean v
JOIN commune c
  ON v.id_codedep_codecommune = c.id_codedep_codecommune
JOIN departement d
  ON c.code_departement = d.code_departement
JOIN region r
  ON d.code_region = r.code_region
WHERE v.type_local = 'Appartement'
  AND v.nature_mutation = 'Vente'
  AND v.nb_pieces_principales > 4
  AND v.valeur_fonciere IS NOT NULL
  AND v.surface_reelle_bati IS NOT NULL
  AND v.surface_reelle_bati > 0
GROUP BY r.nom_region
ORDER BY prix_m2_moyen DESC;

