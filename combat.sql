CREATE OR REPLACE FUNCTION combat(p_dresseur_pok1 int, p_dresseur_pok2 int) RETURNS int
AS $$

DECLARE
  -- Variable temporaire de la vie des pokémon
  v_vie1 int;
  v_vie2 int;

  tour int; -- Eviter les parties interminables (ex: efficacité 0)
  numcombattant int;
  efficacite_pok1_sur_pok2 float;
  efficacite_pok2_sur_pok1 float;

  degat_pok1_sur_pok2 int;
  degat_pok2_sur_pok1 int; 
  
  gagnant int; 
  
  vdresseur_pok1 dresseur_pokemon%ROWTYPE;
  vdresseur_pok2 dresseur_pokemon%ROWTYPE;

  dresseurCursor CURSOR FOR
    SELECT * FROM dresseur_pokemon
    WHERE id = p_dresseur_pok1
    OR    id = p_dresseur_pok2
  ;

BEGIN

  -- Pokemon identique
  IF p_dresseur_pok1 = p_dresseur_pok2
    RAISE EXCEPTION 'Un Pokémon ne peut pas se battre contre lui-même voyons !';
  END IF;

  -- Récupération des dresseur_pokemon !
  OPEN dresseurCursor;
    FETCH dresseurCursor INTO vdresseur_pok1;
    FETCH dresseurCursor INTO vdresseur_pok2;
  CLOSE dresseurCursor;

  tour := 1;
 
  -- Assigne une efficacite d'un pokémon sur l'autre
  SELECT select_pok_efficacite(vdresseur_pok1.pokemon_id, vdresseur_pok2.pokemon_id) INTO efficacite_pok1_sur_pok2;

  SELECT select_pok_efficacite(vdresseur_pok2.pokemon_id, vdresseur_pok1.pokemon_id) INTO efficacite_pok2_sur_pok1;

  -- Détermine les dégâts d'un pokemon sur un autre
	degat_pok1_sur_pok2 = vdresseur_pok1.attaque * efficacite_pok1_sur_pok2 - vdresseur_pok2.defense;
	degat_pok2_sur_pok1 = vdresseur_pok2.attaque * efficacite_pok2_sur_pok1 - vdresseur_pok1.defense;
    

	IF degat_pok1_sur_pok2 <= 0 THEN
		degat_pok1_sur_pok2 = 1;
	END IF;

	IF degat_pok2_sur_pok1 <= 0 THEN
		degat_pok2_sur_pok1 = 1;
	END IF;

  -- Fixer la vie du pokémon dans une variable
	v_vie1 := vdresseur_pok1.vie;
	v_vie2 := vdresseur_pok2.vie;
  RAISE NOTICE 'Le pokemon 1 a % PV et le pokemon 2 a % PV',v_vie1, v_vie2;

  -- Début du combat !!! 
  WHILE tour != 51 AND v_vie1 > 0 AND v_vie2 > 0 LOOP

    -- perform pg_sleep(2);

    -- Vérifie le pokémon attaquant en premier et effectue son attaque
    IF vdresseur_pok1.vitesse > vdresseur_pok2.vitesse THEN
      -- Inflige des dommages à la vie adverse
      v_vie2 := v_vie2 - degat_pok1_sur_pok2;
    ELSE 
      v_vie1 := v_vie1 - degat_pok2_sur_pok1;
    END IF;

    -- Le second pokémon attaque s'il a encore de la vie
    IF vdresseur_pok1.vitesse > vdresseur_pok2.vitesse AND v_vie2 > 0 THEN
      -- Inflige des dommages à la vie adverse
      v_vie1 := v_vie1 - degat_pok2_sur_pok1;
    ELSE 
      IF vdresseur_pok2.vitesse > vdresseur_pok1.vitesse AND v_vie1 > 0 THEN
        v_vie2 := v_vie2 - degat_pok1_sur_pok2;          
      END IF;
    END IF;

    RAISE NOTICE 'Fin du tour %', tour;

    -- Passe au tour suivant
    tour := tour + 1;
      
    IF tour > 90 THEN
      RAISE EXCEPTION 'ENDLESS LOOP';
    END IF;

  END LOOP;

  -- Déterminer gagnant après le temps limite où à la mort d'un pokémon
  IF v_vie1 > v_vie2 THEN
    numcombattant := 1;
    gagnant := p_dresseur_pok1;

    PERFORM dresseur_pokemon_evolution(p_dresseur_pok1);
  ELSE
    numcombattant := 2; 
    gagnant := p_dresseur_pok2;

    PERFORM dresseur_pokemon_evolution(p_dresseur_pok2);
  END IF;

  -- Retourne le gagnant
  raise notice 'Le gagnant est le pokemon % : Numéro %', numcombattant, gagnant;
  RETURN gagnant;

END;
$$ language 'plpgsql';
