-- Procédure qui ajoute l'efficacite pour 2 type données en varchar.
-- Ex : select maj_efficacite('feu', 'feu', 0.5);
CREATE OR REPLACE FUNCTION maj_efficacite (p_type_nom1 varchar, p_type_nom2 varchar, p_eff float)
RETURNS void
AS $$

  DECLARE
    selected_type_id1 type.id%TYPE;
    selected_type_id2 type.id%TYPE;

    -- d integer; -- get diagnostic

  BEGIN

    -- On récupère les ID en fonction du nom
    SELECT id INTO selected_type_id1
      FROM type
      WHERE lower(nom) = lower(p_type_nom1)
    ; 
    -- lower -> upper serait plus judicieux, le `nom` étant déjà en uppercase.

    -- Si l'user me passe un nom de type qui n'existe pas, j'arrête !
    IF NOT FOUND THEN
      RAISE EXCEPTION 'Type % not found.', p_type_nom1;
    END IF;

    SELECT id INTO selected_type_id2
      FROM type
      WHERE lower(nom) = lower(p_type_nom2)
    ;

    IF NOT FOUND THEN
      RAISE EXCEPTION 'Type % not found.', p_type_nom2;
    END IF;

    -- Tout est ok, je peux update
    UPDATE efficacite SET taux = p_eff
      WHERE type_id_1 = selected_type_id1
      AND type_id_2 = selected_type_id2
    ;

    -- GET DIAGNOSTICS d = ROW_COUNT;
    -- RAISE NOTICE '% tuples modifiés', d;

  END;

$$ language 'plpgsql';