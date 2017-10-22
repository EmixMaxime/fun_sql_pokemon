# Documentation

## Présentation générale
Il s'agit ici de créer une base de données sous PostgreSQL permettant de gérer des tournois de Pokémon dans lesquels des Pokémons pourront se battre. Cette base va permettre l'enregistrement de personne en tant que `dresseur`, un recensement des `pokemon`s possibles. Ainsi que la création de tournoi.

Les tables :
- `type` regroupe les types des pokémons,
- `efficacite` représente l'efficacité d'un type sur un autre sous la forme d'un coefficient,
- `pokemon` regroupe l'ensemble des pokémons possible,
- `dresseur` regroupe l'ensemble des dresseurs de pokémons,
- `dresseur_pokemon` regroupe les dresseurs appartenant aux dresseurs,
- `tournoi` regroupe les compétitions opposants les dresseurs,
- `participant` regroupe les dresseurs participants à un tournoi. 


## Insertion des données

### Pour une création rapide, éxecuter le fichier 'base.sql' et passer à l'étape suivante
- Exécuter le fichier `tables.sql`.

- Ajouter la fonction et son trigger présent dans le fichier `type_id_to_uppercase_func_trig.sql` qui permet de mettre en majuscule les identifiants des `type`s.

- Ajouter la fonction `insert_auto_efficacite_when_new_type` et son trigger.

- Exécuter le fichier `data-type.sql` qui insère les différents types.

- Ajouter la fonction `maj_efficacite`.

- Éxécuter le fichier `data-efficacite.sql` afin de modifier les efficacités.

- Ajouter la fonction `maj_evolution`.

- Exécuter le fichier `data-pokemon.sql` afin d'ajouter les pokémons.

- Ajouter la fonction `combat`.

- Ajouter la fonction `affichage_combat`

- Ajouter la fonction `evolution` et son trigger.

- Ajouter la fonction `dresseur_pokemon_evolution`.

- Ajouter la fonction `ajout_dresseur_pokemon`.

- 

## Description des fonctions
- Fonction `type_id_to_uppercase()` va mettre les `id` des `type`s enregistrés en majuscule.

- Fonction et Trigger `insert_efficacite_when_new_type()` vont remplir la table `efficacite` de toutes les combinaisons de `type` possible et mettre leur `taux` à 1 par défaut.

- Fonction `maj_efficacite (p_type_nom1 varchar, p_type_nom2 varchar, p_eff float)` va permettre de fixer le `taux` désigné par `p_eff` lorsqu'un `type.id`, désigner par `p_type_nom1`, se bat contre un autre `type.id` désigné par `p_type_nom2`.

- Fonction `maj_evolution(p_pokemon_base int, p_pokemon_evolution int)` permet de d'assigner à un pokémon `p_pokemon_base`, une évolution `p_pokemon_evolution`.

- Fonction `ajout_dresseur_pokemon
  (p_pseudo varchar, p_pokemon_nom varchar, p_attaque int, p_vie int, p_defense int, p_vitesse int)` ajoute un `dresseur_pokemon` en spécifiant le pseudo du dresseur et les paramètres du pokémon.

- Fonction `combat(p_dresseur_pok1 int, p_dresseur_pok2 int)` va permettre le combat de deux pokémon, il faut insérer les `id` de `dresseur_pokemon` correspondants. Elle retourne l'un de ces `id`.

- Fonction `affichage_combat(numero int, eff float, vie int)` renvoie un affichage lors du combat.

- Fonction et Trigger `evolution()` vérifie si les `points_evolution` d'un `dresseur_pokemon` sont suffisant et le fait évoluer si possible.

- Fonction `dresseur_pokemon_evolution(dresseur_pok_id integer)` ajoute un `points_evolution` au pokemon gagnant.




## Ajout d'un pokémon à un dresseur

## Tournoi
| Function                                                                         | Return Type | Example                                                           |
|----------------------------------------------------------------------------------|-------------|-------------------------------------------------------------------|
| `creer_tournoi(nom varchar, lieu varchar, date date, capacite int)`              | `void`      | `SELECT creer_tournoi('Super power', 'Calais', '15/10/2017', 4);` |
| `demarrer_tournoi(nom varchar, lieu varchar)`                                    | `void`      | `SELECT demarrer_tournoi('Super power', 'Calais');`               |


Cette fonction créé un tournoi. Ce tournoi n'est pas démarré, il faudra attendre le jour d'ouverture pour pouvoir l'ouvrir grâce à la fonction `demarrer_tournoi`.


**Un tournoi peut avoir le même nom dans différents lieux pour des dates différentes.**. *Clef unique composée sur `nom` `lieu` et `date`*.

### Fonctionnement
Les tournois ne peuvent se faire que par `4 || 8 || 16`, soit un nombre pair. Prenons l'exemple d'un tournois de 4. Le joueur 1 va affronter le 2 ainsi que le 3 contre le 4. À l'issue de se roulement, 2 joueurs auront gagné, se veront donc attribuer `5` points. Le "round" passe à 1 (le deuxième roulement), je sélectionne les joueurs ayant `round *5`, soit mes deux joueurs. Je les fais s'affronter sur le même principe.


À chaque roulement je sélectionne les joueurs ayant le maximum de points. S'il n'y a qu'un joueur, c'est notre grand gagnant !

## Déroulement d'un combat
- Ajouter la fonction combat `combat`. Rôle : permettre à deux de pokémon de combattre ceux-ci vont s'infliger des dégâts en prenant en compte leur `vitesse` (ordre d'attaque), l'`attaque`, la `défense`, et le `taux` d'`efficacite` par rapport à leurs types respectifs afin de réduire la `vie` de l'autre pokémon à 0. Le pokémon gagnant recevra 1 `points_evolution`. L'affichage des messages a été ralenti pour plus de compréhension.

- L'affichage est effectué par la fonction `affichage_combat`.

- La fonction combat prendre pour paramètre les deux `id` de la table `dresseur_pokemon` des pokémon qui vont combattre.
Exemple : 
```sql
SELECT combat(1,2);
```

## Les vues
- `dresseur_pokemon_info` qui nous donne le `nom`, `pseudo` `nom` et `id` du dresseur avec l'`id` et le `nom` de son pokémon.

## Normalisation
- Première forme normale : Chaque attribut est unique et créer une dépendance entre les tables grâce aux clés étrangères qui établissent les relations entre les tables.

- Deuxième forme normale : Chaque attibut non clés de la table est dépendant d'un attribut clés.

- Troisième forme normale : Les attributs non clés sont uniquement dépendants d'une ou plusieurs clés, et ne sont pas dépendants d'autres attributs non clés.

- Cette base ne respecte pas la Forme normale de Boyce-Codd car :
  dresseur.id -> pseudo;
  pseudo      -> dresseur.id;

## Problèmes rencontrés
Lors du développement de la fonction combat afin de renseigner les variables des Pokémon, nous utilisions un Curseur, de ce fait l'ordre des paramètres était cruciale pour avoir les bon résultats. Les Fetch prenaient les paramètres toujours dans le même ordre. Nous avons résolu ça, via l'utilisation de requêtes.