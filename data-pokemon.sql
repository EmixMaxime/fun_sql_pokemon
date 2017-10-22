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