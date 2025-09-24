--Renvoyez dans une requête SQL le pourcentage de passagers avec un abonnement contre ceux avec des tickets. 
--Considérez de manière unique les passagers en fonction du support utilisé. Votre résultat sera retourné dans 2 colonnes part_abonnement, part_ticket.
SELECT
    ROUND(
        (COUNT(DISTINCT a.id_support) * 1.0 / COUNT(DISTINCT s.id)) * 100,
        2
    ) AS part_abonnement,
    ROUND(
        (COUNT(DISTINCT t.id_support) * 1.0 / COUNT(DISTINCT s.id)) * 100,
        2
    ) AS part_ticket
FROM supports s
LEFT JOIN abonnements a ON a.id_support = s.id
LEFT JOIN tickets t ON t.id_support = s.id;

--Grâce à une requête SQL, dans une colonne nb_nvx_abo, retournez le nombre d'abonnements créés par mois, sur des supports qui n'en avaient pas avant, en 2024.
SELECT
    DATE_TRUNC('month', a.date_debut) AS mois,
    COUNT(a.id) AS nb_nvx_abo
FROM abonnements a
WHERE EXTRACT(year FROM a.date_debut) = 2024
AND NOT EXISTS (
    SELECT 1
    FROM abonnements a_prev
    WHERE a_prev.id_support = a.id_support
    AND EXTRACT(year FROM a_prev.date_debut) < 2024
)
GROUP BY mois
ORDER BY mois;

--Calculez le montant total économisé par les usagers ayant un abonnement comparé au prix qu'ils auraient
--dû payer en achetant des tickets pour chacuns de leurs voyages. Donnez un montant total en euros dans
--une colonne montant_economise_euros, ce dernier ne peut pas être négatif (il peut être égal à 0).
SELECT
    ROUND(SUM(
        GREATEST(
            (t.prix_unitaire_centimes * COUNT(t.id) * 1.0) - (a.id_tarification * COUNT(a.id) * 1.0),
            0
        ) / 100, 2
    ), 2) AS montant_economise_euros
FROM abonnements a
JOIN tickets t ON t.id_support = a.id_support
JOIN tarifications tar ON a.id_tarification = tar.id
WHERE a.date_debut <= NOW() AND a.date_fin >= NOW();

--Rédigez une vue permettant de connaître l'heure la plus affluante (celle où il y'a le plus de validations) pour
--chaque station. Affichez 2 colonnes nom_station, heure_affluante. Triez de la plus affluante à la moins affluante.
CREATE VIEW vue_heure_affluante AS
SELECT
    s.nom AS nom_station,
    TO_CHAR(v.date_heure_validation, 'HH24:MI') AS heure_affluante,
    COUNT(v.id) AS nb_validations
FROM validations v
JOIN stations s ON v.id_station = s.id
GROUP BY s.id, heure_affluante
ORDER BY nb_validations DESC;

--Rédigez une vue qui retourne dans 3 colonnes zone_min, zone_max, nb_abonnements, le nombre
--d'abonnements actifs par tranche de zone. Triez par nombre d'abonnements décroissants, puis par
--zone_min, puis par zone_max.
CREATE VIEW vue_nb_abonnements_par_tranche_zone AS
SELECT
    tar.zone_min,
    tar.zone_max,
    COUNT(a.id) AS nb_abonnements
FROM abonnements a
JOIN tarifications tar ON a.id_tarification = tar.id
WHERE a.date_debut <= NOW() AND a.date_fin >= NOW()  -- Abonnements actifs
GROUP BY tar.zone_min, tar.zone_max
ORDER BY nb_abonnements DESC, tar.zone_min, tar.zone_max;
