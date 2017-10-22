CREATE OR REPLACE FUNCTION affiche_type_super_efficacite() RETURNS void
AS $$

  DECLARE
    myCursor CURSOR FOR
      SELECT T1.nom, T2.nom, efficacite.taux FROM efficacite
      INNER JOIN type AS T1
        ON T1.id = efficacite.type_id_1
      INNER JOIN type AS T2
        ON T2.id = efficacite.type_id_2;

    type_nom1 type.nom%TYPE;
    type_nom2 type.nom%TYPE;
    efficacite efficacite.taux%TYPE;

  BEGIN
    OPEN myCursor;

    LOOP
      FETCH myCursor INTO type_nom1, type_nom2, efficacite;
      EXIT WHEN NOT FOUND;

      IF efficacite > 1 THEN
        RAISE NOTICE 'Les pokémons de type % sont conseillés face aux pokémons de type % : efficacité de %', type_nom1, type_nom2, efficacite;
      END IF;
    END LOOP;

    CLOSE myCursor;

  END;

$$ language 'plpgsql';
