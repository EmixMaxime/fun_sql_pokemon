DROP TRIGGER IF EXISTS insert_efficacite_when_new_type ON type;

CREATE TRIGGER insert_efficacite_when_new_type AFTER INSERT
	ON type
	FOR EACH ROW EXECUTE PROCEDURE insert_efficacite_when_new_type();
