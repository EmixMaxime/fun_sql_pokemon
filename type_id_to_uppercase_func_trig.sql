/**
 * Fonction + trigger qui permet de mettre en majuscule les id d'efficacité
 */

CREATE OR REPLACE FUNCTION type_id_to_uppercase() RETURNS trigger
AS $$

  BEGIN

    NEW.id := upper(NEW.id);
    -- RAISE NOTICE 'new.typ_id = %', NEW.typ_id;
    RETURN NEW;  

  END;
$$ language 'plpgsql';

CREATE TRIGGER type_id_to_uppercase BEFORE INSERT OR UPDATE
	ON type
	FOR EACH ROW EXECUTE PROCEDURE type_id_to_uppercase();
