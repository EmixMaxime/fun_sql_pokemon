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