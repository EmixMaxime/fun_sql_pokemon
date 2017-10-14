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

    -- Ils vont s'affronterrrrrrr
    row_participant1 participant%ROW;
    row_participant2 participant%ROW;

    c_selectParticipant CURSOR FOR
      SELECT *
          FROM participant
          INNER JOIN participant ON participant.tournoi_id = tournoi.id
          WHERE participant.points = nb_round * 5;
          -- 5 = le nb de points gagnés lors d'un combat

  BEGIN
    nb_round := 0;

    LOOP
      -- Je sélectionne le joueur ayant le max de points
      SELECT MAX(participant.points) INTO v_max_pts
        FROM tournoi
        INNER JOIN participant ON participant.tournoi_id = tournoi.id
        WHERE tournoi.id = NEW.id;

      -- Je compte combien de joueurs ont le nombre de points maximum
      -- S'il n'y en a qu'un, c'est celui qui gagne.
      SELECT COUNT(participant.id) INTO v_players_max_pts
        FROM participant
        INNER JOIN participant ON participant.tournoi_id = tournoi.id
        WHERE participant.points = v_max_pts;

      -- On a le gagnant, on arrête le déroulement du tournoi
      IF v_players_max_pts == 1 THEN
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
        
      END LOOP;

    END LOOP;

  END;

$$ language 'plpgsql'