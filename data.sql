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

-- tournoi
select creer_tournoi('test', 'Calais', '2017-11-25', 4);

select inscription_tournoi('Passpacou','test','calais','25/11/2017','Chenipan');
select inscription_tournoi('Triggered','test','calais','25/11/2017','Goupix');
select inscription_tournoi('Assembleur is bae','test','calais','25/11/2017','Pikachu');

select demarrer_tournoi('test', 'calais');

update participant set points = 0;
