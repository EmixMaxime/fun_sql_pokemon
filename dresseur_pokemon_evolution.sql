CREATE OR REPLACE FUNCTION dresseur_pokemon_evolution(dresseur_pok_id integer)
RETURNS void
AS $$

DECLARE
  d integer; -- get diagnostic
BEGIN
  UPDATE dresseur_pokemon
    SET points_evolution = points_evolution + 1
    WHERE id = dresseur_pok_id
  ;

  GET DIAGNOSTICS d = ROW_COUNT;

  -- Check if an update has been performed
  IF d < 1 THEN
    RAISE EXCEPTION 'dresseur_pokemon id = % not found', dresseur_pok_id;
  END IF;

END;
$$ language 'plpgsql';