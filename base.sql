/* 
Fichier à ajouter dans la base pour faire la création des tables, l'insertion des tables, la création des fonctions et triggers.
Aucune autre action ne sera nécessaire pour créer la base de données.
*/

DROP TABLE IF EXISTS type CASCADE;
DROP TABLE IF EXISTS efficacite CASCADE;
DROP TABLE IF EXISTS pokemon CASCADE;
DROP TABLE IF EXISTS dresseur CASCADE;
DROP TABLE IF EXISTS dresseur_pokemon CASCADE;
DROP TABLE IF EXISTS participant CASCADE;

CREATE TABLE type (
  id varchar(3) PRIMARY KEY,
  nom varchar(30) NOT NULL UNIQUE
);

CREATE TABLE efficacite (
  -- efficacité du type 1 sur le type 2
  type_id_1 varchar(3) NOT NULL REFERENCES type(id),
  type_id_2 varchar(3) NOT NULL REFERENCES type(id),
  taux float NOT NULL
);

CREATE TABLE pokemon (
  id serial PRIMARY KEY,
  nom varchar(30) NOT NULL,
  poids float,
  taille float,
  evolution integer REFERENCES pokemon(id),

  -- Un pokémon DOIT avoir un type mais peut en avoir deux.
  type_id_1 varchar(3) NOT NULL REFERENCES type(id),
  type_id_2 varchar(3) REFERENCES type(id)
);

CREATE TABLE dresseur(
  id serial PRIMARY KEY,
  nom varchar(100) NOT NULL,
  prenom varchar(100) NOT NULL,
  pseudo varchar(100) NOT NULL UNIQUE
);

-- Un dresseur a X pokemon
-- dresseur hasMany pokemon
-- pokemon hasOne dresseur
CREATE TABLE dresseur_pokemon(
  id serial PRIMARY KEY,
  attaque int NOT NULL,
  vie int NOT NULL,
  defense int NOT NULL,
  vitesse int NOT NULL,
  points_evolution int DEFAULT 0,

  pokemon_id int NOT NULL REFERENCES pokemon(id),
  dresseur_id int NOT NULL REFERENCES dresseur(id)
);

DROP TABLE IF EXISTS tournoi CASCADE;
CREATE TABLE tournoi(
  id serial PRIMARY KEY,
  nom varchar(100) NOT NULL,
  lieu varchar(100) NOT NULL,
  capacite int DEFAULT 4,
  date date NOT NULL,
  en_cours int DEFAULT 0,
  termine int DEFAULT 0,

  -- un tournoi peut être mensuel dans différentes villes.
  UNIQUE(nom, lieu, date)
);

CREATE TABLE participant(
  id serial PRIMARY KEY,
  points int default 0,

  dresseur_id int NOT NULL REFERENCES dresseur(id),
  tournoi_id int NOT NULL REFERENCES tournoi(id),

  -- avec quel pokémon le joueur va faire le tournoi ?
  dresseur_pokemon_id int NOT NULL REFERENCES dresseur_pokemon(id),

  UNIQUE(dresseur_id, tournoi_id)
);


-- Procédure qui ajoute l'efficacite pour 2 type données en varchar.
-- Ex : select maj_efficacite('feu', 'feu', 0.5);
CREATE OR REPLACE FUNCTION maj_efficacite (p_type_nom1 varchar, p_type_nom2 varchar, p_eff float)
RETURNS void
AS $$

  DECLARE
    selected_type_id1 type.id%TYPE;
    selected_type_id2 type.id%TYPE;

    typeCursor CURSOR FOR
      SELECT id FROM type
      WHERE lower(nom) = lower(p_type_nom1)
      OR lower(nom) = lower(p_type_nom2)
    ;

    -- typeCursor refcursor;
  BEGIN

    p_type_nom1 := lower(p_type_nom1);
    p_type_nom2 := lower(p_type_nom2);

    -- Récupération et vérifications des `type`s.
    OPEN typeCursor;

      FETCH typeCursor INTO selected_type_id1;
      IF NOT FOUND THEN
        RAISE EXCEPTION 'Type % not found.', p_type_nom1;
      END IF;

      IF p_type_nom1 = p_type_nom2 THEN
        selected_type_id2 := selected_type_id1;
      ELSE
        FETCH typeCursor INTO selected_type_id2;
        IF NOT FOUND THEN
          RAISE EXCEPTION 'Type % not found.', p_type_nom1;
        END IF;
      END IF;

    CLOSE typeCursor;

    -- Tout est ok, je peux update
    UPDATE efficacite SET taux = p_eff
      WHERE type_id_1 = selected_type_id1
      AND type_id_2 = selected_type_id2
    ;

  END;

