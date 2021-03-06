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

    -- Détermine si c'est la finale
    final integer;

    -- Le pokemon qui gagne un combat
    v_pokemon_id_gg integer;

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
    final := 0;
    nb_round := 0;

    OPEN c_selectParticipant(nb_round);

    LOOP
      -- Je sélectionne le joueur ayant le max de points
      SELECT MAX(participant.points) INTO v_max_pts
        FROM participant
        INNER JOIN tournoi
          ON participant.tournoi_id = tournoi.id
        WHERE tournoi.id = NEW.id;
      
      
      RAISE NOTICE '% v_max_pts = ', v_max_pts;

      IF nb_round % 2 = 0 THEN
        RAISE NOTICE 'nb_round = % cursor refreshed.', nb_round;
        CLOSE c_selectParticipant;
        OPEN c_selectParticipant(nb_round);

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
      END IF;


      -- récupération des participants qui vont combattre l'un contre l'autre.
      FETCH c_selectParticipant INTO row_participant1;
      FETCH c_selectParticipant INTO row_participant2;

      -- pour fixer l'histoire du curseur qui ne VEUT PAS SE REDÉFINIR !!!!!!!!!!!!
      EXIT WHEN NOT FOUND;

      -- récupérer le gagnant et lui attribuer les points
      SELECT combat(row_participant1.dresseur_pokemon_id, row_participant2.dresseur_pokemon_id) INTO v_pokemon_id_gg;

      UPDATE participant
        SET points = points + 5
        WHERE dresseur_pokemon_id = v_pokemon_id_gg
        AND tournoi_id = NEW.id;

      nb_round := nb_round +1;

      IF nb_round > 50 THEN
        RAISE EXCEPTION 'ENDLESS LOOP';
      END IF;

    END LOOP;

    -- CLOSE c_selectParticipant;
    
    RETURN NEW;

  END;

$$ language 'plpgsql';