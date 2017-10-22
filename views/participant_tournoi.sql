CREATE OR REPLACE VIEW participant_tournoi AS
  SELECT *
    FROM participant AS p
    INNER JOIN tournoi AS t
    ON p.tournoi_id = t.id
  ;