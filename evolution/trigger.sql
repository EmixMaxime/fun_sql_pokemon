DROP TRIGGER IF EXISTS evolution ON dresseur_pokemon;

CREATE TRIGGER evolution AFTER UPDATE
	ON dresseur_pokemon
	FOR EACH ROW EXECUTE PROCEDURE evolution();
