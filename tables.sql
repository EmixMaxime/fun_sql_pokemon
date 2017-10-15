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

  -- Un pokémon peut avoir un type ou deux
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
  UNIQUE(nom, lieu)
);

CREATE TABLE participant(
  id serial PRIMARY KEY,
  dreseur_id int REFERENCES dresseur(id),
  tournoi_id int REFERENCES tournoi(id),
  points int default 0,

  -- avec quel pokémon le joueur va faire le tournoi ?
  dresseur_pokemon_id int REFERENCES dresseur_pokemon(id)
);