$$ language 'plpgsql';



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


CREATE OR REPLACE FUNCTION select_pok_efficacite(pokemon_id1 int, pokemon_id2 int) RETURNS TABLE(taux float)
AS $$
BEGIN
  RETURN QUERY
    SELECT efficacite.taux
    FROM efficacite
    WHERE efficacite.type_id_1 = 
      (
        SELECT pokemon.type_id_1 
          FROM pokemon
          WHERE pokemon.id = pokemon_id1
      )
    AND efficacite.type_id_2 = 
      (
        SELECT pokemon.type_id_1
        FROM pokemon
        WHERE pokemon.id = pokemon_id2
      );
END;
$$ language 'plpgsql';


CREATE OR REPLACE FUNCTION affiche_type_super_efficacite() RETURNS void
AS $$

  DECLARE
    myCursor CURSOR FOR
      SELECT T1.nom, T2.nom, efficacite.taux FROM efficacite
      INNER JOIN type AS T1
        ON T1.id = efficacite.type_id_1
      INNER JOIN type AS T2
        ON T2.id = efficacite.type_id_2;

    type_nom1 type.nom%TYPE;
    type_nom2 type.nom%TYPE;
    efficacite efficacite.taux%TYPE;

  BEGIN
    OPEN myCursor;

    LOOP
      FETCH myCursor INTO type_nom1, type_nom2, efficacite;
      EXIT WHEN NOT FOUND;

      IF efficacite > 1 THEN
        RAISE NOTICE 'Les pokémons de type % sont conseillés face aux pokémons de type % : efficacité de %', type_nom1, type_nom2, efficacite;
      END IF;
    END LOOP;

    CLOSE myCursor;

  END;

$$ language 'plpgsql';



/*
	Fonction qui va permettre d'assigner une evolution à un pokemon
	p_pokemon_base est l'id du pokemon qu'on veut faire évoluer
	p_pokemon_evolution est l'id du pokemon qu'il doit devenir
*/

create or replace function maj_evolution(p_pokemon_base int, p_pokemon_evolution int)
returns void
as $$
begin
	update pokemon
	set evolution = p_pokemon_evolution
	where pokemon.id = p_pokemon_base;
end;
$$ language 'plpgsql';




CREATE OR REPLACE FUNCTION select_pok_efficacite(pokemon_id1 int, pokemon_id2 int) RETURNS TABLE(taux float)
AS $$
BEGIN
  RETURN QUERY
    SELECT efficacite.taux
    FROM efficacite
    WHERE efficacite.type_id_1 = 
      (
        SELECT pokemon.type_id_1 
          FROM pokemon
          WHERE pokemon.id = pokemon_id1
      )
    AND efficacite.type_id_2 = 
      (
        SELECT pokemon.type_id_1
        FROM pokemon
        WHERE pokemon.id = pokemon_id2
      );
END;
$$ language 'plpgsql';


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



DROP TRIGGER IF EXISTS insert_efficacite_when_new_type ON type;

CREATE TRIGGER insert_efficacite_when_new_type AFTER INSERT
	ON type
	FOR EACH ROW EXECUTE PROCEDURE insert_efficacite_when_new_type();


