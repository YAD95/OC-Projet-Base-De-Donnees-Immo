# 🏠 Real Estate Market Analysis – Laplace Immo Database

Projet réalisé dans le cadre de la formation **Data Engineer - OpenClassrooms**.

Dans ce projet, l'objectif est de concevoir une base de données relationnelle permettant de centraliser et analyser les transactions immobilières en France afin d'aider l'agence **Laplace Immo** à mieux comprendre les dynamiques du marché.

L'analyse porte sur les transactions immobilières du **premier semestre 2020**.

---

# 🎯 Objectif du projet

Les objectifs de ce projet sont :

* structurer les données immobilières dans une base relationnelle
* nettoyer et transformer les données sources
* concevoir un schéma relationnel normalisé
* charger les données dans une base SQLite
* réaliser des analyses du marché immobilier à l'aide de requêtes SQL

---

# 🗂️ Données utilisées

Les données utilisées proviennent de deux sources principales :

**DVF (Demandes de Valeurs Foncières)**
Contient les transactions immobilières (date de mutation, valeur foncière, surface, type de bien, nombre de pièces, etc.).

**Référentiel géographique**
Contient les informations sur les régions, départements, communes ainsi que les données de population.

Ces données ont été nettoyées et préparées avant leur intégration dans la base de données.

---

# 🏗️ Modélisation de la base de données

La base de données a été conçue selon les principes de **normalisation (3NF)**.

Les tables principales sont :

* `region`
* `departement`
* `commune`
* `vente`

Chaque transaction immobilière est reliée à sa commune, son département et sa région grâce à des **clés étrangères** garantissant l'intégrité des données.

---

# 🔧 Transformation et nettoyage des données

Plusieurs transformations ont été appliquées :

* sélection des colonnes utiles
* suppression des colonnes redondantes
* suppression des doublons dans les dimensions géographiques
* conversion des formats numériques
* gestion des valeurs manquantes
* création d'une **vue `vente_clean`**

Cette vue permet notamment de convertir la colonne `date_mutation` au format **ISO (YYYY-MM-DD)** afin de faciliter les analyses temporelles.

---

# 📊 Analyses SQL réalisées

Plusieurs requêtes SQL ont été développées pour analyser le marché immobilier.

Exemples d'analyses réalisées :

* nombre total d'appartements vendus
* nombre de ventes par région
* proportion d'appartements selon le nombre de pièces
* classement des départements selon le prix moyen au m²
* prix moyen au m² des maisons en Île-de-France
* évolution du nombre de ventes entre le T1 et le T2 2020
* communes avec le plus de transactions pour 1000 habitants

Un fichier contenant **des exemples de requêtes SQL utilisées dans l'analyse** est disponible dans le projet.

---

# 🛠️ Technologies utilisées

* SQL
* SQLite
* Modélisation relationnelle
* Normalisation des bases de données
* Analyse de données

---

# 📂 Contenu du repository

example_sql_queries.sql → exemples de requêtes SQL utilisées pour l'analyse
data_dictionary.xlsx → dictionnaire des données
project_presentation.pptx → présentation du projet

---

# 🔒 Sauvegarde et conformité RGPD

Pour ce POC, la base de données est stockée localement sous **SQLite** afin de faciliter la reproductibilité.

Seules les variables nécessaires à l'analyse ont été conservées afin de respecter les principes de **minimisation des données du RGPD**.

Les résultats sont présentés sous forme **agrégée** (par région, département ou commune).

---

# 👨‍💻 Auteur

YAD95
Projet OpenClassrooms – Data Engineer
