CREATE OR REPLACE VIEW dresseur_pokemon_info AS
  SELECT p.nom, p.id AS pokemon_id, d.pseudo, d.id AS dresseur_id
  FROM dresseur_pokemon AS dp
  INNER JOIN pokemon AS p
    ON p.id = dp.pokemon_id
  INNER JOIN dresseur AS d
    ON d.id = dp.dresseur_id
  ORDER BY dresseur_id
;