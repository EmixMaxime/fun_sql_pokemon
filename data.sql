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

-- Insertion pokemons
INSERT INTO pokemon (nom, type_id_1)
  VALUES ('pikachu','ELE'),
  ('raichu','ELE'),
  ('salameche','FEU'),
  ('reptincel','FEU'),
  ('ratata','NOR'),
  ('ratatac','NOR')
;

INSERT INTO pokemon (nom, type_id_1, type_id_2) VALUES
  ('fantominus','SPE','POI'),
  ('spectrum','SPE','POI'),
  ('ectoplasma','SPE','POI'),
  ('dracaufeu','FEU','VOL')
;


-- Insertion dresseurs
INSERT INTO dresseur (prenom, nom, pseudo) VALUES
  (1, 'Dany', 'Capitain', 'America'),
  (2, 'Remi', 'Synave', 'Grenouille'),
  (3, 'Marguerite', 'Fernandez', 'Peu chère'),
  (4, 'Anne', 'Pacou', 'Passpacou'),
  (5, 'Severine', 'Letrez', 'Comptabilitey'),
  (6, 'Bruno', 'Warin', 'James Dany Boonde'),
  (7, 'Francois', 'Rousselle', 'Assembleur is bae'),
  (8, 'Dominique', 'Dussart', 'Triggered')
;

-- Insertion pokemons des dresseurs 
INSERT INTO dresseur_pokemon(attaque,defense,vitesse,vie,pokemon_id,dresseur_id) values (20,20,50,150,1,1);
INSERT INTO dresseur_pokemon (attaque,defense,vitesse,vie,pokemon_id,dresseur_id, points_evolution) values (500,100,100,170,1,2,4);
