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
