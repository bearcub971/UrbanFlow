# 🌆 UrbanFlow

##💡 Projet réalisé dans le cadre du module Requêtage SQL – Année 2024/2025 (ESGI).

**UrbanFlow** est un projet académique en SQL visant à modéliser et interroger une base de données pour gérer un réseau de transport public (métro et RER).  
Il illustre la gestion des **lignes**, **stations**, **arrêts**, **horaires**, des **supports (tickets et abonnements)** ainsi que le suivi des **validations de voyages**.  
Le projet met l’accent sur l’écriture de requêtes SQL complexes, l’utilisation de vues, et l’analyse de données pour fournir des indicateurs clés.

---

## 🚀 Objectifs

- Créer et exploiter une **base de données relationnelle** dédiée au transport urbain.  
- Écrire des **requêtes SQL** du plus simple au plus complexe.  
- Produire des **vues réutilisables** pour répondre à des besoins métier.  
- Réaliser des analyses avancées (fréquentation, chiffre d’affaires, taux de remplissage, etc.).  

---

## 🛠️ Prérequis

- Serveur de base de données **PostgreSQL** (ou MySQL, selon implémentation).  
- Client SQL (ex. `psql`, `mysql`, **DBeaver**, **PhpMyAdmin**, ou **DataGrip**).  

Vérifier l’installation de PostgreSQL :
```bash
psql --version
```

##📂 Structure du projet

init_database.sql → création du schéma relationnel.

data.sql → insertion des données initiales.

src/level_1.sql → requêtes de niveau 1.

src/level_2.sql → requêtes de niveau 2.

src/level_3.sql → requêtes de niveau 3.

src/level_4.sql → requêtes de niveau 4.


##⚙️ Installation

Créer une base vide
```bash
CREATE DATABASE urbanflow;
```

##Importer la structure
```
psql -d urbanflow -f init_database.sql
```

##Charger les données initiales
```

psql -d urbanflow -f data.sql
```

##Exécuter les requêtes selon les niveaux
```

psql -d urbanflow -f src/level_1.sql
psql -d urbanflow -f src/level_2.sql
psql -d urbanflow -f src/level_3.sql
psql -d urbanflow -f src/level_4.sql
```

##🏆 Critères d’évaluation

✅ Validité des résultats (requêtes et vues correctes).

✅ Performance et optimisation des requêtes.

✅ Lisibilité et qualité du code SQL.

✅ Organisation claire du rendu (init_database.sql + dossiers src/level_X.sql).

##📌 Exemple de requêtes

-- Exemple : Nombre de dossiers incomplets
SELECT COUNT(*) AS nb_dossiers_incomplets
FROM dossiers
WHERE statut = 'incomplet';

-- Exemple : Chiffre d’affaires des tickets par mois en 2024
SELECT EXTRACT(MONTH FROM date_achat) AS mois,
       SUM(prix) AS chiffre_affaires
FROM tickets
WHERE EXTRACT(YEAR FROM date_achat) = 2024
GROUP BY mois
ORDER BY mois;
