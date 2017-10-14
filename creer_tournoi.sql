CREATE OR REPLACE FUNCTION creer_tournoi(p_nom varchar, p_lieu varchar, p_date date, p_capacite int) RETURNS void
AS $$

  DECLARE
    v_date date;
    diff_days integer;
    diff_months integer;
    diff_years integer;

  BEGIN
    -- La date doit être dans le futur
    SELECT EXTRACT(DAY FROM age(v_date, NOW())) INTO diff_days;
    SELECT EXTRACT(MONTH FROM age(v_date, NOW())) INTO diff_months;
    SELECT EXTRACT(YEAR FROM age(v_date, NOW())) INTO diff_years;

    -- La date est passé
    IF diff_days < 0 OR diff_months < 0 OR diff_years < 0 THEN
      RAISE EXCEPTION 'La date est passé, veuillez fournir une date in the future';
    END IF;

    -- La capacité doit être de 4 || 8 || 16
    IF p_capacite != 4 AND p_capacite != 8 AND p_capacite != 16 THEN
      RAISE EXCEPTION 'La capacité doit être de 4 ou 8 ou 16 (regarde la doc !!).';
    END IF;

    INSERT INTO tournoi(nom, lieu, date, capacite) VALUES (
      p_nom, p_lieu, v_date, p_capacite
    );
  END;

$$ language 'plpgsql';