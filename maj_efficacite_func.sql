-- Procédure qui ajoute l'efficacite pour 2 type données en varchar.
-- Ex : select maj_efficacite('feu', 'feu', 0.5);
CREATE OR REPLACE FUNCTION maj_efficacite (p_type_nom1 varchar, p_type_nom2 varchar, p_eff float)
RETURNS void
AS $$

  DECLARE
    selected_type_id1 type.id%TYPE;
    selected_type_id2 type.id%TYPE;

    typeCursor CURSOR FOR
      SELECT id FROM type
      WHERE lower(nom) = lower(p_type_nom1)
      OR lower(nom) = lower(p_type_nom2)
    ;

    -- typeCursor refcursor;
  BEGIN

    p_type_nom1 := lower(p_type_nom1);
    p_type_nom2 := lower(p_type_nom2);

    -- Récupération et vérifications des `type`s.
    OPEN typeCursor;

      FETCH typeCursor INTO selected_type_id1;
      IF NOT FOUND THEN
        RAISE EXCEPTION 'Type % not found.', p_type_nom1;
      END IF;

      IF p_type_nom1 = p_type_nom2 THEN
        selected_type_id2 := selected_type_id1;
      ELSE
        FETCH typeCursor INTO selected_type_id2;
        IF NOT FOUND THEN
          RAISE EXCEPTION 'Type % not found.', p_type_nom1;
        END IF;
      END IF;

    CLOSE typeCursor;

    -- Tout est ok, je peux update
    UPDATE efficacite SET taux = p_eff
      WHERE type_id_1 = selected_type_id1
      AND type_id_2 = selected_type_id2
    ;

  END;

$$ language 'plpgsql';