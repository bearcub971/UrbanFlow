--Ecrivez une requête qui retourne le chiffre d'affaires par mois de l'année 2024. Vous devrez retourner dans 2 colonnes mois et chiffre_affaires, le mois en toutes lettres et le chiffre d'affaires en euros (sans le signe €).
SELECT
    TO_CHAR(a.date_debut, 'Month') AS mois,
    SUM(t.prix_centimes) AS chiffre_affaires
FROM abonnements a
JOIN tarifications t ON a.id_tarification = t.id
WHERE EXTRACT(YEAR FROM a.date_debut) = 2024
GROUP BY mois, EXTRACT(MONTH FROM a.date_debut)
ORDER BY EXTRACT(MONTH FROM a.date_debut);

--Dans une requête SQL, listez par ordre de passage, les lignes de transports qui passent à la station Nation autour de 17 heures 28 minutes et 16 secondes à plus-ou-moins 4 minutes.
SELECT DISTINCT l.nom AS ligne, h.horaire 
FROM horaires h
JOIN arrets a ON h.id_arret = a.id
JOIN lignes l ON a.id_ligne = l.id
JOIN stations s ON a.id_station = s.id
WHERE s.nom = 'Nation'
AND h.horaire BETWEEN '17:24:16' AND '17:32:16'
ORDER BY h.horaire;

--Récupérez dans une requête SQL dans des colonnes moy_validation et abonnement, la moyenne des validations par mois selon les différents abonnements (tarifications). Triez par moyennes décroissantes puis par nom de tarification dans l'ordre alphabétique.
SELECT 
    t.nom AS abonnement, 
    DATE_TRUNC('month', v.date_heure_validation) AS mois, 
    COUNT(v.id) * 1.0 / COUNT(DISTINCT DATE_TRUNC('month', v.date_heure_validation)) AS moy_validation
FROM validations v
JOIN abonnements a ON v.id_support = a.id_support
JOIN tarifications t ON a.id_tarification = t.id
GROUP BY t.nom, DATE_TRUNC('month', v.date_heure_validation)
ORDER BY moy_validation DESC, abonnement ASC;


--Créez une vue permettant de voir la moyenne de passagers par jour de la semaine (lundi, mardi, ... dimanche) sur les 12 derniers mois. La vue devra avoir 2 colonnes : moy_passagers, jour_semaine. Triez par jour de la semaine.
CREATE VIEW vue_moy_passagers_par_jour AS
SELECT 
    TO_CHAR(v.date_heure_validation, 'Day') AS jour_semaine,
    COUNT(v.id) * 1.0 / COUNT(DISTINCT DATE_TRUNC('day', v.date_heure_validation)) AS moy_passagers
FROM validations v
WHERE v.date_heure_validation >= NOW() - INTERVAL '12 months'
GROUP BY TO_CHAR(v.date_heure_validation, 'Day')
ORDER BY 
    CASE 
        WHEN TO_CHAR(v.date_heure_validation, 'Day') = '1' THEN 2  -- Lundi
        WHEN TO_CHAR(v.date_heure_validation, 'Day') = '2' THEN 3  -- Mardi
        WHEN TO_CHAR(v.date_heure_validation, 'Day') = '3' THEN 4  -- Mercredi
        WHEN TO_CHAR(v.date_heure_validation, 'Day') = '4' THEN 5  -- Jeudi
        WHEN TO_CHAR(v.date_heure_validation, 'Day') = '5' THEN 6  -- Vendredi
        WHEN TO_CHAR(v.date_heure_validation, 'Day') = '6' THEN 7  -- Samedi
        WHEN TO_CHAR(v.date_heure_validation, 'Day') = '7' THEN 1  -- Dimanche
    END;

--Créez une vue permettant d'avoir le taux de remplissage moyen de chaque ligne de transport sur le réseau.
--Le taux de remplissage étant nombre moyen de passagers par ligne par jour / nb de train
--par jour sur la ligne / capacite max ligne. Considérez pour connaître le nombre de train par
--jour d'une ligne, qu'il y'a un metro toutes les 6 minutes entre 500 du matin et 130 du matin (le lendemain)
--et un RER toutes les 15 minutes de 5H00 à 1H30 aussi. Renvoyez le résultat dans 2 colonnes
--taux_remplissage et nom_ligne.

CREATE VIEW vue_taux_remplissage_par_ligne AS
SELECT
    l.nom AS nom_ligne,
    ROUND(
        (
            AVG(passagers_par_jour) / (nb_trains_par_jour * l.capacite_max)
        ) * 100, 2
    ) AS taux_remplissage
FROM (
    SELECT
        a.id_ligne,
        DATE_TRUNC('day', v.date_heure_validation) AS jour,
        COUNT(v.id) AS passagers_par_jour
    FROM validations v
    JOIN arrets a ON v.id_station = a.id_station
    WHERE v.date_heure_validation >= NOW() - INTERVAL '12 months'
    GROUP BY a.id_ligne, jour
) AS passagers
JOIN lignes l ON passagers.id_ligne = l.id
JOIN (
    SELECT
        l.id AS id_ligne,
        CASE 
            WHEN l.type = 'metro' THEN 1230 / 6  
            WHEN l.type = 'rer' THEN 1230 / 15 
            ELSE 0  
        END AS nb_trains_par_jour
    FROM lignes l
) AS trains_par_jour ON trains_par_jour.id_ligne = l.id
GROUP BY l.id, l.nom, nb_trains_par_jour
ORDER BY l.nom;

.


