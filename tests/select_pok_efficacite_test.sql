-- Just to have fun with multiple cursors
CREATE OR REPLACE FUNCTION select_pok_efficacite_test() RETURNS void
AS $$
DECLARE
  pokemonCursor1 CURSOR FOR SELECT * FROM pokemon;
  pokemonCursor2 CURSOR FOR SELECT * FROM pokemon;

  pokemon1 pokemon%ROWTYPE;
  pokemon2 pokemon%ROWTYPE;

  result efficacite.taux%TYPE;
  expected_result efficacite.taux%TYPE;

  i integer;
BEGIN

  i := 0;

  OPEN pokemonCursor1;
  OPEN pokemonCursor2;
  -- For each pokemon, check if select_pok_efficacite returns the proper response
  LOOP
    FETCH pokemonCursor1 INTO pokemon1;
    EXIT WHEN NOT FOUND;
    
    LOOP
      i := i +1;
      FETCH pokemonCursor2 INTO pokemon2;
      EXIT WHEN NOT FOUND;

      SELECT select_pok_efficacite(pokemon1.id, pokemon2.id) 
        INTO result;
  
      SELECT taux INTO expected_result
      FROM efficacite
        INNER JOIN pokemon AS P
          ON
            P.type_id_1 = pokemon1.type_id_1
            AND
            P.type_id_2 = pokemon2.type_id_2
      ;

      IF expected_result != result THEN
        RAISE EXCEPTION 'laul';
      END IF;

    END LOOP;
  END LOOP;

  RAISE NOTICE '% combinaison tested. Everything is fine ! Congrats', i;

  CLOSE pokemonCursor1;
  CLOSE pokemonCursor2;
END;
$$ language 'plpgsql';