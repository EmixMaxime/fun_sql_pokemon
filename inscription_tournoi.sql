/**
 * Si l'utilisateur a plusieurs fois le même pokémon (avec le même nom)
 * je demande l'identifiant du pokémon (dresseur_pokémon)
 * -> je mets un paramètre optionnel pour l'id, si pas id je prend que le nom SI id je prend nom + id
 * si que nom et plusieurs pokémon -> EXCEPTION !
 */

CREATE OR REPLACE FUNCTION inscription_tournoi(p_pseudo varchar, p_nom_tournoi varchar, p_lieu_tournoi varchar, p_date_tournoi date, p_nom_pokemon varchar, p_id_pokemon integer DEFAULT 0)
RETURNS void
AS $$

  DECLARE
    v_dresseur dresseur%ROWTYPE;
    v_dresseur_id dresseur.id%TYPE;
    v_dresseur_pokemon_id dresseur_pokemon.pokemon_id%TYPE;
    v_tournoi_id tournoi.id%TYPE;
    v_pokemon_id pokemon.id%TYPE;

    -- Cb de pokémons portant le même nom le dresseur a-t-il ???
    v_dresseur_same_pokemon_name integer;
  BEGIN
    -- ingore casse
    p_pseudo := lower(p_pseudo);
    p_nom_pokemon := lower(p_nom_pokemon);
    p_lieu_tournoi := lower(p_lieu_tournoi);
    p_nom_tournoi := lower(p_nom_tournoi);

    -- récup du tournoi
    SELECT id INTO v_tournoi_id
      FROM tournoi
      WHERE lower(lieu) = p_lieu_tournoi
      AND lower(nom) = p_nom_tournoi
      AND date = p_date_tournoi
    ;

    IF v_tournoi_id IS NULL THEN
      RAISE EXCEPTION 'tournoi name % in % for % not found', p_nom_tournoi, p_lieu_tournoi, p_date_tournoi;
    END IF;

    -- on ne se base que sur le nom
    -- on fait donc qq vérifs
    IF p_id_pokemon = 0 THEN

      -- récup du dresseur et de ses pokémons
      SELECT dresseur_id, pokemon_id  INTO v_dresseur_id, v_dresseur_pokemon_id
        FROM dresseur_pokemon_info
        WHERE lower(pseudo) = p_pseudo
        AND lower(pokemon_nom) = p_nom_pokemon
      ;
      -- GET DIAGNOSTICS v_dresseur_same_pokemon_name = ROW_COUNT;

      -- J'ai bloqué sur du SQL basique, je n'avais plus le temps -> je fais deux requêtes
      -- J'ai pas comprit pourquoi le get diagnostics ne fonctionne pas *rage*.
      SELECT COUNT(*) INTO v_dresseur_same_pokemon_name
        FROM dresseur_pokemon_info
        WHERE lower(pseudo) = 'america'
        AND lower(pokemon_nom) = 'pikachu'
      ;

      RAISE NOTICE '% selected dresseur', v_dresseur_same_pokemon_name;

      IF v_dresseur_id IS NULL THEN
        RAISE EXCEPTION 'user % with pokemon % not found', p_pseudo, p_nom_pokemon;
      END IF;

      IF v_dresseur_same_pokemon_name > 1 THEN
        RAISE EXCEPTION 'The user % (%) has multiple %, please enter the id of the pokemon which will plays', p_pseudo, v_dresseur_id, p_nom_pokemon;
      END IF;

    -- on se base sur l'id du pokémon (de dresseur_pokemon)
    ELSE
      SELECT dresseur_id, pokemon_id  INTO v_dresseur_id, v_dresseur_pokemon_id
        FROM dresseur_pokemon_info
        WHERE lower(pseudo) = p_pseudo
        AND pokemon_id = p_id_pokemon
      ;

      IF v_dresseur_id IS NULL THEN
        RAISE EXCEPTION 'user % with pokemon name % and id % not found', p_pseudo, p_nom_pokemon, p_id_pokemon;
      END IF;

    END IF;

    -- Vérifications done, let's go !
    INSERT INTO participant
      (dresseur_id, tournoi_id, dresseur_pokemon_id)
      VALUES (
        v_dresseur_id,
        v_tournoi_id,
        v_dresseur_pokemon_id
      );

    RAISE NOTICE 'The user % (%) has been registered for the tournoi % in % at % with the pokemon id %', p_pseudo, v_dresseur_id, p_nom_tournoi, p_lieu_tournoi, p_date_tournoi, v_dresseur_pokemon_id;

  END;
$$ language 'plpgsql';