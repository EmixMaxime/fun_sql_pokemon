/*
 * Couple trigger/function qui rempli la table efficacité lorsqu'un nouveau type 
 * est ajouté.
 * Le taux d'efficacité contre tous les types est fixé à 1 par défaut.
 * Lorsqu'on souhaite modifier cette efficacité, nous avons la fonction 
 * maj_efficacite pour nous simplifier la vie.
*/

CREATE OR REPLACE FUNCTION insert_efficacite_when_new_type() RETURNS trigger
AS $$

  DECLARE
    current_id type.id%TYPE;
    futur_type_id type.id%TYPE;

    myCursor CURSOR FOR SELECT id FROM type;

  BEGIN
    -- Rappel : trigger (before) sur la table type
    current_id := NEW.id;


    OPEN myCursor;

    -- je boucle sur tous les types Y COMPRIT CELUI QU'ON INSÈRE et j'ajoute l'efficacité à 1 contre celui-ci
    LOOP
      FETCH myCursor INTO futur_type_id;
      EXIT WHEN NOT FOUND;
 
      INSERT INTO efficacite(type_id_1, type_id_2, taux) VALUES (
        current_id,
        futur_type_id,
        1.0
      );

    END LOOP;

    CLOSE myCursor;

    RETURN NEW; 

  END;
$$ language 'plpgsql';