-- Insertion des types
INSERT INTO type VALUES
  ('nor','Normal'),
  ('com','Combat'),
  ('vol','Vol'),
  ('POi','Poison'),
  ('SOl','Sol'),
  ('roC','Roche'),
  ('InS','Insecte'),
  ('spe','Spectre'),
  ('ACI','Acier'),
  ('PLa','Plante'),
  ('FEu','Feu'),
  ('eAU','Eau'),
  ('ElE','Electrique'),
  ('PSY','Psy'),
  ('GLA','Glace'),
  ('DRA','Dragon'),
  ('TEN','Ténèbres'),
  ('FEE','Fée')
;


-- Insertion dresseurs
INSERT INTO dresseur (prenom, nom, pseudo) VALUES
  ('Dany', 'Capitain', 'America'),
  ('Remi', 'Synave', 'Grenouille'),
  ('Marguerite', 'Fernandez', 'Peu chère'),
  ('Anne', 'Pacou', 'Passpacou'),
  ('Severine', 'Letrez', 'Comptabilitey'),
  ('Bruno', 'Warin', 'James Dany Boonde'),
  ('Francois', 'Rousselle', 'Assembleur is bae'),
  ('Dominique', 'Dussart', 'Triggered'),
  ('Maxime', 'Moreau', 'mx')
;


select maj_efficacite('combat','normal',2);
select maj_efficacite('spectre','normal',0);
select maj_efficacite('feu','feu',0.5);
select maj_efficacite('eau','feu',2);
select maj_efficacite('plante','feu',0.5);
select maj_efficacite('glace','feu',0.5);
select maj_efficacite('sol','feu',2);
select maj_efficacite('insecte','feu',0.5);
select maj_efficacite('roche','feu',2);
select maj_efficacite('acier','feu',0.5);
select maj_efficacite('fée','feu',0.5);
select maj_efficacite('feu','eau',0.5);
select maj_efficacite('eau','eau',0.5);
select maj_efficacite('plante','eau',2);
select maj_efficacite('electrique','eau',2);
select maj_efficacite('glace','eau',0.5);
select maj_efficacite('acier','eau',0.5);
select maj_efficacite('feu','plante',2);
select maj_efficacite('eau','plante',0.5);
select maj_efficacite('plante','plante',0.5);
select maj_efficacite('electrique','plante',0.5);
select maj_efficacite('glace','plante',2);
select maj_efficacite('poison','plante',2);
select maj_efficacite('sol','plante',0.5);
select maj_efficacite('vol','plante',2);
select maj_efficacite('insecte','plante',2);
select maj_efficacite('electrique','electrique',0.5);
select maj_efficacite('sol','electrique',2);
select maj_efficacite('vol','electrique',0.5);
select maj_efficacite('acier','electrique',0.5);
select maj_efficacite('feu','glace',2);
select maj_efficacite('glace','glace',0.5);
select maj_efficacite('combat','glace',2);
select maj_efficacite('roche','glace',2);
select maj_efficacite('acier','glace',2);
select maj_efficacite('vol','combat',2);
select maj_efficacite('psy','combat',2);
select maj_efficacite('insecte','combat',0.5);
select maj_efficacite('roche','combat',0.5);
select maj_efficacite('ténèbres','combat',0.5);
select maj_efficacite('fée','combat',2);
select maj_efficacite('plante','poison',0.5);
select maj_efficacite('combat','poison',0.5);
select maj_efficacite('poison','poison',0.5);
select maj_efficacite('sol','poison',2);
select maj_efficacite('psy','poison',2);
select maj_efficacite('insecte','poison',0.5);
select maj_efficacite('fée','poison',0.5);
select maj_efficacite('eau','sol',2);
select maj_efficacite('plante','sol',2);
select maj_efficacite('electrique','sol',0);
select maj_efficacite('glace','sol',2);
select maj_efficacite('poison','sol',0.5);
select maj_efficacite('roche','sol',0.5);
select maj_efficacite('plante','vol',0.5);
select maj_efficacite('electrique','vol',2);
select maj_efficacite('glace','vol',2);
select maj_efficacite('combat','vol',0.5);
select maj_efficacite('sol','vol',0);
select maj_efficacite('insecte','vol',0.5);
select maj_efficacite('roche','vol',2);
select maj_efficacite('combat','psy',0.5);
select maj_efficacite('psy','psy',0.5);
select maj_efficacite('insecte','psy',2);
select maj_efficacite('spectre','psy',2);
select maj_efficacite('ténèbres','psy',2);
select maj_efficacite('feu','insecte',2);
select maj_efficacite('plante','insecte',0.5);
select maj_efficacite('combat','insecte',0.5);
select maj_efficacite('sol','insecte',0.5);
select maj_efficacite('vol','insecte',2);
select maj_efficacite('roche','insecte',2);
select maj_efficacite('normal','roche',0.5);
select maj_efficacite('feu','roche',0.5);
select maj_efficacite('eau','roche',2);
select maj_efficacite('plante','roche',2);
select maj_efficacite('combat','roche',2);
select maj_efficacite('poison','roche',0.5);
select maj_efficacite('sol','roche',2);
select maj_efficacite('vol','roche',0.5);
select maj_efficacite('acier','roche',2);
select maj_efficacite('normal','spectre',0);
select maj_efficacite('combat','spectre',0);
select maj_efficacite('poison','spectre',0.5);
select maj_efficacite('insecte','spectre',0.5);
select maj_efficacite('spectre','spectre',2);
select maj_efficacite('ténèbres','spectre',2);
select maj_efficacite('feu','dragon',0.5);
select maj_efficacite('eau','dragon',0.5);
select maj_efficacite('plante','dragon',0.5);
select maj_efficacite('electrique','dragon',0.5);
select maj_efficacite('glace','dragon',2);
select maj_efficacite('dragon','dragon',2);
select maj_efficacite('fée','dragon',2);
select maj_efficacite('combat','ténèbres',2);
select maj_efficacite('psy','ténèbres',0);
select maj_efficacite('insecte','ténèbres',2);
select maj_efficacite('spectre','ténèbres',0.5);
select maj_efficacite('ténèbres','ténèbres',0.5);
select maj_efficacite('fée','ténèbres',2);
select maj_efficacite('normal','acier',0.5);
select maj_efficacite('feu','acier',2);
select maj_efficacite('plante','acier',0.5);
select maj_efficacite('glace','acier',0.5);
select maj_efficacite('combat','acier',2);
select maj_efficacite('poison','acier',0);
select maj_efficacite('sol','acier',2);
select maj_efficacite('vol','acier',0.5);
select maj_efficacite('psy','acier',0.5);
select maj_efficacite('insecte','acier',0.5);
select maj_efficacite('roche','acier',0.5);
select maj_efficacite('dragon','acier',0.5);
select maj_efficacite('acier','acier',0.5);
select maj_efficacite('fée','acier',0.5);
select maj_efficacite('combat','fée',0.5);
select maj_efficacite('poison','fée',2);
select maj_efficacite('insecte','fée',0.5);
select maj_efficacite('dragon','fée',0);
select maj_efficacite('ténèbres','fée',0.5);
select maj_efficacite('acier','fée',2);



