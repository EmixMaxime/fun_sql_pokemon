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
