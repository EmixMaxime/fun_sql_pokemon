/**
 * Lorsqu'on modifie l'attribut "debut" (de 0 vers 1) sur la table tournoi, j'exécute cette fonction.
 */
CREATE OR REPLACE FUNCTION deroulement_tournoi()
RETURNS trigger

AS $$

  DECLARE
    -- Le nombre de points maximum (qu'un joueur a)
    v_max_pts integer;
    
    -- Le nombre de joueurs qui ont le maximum de points
    v_players_max_pts integer;

    -- Le nombre de "rounds", le nombre de déroulement du tournoi
    nb_round integer;

    -- Le pokemon qui gagne un combat
    v_pokemon_id_gg integer;

    -- l'id du tournoi en cours
    tournoi_id tournoi.id%TYPE;

    -- Ils vont s'affronterrrrrrr
    row_participant1 participant%ROWTYPE;
    row_participant2 participant%ROWTYPE;

    c_selectParticipant CURSOR(nb_round integer) FOR
      SELECT *
          FROM participant
          INNER JOIN tournoi
            ON participant.tournoi_id = tournoi.id
          WHERE participant.points = nb_round * 5
          AND tournoi.id = NEW.id;
          -- 5 = le nb de points gagnés lors d'un combat

  BEGIN
    nb_round := 0;
    tournoi_id := NEW.id;

    LOOP
      -- Je sélectionne le joueur ayant le max de points
      SELECT MAX(participant.points) INTO v_max_pts
        FROM participant
        INNER JOIN tournoi
          ON participant.tournoi_id = tournoi.id
        WHERE tournoi.id = NEW.id;

      RAISE NOTICE '% v_max_pts = ', v_max_pts;

      -- Je compte combien de joueurs ont le nombre de points maximum
      -- S'il n'y en a qu'un, c'est celui qui gagne.
      SELECT COUNT(*) INTO v_players_max_pts
        FROM participant
        INNER JOIN tournoi
        ON participant.tournoi_id = tournoi.id
        WHERE participant.points = v_max_pts
        AND tournoi.id = NEW.id;

      -- On a le gagnant, on arrête le déroulement du tournoi
      IF v_players_max_pts = 1 THEN
        EXIT;
      END IF;

      -- Do that with cursor and fetch !!
      OPEN c_selectParticipant(nb_round);
      LOOP

        FETCH c_selectParticipant INTO row_participant1;
        -- EXIT WHEN NOT FOUND;

        FETCH c_selectParticipant INTO row_participant2;
        EXIT WHEN NOT FOUND;

        -- récupérer le gagnant et lui attribuer les points
        SELECT combat(row_participant1.dresseur_pokemon_id, row_participant2.dresseur_pokemon_id) INTO v_pokemon_id_gg;

        UPDATE participant
          SET points = points + 5
          WHERE dresseur_pokemon_id = v_pokemon_id_gg
          AND tournoi_id = tournoi_id;

      END LOOP;

      nb_round := nb_round +1;

      IF nb_round > 50 THEN
        RAISE EXCEPTION 'ENDLESS LOOP';
      END IF;

    END LOOP;

  END;

$$ language 'plpgsql';