-- Ajouter au préalable la fonction maj_evolution

-- Insérer les pokemon dans la base de données

INSERT INTO pokemon (nom,type_id_1) VALUES 
('Bulbizarre','PLA'),
('Herbizarre','PLA'),
('Florizarre','PLA'),
('Salamèche','FEU'),
('Reptincel','FEU'),
('Dracaufeu','FEU'),
('Carapuce','EAU'),
('Carabaffe','EAU'),
('Tortank','EAU'),
('Chenipan','INS'),
('Chrysacier','INS'),
('Papilusion','INS'),
('Aspicot','INS'),
('Coconfort','INS'),
('Dardargnan','INS'),
('Roucool','VOL'),
('Roucoups','VOL'),
('Roucarnage','VOL'),
('Ratata','NOR'),
('Piafebec','VOL'),
('Rapasdepic','VOL'),
('Abo','POI'),
('Arbok','POI'),
('Pikachu','ELE'),
('Raichu','ELE'),
('Sabelette','SOL'),
('Sablaireau','SOL'),
('Nidoran F','POI'),
('Nidorina','POI'),
('Nidoqueen','POI'),
('Nidoran M','POI'),
('Nidorino','POI'),
('Nidoking','POI'),
('Mélofée','FEE'),
('Mélodelfe','FEE'),
('Goupix','FEU'),
('Feunard','FEU'),
('Rondoudou','NOR'),
('Grodoudou','NOR'),
('Nosferapti','POI'),
('Nosferalto','POI'),
('Mystherbe','PLA'),
('Ortide','PLA'),
('Rafflesia','PLA'),
('Paras','INS'),
('Parasect','INS'),
('Mimitoss','INS'),
('Aéromite','INS'),
('Taupiqueur','SOL'),
('Triopikeur','SOL');

