CREATE OR REPLACE FUNCTION affiche_pokemon_super_efficacite() RETURNS void
AS $$

  DECLARE
    myCursor CURSOR FOR
      SELECT P1.nom, P2.nom, efficacite.taux FROM efficacite
      -- INNER JOIN type AS T1
        -- ON T1.typ_id = efficacite.typ_id_1
      -- INNER JOIN type AS T2
        -- ON T2.typ_id = efficacite.typ_id_2
      INNER JOIN pokemon AS P1
        ON P1.type_id_1 = efficacite.type_id_1
      INNER JOIN pokemon AS P2
        ON P2.type_id_2 = efficacite.type_id_2
        ;

    pok_nom1 pokemon.pok_nom%TYPE;
    pok_nom2 pokemon.pok_nom%TYPE;
    efficacite efficacite.eff_taux%TYPE;

  BEGIN
    OPEN myCursor;

    LOOP
      FETCH myCursor INTO pok_nom1, pok_nom2, efficacite;
      RAISE DEBUG '(variables) pok_nom1 = % pok_nom2 = % efficacite = %', pok_nom1, pok_nom2, efficacite;
      EXIT WHEN NOT FOUND;

      IF efficacite > 1 THEN
        RAISE NOTICE '% est conseillé face à % : efficacité de %', pok_nom1, pok_nom2, efficacite;
      END IF;
    END LOOP;

    -- À ne pas oublier...
    CLOSE myCursor;
  END;

$$ language 'plpgsql'
