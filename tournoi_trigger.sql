/**
 * Lorsque l'attribut "en_cours" de la table tournoi passe à 1 -> on trigger le deroulement_tournoi
 *
 * Source: http://www.the-art-of-web.com/sql/trigger-update-timestamp/
 * and https://stackoverflow.com/questions/25435669/fire-trigger-on-update-of-columna-or-columnb-or-columnc
 */

CREATE TRIGGER deroulement_tournoi_trigger
AFTER UPDATE ON tournoi
FOR EACH ROW
WHEN (NEW.en_cours = 1)
EXECUTE PROCEDURE deroulement_tournoi();