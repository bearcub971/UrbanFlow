--Ecrivez une requête qui renvoie le nombre de dossiers incomplets dans un colonne nommée nb_dossiers_incomplets.
SELECT COUNT(*)AS nb_dossiers_incomplets FROM dossiers_client WHERE statut = 'incomplet';

--Ecrivez une requête qui renvoie les lignes suivies des stations qu'elles desservent dans l'ordre alphabatique dans 2 colonnes ligne et stations.
SELECT l.nom AS ligne, s.nom AS station FROM lignes l JOIN arrets a ON l.id = a.id_ligne JOIN stations s ON a.id_station = s.id ORDER BY l.nom, s.nom;

--Ecrivez une requête qui retourne le nombre de stations par moyen de transport de celle qui en a le plus, à celle qui en a le moins, dans 2 colonnes moyen_transport, nb_stations.
SELECT l.type AS moyen_transport, COUNT(DISTINCT s.id) AS nb_stations FROM lignes l JOIN arrets a ON l.id = a.id_ligne JOIN stations s ON a.id_station = s.id GROUP BY l.type ORDER BY nb_stations DESC;

--Ecrivez une requête qui liste le nombre d'abonnements par tarification qui expirent à la fin du mois de janvier 2025, on souhaite récupérer ces informations dans 2 colonnes nom_tarification, nb_abonnements de la tarification ayant le moins de d'abonnements qui expirent, à celle qui en a le plus.
SELECT t.nom AS nom_tarification, COUNT(a.id) AS nb_abonnements FROM abonnements a JOIN tarifications t ON a.id_tarification = t.id WHERE a.date_fin BETWEEN '2025-01-01' AND '2025-01-31 23:59:59' GROUP BY t.nom ORDER BY nb_abonnements ASC;

--Ecrivez une vue SQL dossiers_en_validation qui renvoie toutes les informations des dossiers en validation du plus ancien au plus récent.
CREATE VIEW dossiers_en_validation AS SELECT dc.* FROM dossiers_client dc WHERE statut = 'validation' JOIN abonnements a ON dc.id = a.id_dossier JOIN validations v ON a.id_support = v.id_support ORDER BY v.date_heure_validation ASC;
