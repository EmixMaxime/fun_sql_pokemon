CREATE OR REPLACE FUNCTION affichage_combat(numero int, eff float, vie int) RETURNS void
AS $$

BEGIN
  RAISE NOTICE 'Le pokemon % attaque !',numero;
      IF eff > 1 THEN
        RAISE NOTICE 'C est super efficace';
      ELSE 
        IF eff < 1 THEN
          RAISE NOTICE 'Ce n est pas tres efficace';
        END IF;
      END IF;
      RAISE NOTICE 'Il reste % PV au pokemon %',vie,numero;
      
END;

$$ language 'plpgsql';
  