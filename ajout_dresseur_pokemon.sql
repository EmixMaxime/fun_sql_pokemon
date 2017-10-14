CREATE OR REPLACE FUNCTION ajout_dresseur_pokemon
  (p_pseudo varchar, p_pokemon_nom varchar, p_attaque int, p_vie int, p_defense int, p_vitesse int)
RETURNS void
AS $$

  DECLARE
    v_dresseur dresseur%ROWTYPE;

  BEGIN
    -- On récupère les infos du dresseur
    SELECT * INTO v_dresseur FROM dresseur WHERE pseudo = p_pseudo;

    IF NOT FOUND THEN
      RAISE EXCEPTION 'Le dresseur % est introuvable.', p_pseudo;
    END IF;

    -- On récupère les infos du pokémon
    SELECT * INTO v_pokemon FROM pokemon WHERE nom = p_pokemon_nom;


    IF NOT FOUND THEN
      RAISE EXCEPTION 'Le pokémon % est introuvable.', p_pokemon_nom;
    END IF;

    -- On ajoute le pokémon à son dresseur
    INSERT INTO dresseur_pokemon(
      attaque,
      vie,
      defense,
      vitesse,
      pokemon_id,
      dresseur_id
    ) VALUES (
      p_attaque,
      p_vie,
      p_defense,
      p_vitesse,
      v_pokemon.id,
      v_dresseur.id
    );

    RAISE NOTICE 'Félicitations ! Le dresseur % a désormais le pokémon % avec ces stats suivantes : % vie % defense % vitesse', v_dresseur.pseudo, v_pokemon.nom, p_vie, p_defense, p_vitesse;

  END;

$$ language 'plpgsql';