-- Paramétrer les évolution des pokemon

SELECT maj_evolution(1,2);
SELECT maj_evolution(2,3);
SELECT maj_evolution(4,5);
SELECT maj_evolution(5,6);
SELECT maj_evolution(7,8);
SELECT maj_evolution(8,9);
SELECT maj_evolution(10,11);
SELECT maj_evolution(11,12);
SELECT maj_evolution(13,14);
SELECT maj_evolution(14,15);
SELECT maj_evolution(16,17);
SELECT maj_evolution(17,18);
SELECT maj_evolution(19,20);
SELECT maj_evolution(21,22);
SELECT maj_evolution(23,24);
SELECT maj_evolution(25,26);
SELECT maj_evolution(27,28);
SELECT maj_evolution(29,30);
SELECT maj_evolution(30,31);
SELECT maj_evolution(32,33);
SELECT maj_evolution(33,34);
SELECT maj_evolution(35,36);
SELECT maj_evolution(37,38);
SELECT maj_evolution(39,40);
SELECT maj_evolution(41,42);
SELECT maj_evolution(43,44);
SELECT maj_evolution(44,45);
SELECT maj_evolution(46,47);
SELECT maj_evolution(48,49);
SELECT maj_evolution(50,51);

-- Insertion pokemons des dresseurs 
INSERT INTO dresseur_pokemon(
  attaque, defense, vitesse, vie, pokemon_id, dresseur_id
  ) VALUES (
    50, 50, 60, 150, 1, 1
  );

INSERT INTO dresseur_pokemon(
  attaque, defense, vitesse, vie, pokemon_id, dresseur_id
  ) VALUES (
    40, 50, 90, 150, 4, 2
  );

INSERT INTO dresseur_pokemon(
  attaque, defense, vitesse, vie, pokemon_id, dresseur_id
  ) VALUES (
    100, 10, 10, 170, 7, 3);
    
INSERT INTO dresseur_pokemon(
  attaque, defense, vitesse, vie, pokemon_id, dresseur_id
  ) VALUES (
    60, 40, 15, 170, 10, 4);
    
INSERT INTO dresseur_pokemon(
  attaque, defense, vitesse, vie, pokemon_id, dresseur_id
  ) VALUES (
    50, 60, 10, 170, 13, 5);
    
INSERT INTO dresseur_pokemon(
  attaque, defense, vitesse, vie, pokemon_id, dresseur_id
  ) VALUES (
    50, 50, 100, 170, 17, 6);
    
INSERT INTO dresseur_pokemon(
  attaque, defense, vitesse, vie, pokemon_id, dresseur_id
  ) VALUES (
    40, 90, 30, 170, 25, 7);
    
INSERT INTO dresseur_pokemon(
  attaque, defense, vitesse, vie, pokemon_id, dresseur_id
  ) VALUES (
    80, 30, 100, 170, 37, 8);
    

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

