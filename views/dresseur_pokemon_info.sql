CREATE OR REPLACE VIEW dresseur_pokemon_info AS
  SELECT
    p.nom AS pokemon_nom, p.id AS pokemon_id,
    d.id AS dresseur_id, d.pseudo, d.nom AS dresseur_nom, d.prenom
  FROM dresseur_pokemon AS dp
  INNER JOIN pokemon AS p
    ON p.id = dp.pokemon_id
  INNER JOIN dresseur AS d
    ON d.id = dp.dresseur_id
  ORDER BY dresseur_id
;