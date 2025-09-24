--Listez dans une colonne station les stations desservies par au moins un metro et un RER. Triez par ordre alphabétique.
SELECT DISTINCT s.nom AS station FROM stations s JOIN arrets a1 ON s.id = a1.id_station JOIN lignes l1 ON a1.id_ligne = l1.id JOIN arrets a2 ON s.id = a2.id_station JOIN lignes l2 ON a2.id_ligne = l2.id WHERE l1.type = 'metro' AND l2.type = 'train' ORDER BY station;

--Affichez dans des colonnes nom_forfait, nb_abonnements les 3 forfaits les plus populaires, du plus populaire au moins populaire. La popularité d'un forfait se base sur le nombre d'abonnements actifs pour ce même forfait.
SELECT t.nom AS nom_forfait, COUNT(a.id) AS nb_abonnements FROM abonnements a JOIN tarifications t ON a.id_tarification = t.id WHERE a.date_fin >= NOW() GROUP BY t.nom ORDER BY nb_abonnements DESC LIMIT 3;

--Dans une requête SQL, affichez la capacité moyenne de chaque station listée dans l'ordre alphabétique dans 2 colonnes station et capacite_moy
SELECT s.nom AS station, AVG(l.capacite_max) AS capacite_moy FROM stations s JOIN arrets a ON s.id = a.id_station JOIN lignes l ON a.id_ligne = l.id GROUP BY s.nom ORDER BY station;


--Ecrivez une vue SQL abonnes_par_departement qui affiche pour chaque département et code postal, le nombre d'abonnés y habitant (departement, code_postal, nb_abonnes). Ordonnez les résultats par code postal.
CREATE VIEW abonnes_par_departement AS SELECT ac.departement, ac.code_postal, COUNT(dc.id) AS nb_abonnes FROM dossiers_client dc JOIN adresses_client ac ON dc.id_adresse_residence = ac.id GROUP BY ac.departement, ac.code_postal ORDER BY ac.code_postal;

--Dans une requête SQL, retournez le nombre total d'usagers par tranche d'âge :
-- - 18 ans (moins_18)
--18-25 ans (18_24)
--25-40 ans (25_40)
--40-60 ans (40-60)
-- + 60 ans (plus_60)
--Vous devrez retourner une colonne par tranche d'âge.
SELECT 
    COUNT(CASE WHEN EXTRACT(YEAR FROM AGE(dc.date_naissance)) < 18 THEN 1 END) AS moins_18,
    COUNT(CASE WHEN EXTRACT(YEAR FROM AGE(dc.date_naissance)) BETWEEN 18 AND 24 THEN 1 END) AS "18_24",
    COUNT(CASE WHEN EXTRACT(YEAR FROM AGE(dc.date_naissance)) BETWEEN 25 AND 40 THEN 1 END) AS "25_40",
    COUNT(CASE WHEN EXTRACT(YEAR FROM AGE(dc.date_naissance)) BETWEEN 41 AND 60 THEN 1 END) AS "40_60",
    COUNT(CASE WHEN EXTRACT(YEAR FROM AGE(dc.date_naissance)) > 60 THEN 1 END) AS plus_60
FROM dossiers_client dc;


--Listez dans une vue frequentation_stations, dans 2 colonnes station et frequentation, les 10 stations les plus fréquentées depuis toujours. La fréquentation se mesure par le nombre de validation. Triez les de la plus fréquentée à la moins fréquentée
CREATE VIEW frequentation_stations AS
SELECT s.nom AS station, COUNT(v.id) AS frequentation
FROM stations s
JOIN arrets a ON s.id = a.id_station
JOIN validations v ON a.id_station = v.id_station
GROUP BY s.nom
ORDER BY frequentation DESC
LIMIT 10;