BEGIN

  -- Pokemon identique
  IF p_dresseur_pok1 = p_dresseur_pok2 THEN
    RAISE EXCEPTION 'Un Pokemon ne peut pas se battre contre lui-meme voyons !';
  END IF;

  -- Assigner les variables ROWTYPE
	SELECT id,attaque,vie,defense,vitesse,points_evolution,pokemon_id,dresseur_id INTO vdresseur_pok1 
	FROM dresseur_pokemon
	WHERE id=p_dresseur_pok1;

	SELECT id,attaque,vie,defense,vitesse,points_evolution,pokemon_id,dresseur_id INTO vdresseur_pok2 
	FROM dresseur_pokemon
	WHERE id=p_dresseur_pok2;

  tour := 1;
 
  -- Assigne une efficacite d'un pokémon sur l'autre
  SELECT select_pok_efficacite(vdresseur_pok1.pokemon_id, vdresseur_pok2.pokemon_id) INTO efficacite_pok1_sur_pok2;

  SELECT select_pok_efficacite(vdresseur_pok2.pokemon_id, vdresseur_pok1.pokemon_id) INTO efficacite_pok2_sur_pok1;

  -- Détermine les dégâts d'un pokemon sur un autre
	degat_pok1_sur_pok2 = vdresseur_pok1.attaque * efficacite_pok1_sur_pok2 - vdresseur_pok2.defense;
	degat_pok2_sur_pok1 = vdresseur_pok2.attaque * efficacite_pok2_sur_pok1 - vdresseur_pok1.defense;
    

  -- Gestion du cas où il n'y a pas de degat, le degat est donc initialisé à 1.
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

    perform pg_sleep(2);

    -- Vérifie le pokémon attaquant en premier et effectue son attaque
    IF vdresseur_pok1.vitesse >= vdresseur_pok2.vitesse THEN
      -- Inflige des dommages à la vie adverse
      v_vie2 := v_vie2 - degat_pok1_sur_pok2;
      
      -- Affichage stylé
      RAISE NOTICE 'Le pokemon 1 attaque !';
      IF efficacite_pok1_sur_pok2 > 1 THEN
        RAISE NOTICE 'C est super efficace';
      ELSE 
        IF efficacite_pok1_sur_pok2 < 1 THEN
          RAISE NOTICE 'Ce n est pas tres efficace';
        END IF;
      END IF;
      RAISE NOTICE 'Il reste % PV au pokemon 2',v_vie2;
      
    ELSE 
      v_vie1 := v_vie1 - degat_pok2_sur_pok1;
      
      -- Affichage stylé
      RAISE NOTICE 'Le pokemon 2 attaque !';
      IF efficacite_pok2_sur_pok1 > 1 THEN
        RAISE NOTICE 'C est super efficace';
      ELSE 
        IF efficacite_pok2_sur_pok1 < 1 THEN
          RAISE NOTICE 'Ce n est pas tres efficace';
        END IF;
      END IF;
      RAISE NOTICE 'Il reste % PV au pokemon 1',v_vie1;
      
    END IF;

    -- Le second pokémon attaque s'il a encore de la vie
    IF vdresseur_pok1.vitesse >= vdresseur_pok2.vitesse AND v_vie2 > 0 THEN
      -- Inflige des dommages à la vie adverse
      v_vie1 := v_vie1 - degat_pok2_sur_pok1;
      
      -- Affichage stylé
      RAISE NOTICE 'Le pokemon 2 attaque !';
      IF efficacite_pok2_sur_pok1 > 1 THEN
        RAISE NOTICE 'C est super efficace';
      ELSE 
        IF efficacite_pok2_sur_pok1 < 1 THEN
          RAISE NOTICE 'Ce n est pas tres efficace';
        END IF;
      END IF;
      RAISE NOTICE 'Il reste % PV au pokemon 1',v_vie1;
      
    ELSE 
      IF vdresseur_pok2.vitesse > vdresseur_pok1.vitesse AND v_vie1 > 0 THEN
        v_vie2 := v_vie2 - degat_pok1_sur_pok2; 
        
          -- Affichage stylé
        RAISE NOTICE 'Le pokemon 1 attaque !';
        IF efficacite_pok1_sur_pok2 > 1 then
          RAISE NOTICE 'C est super efficace';
        ELSE 
          IF efficacite_pok1_sur_pok2 < 1 then
            RAISE NOTICE 'Ce n est pas tres efficace';
          END IF;
        END IF;
        RAISE NOTICE 'Il reste % PV au pokemon 2',v_vie2;
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
  raise notice 'Le gagnant est le pokemon % : Numero %', numcombattant, gagnant;
  RETURN gagnant;

