/**
 * Lorsque l'attribut "en_cours" de la table tournoi passe à 1 -> on trigger le deroulement_tournoi
 */

CREATE TRIGGER deroulement_tournoi_trigger
AFTER UPDATE ON tournoi
FOR EACH ROW
WHEN (NEW.en_cours = 1)
EXECUTE PROCEDURE deroulement_tournoi();