CREATE OR REPLACE FUNCTION demarrer_tournoi(p_nom varchar, p_lieu varchar)
RETURNS void
AS $$
  DECLARE
    d integer; -- get diagnostic
  BEGIN
    UPDATE tournoi
      SET en_cours = 1
      WHERE lower(nom) = lower(p_nom)
      AND lower(lieu) = lower(p_lieu)
    ;

    GET DIAGNOSTICS d = ROW_COUNT;
    -- Check if an update has been performed
    IF d < 1 THEN
      RAISE EXCEPTION 'Tournoi % in city % not found', p_nom, p_lieu;
    END IF;

  END;

$$ language 'plpgsql';