END;
$$ language 'plpgsql';


CREATE OR REPLACE FUNCTION ajout_dresseur_pokemon
  (p_pseudo varchar, p_pokemon_nom varchar, p_attaque int, p_vie int, p_defense int, p_vitesse int)
RETURNS void
AS $$

  DECLARE
    v_dresseur dresseur%ROWTYPE;
    v_pokemon pokemon%ROWTYPE;

  BEGIN
    -- On récupère les infos du dresseur
    SELECT * INTO v_dresseur FROM dresseur WHERE pseudo = p_pseudo;

    IF NOT FOUND THEN
      RAISE EXCEPTION 'Le dresseur % est introuvable.', p_pseudo;
    END IF;

    -- On récupère les infos du pokémon
    SELECT * INTO v_pokemon FROM pokemon WHERE nom = p_pokemon_nom;


    IF NOT FOUND THEN
      RAISE EXCEPTION 'Le pokémon % est introuvable.', p_pokemon_nom;
    END IF;

    -- On ajoute le pokémon à son dresseur
    INSERT INTO dresseur_pokemon(
      attaque,
      vie,
      defense,
      vitesse,
      pokemon_id,
      dresseur_id
    ) VALUES (
      p_attaque,
      p_vie,
      p_defense,
      p_vitesse,
      v_pokemon.id,
      v_dresseur.id
    );

    RAISE NOTICE 'Félicitations ! Le dresseur % a désormais le pokémon % avec les stats suivantes : % vie, % attaque, % defense, % vitesse', v_dresseur.pseudo, v_pokemon.nom, p_vie, p_attaque, p_defense, p_vitesse;

  END;

$$ language 'plpgsql';


/*
  A la fin d'un combat, vérifiera le nombre de point d'évolution du gagnant et le fera évolué une fois à 5 ou plus et donnera un bonus de 20% sur chaque stats

  TODO: pourquoi ou plus ? Normalement l'évolution se fait de 1 en 1 non ?
*/

CREATE OR REPLACE FUNCTION evolution() 
RETURNS trigger 
AS $$

  DECLARE
    vpokedex pokemon%ROWTYPE;
    vnouveau_pokemon varchar(50);
  BEGIN

    -- TODO: pourquoi ne pas mettre * ?
    -- anciennement: pokemon.id,nom,poids,taille,evolution,type_id_1,type_id_2
    SELECT * into vpokedex 
    FROM pokemon
    WHERE pokemon.id = NEW.pokemon_id;

    -- Evolue s'il a suffisamment de points et qu'il a une evolution
    -- TODO: normalement il passe JAMAIS > 5 ?!
    IF NEW.points_evolution >= 5 AND vpokedex.evolution IS NOT null THEN
      -- 20 % sur toutes les stats changement d'ID et remise à zéro de ces points évolution
      UPDATE dresseur_pokemon
      SET
        attaque = attaque * 1.2,
        defense = defense * 1.2 ,
        vie = vie * 1.2 ,
        vitesse = vitesse * 1.2,
        pokemon_id = vpokedex.evolution,
        points_evolution = 0
      WHERE id = NEW.id;
            
      SELECT pokemon.nom INTO vnouveau_pokemon 
      FROM pokemon
      WHERE pokemon.id = (
        select dresseur_pokemon.pokemon_id
        from dresseur_pokemon
        where id = NEW.id
      );
            
            
      raise notice 'Votre % evolue en %',vpokedex.nom,vnouveau_pokemon;
    END IF;
        
    RETURN NEW;
  END;

$$ language 'plpgsql';


CREATE OR REPLACE VIEW dresseur_pokemon_info AS
  SELECT
    p.nom AS pokemon_nom, p.id AS pokemon_id,
    d.id AS dresseur_id, d.pseudo, d.nom AS dresseur_nom, d.prenom
  FROM dresseur_pokemon AS dp
  INNER JOIN pokemon AS p
    ON p.id = dp.pokemon_id
  INNER JOIN dresseur AS d
    ON d.id = dp.dresseur_id
  ORDER BY dresseur_id
;