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
- Ajouter la fonction et son trigger présent dans le fichier `type_id_to_uppercase_func_trig.sql` qui permet de mettre en majuscule les identifiants des `type`s.

- Ajouter la fonction `insert_auto_efficacite` et son trigger. Rôle : remplir la table efficacité lorsqu'un nouveau type est ajouté. Le taux d'efficacité contre tous les types est fixé à 1 par défaut.

- Exécuter le fichier `data-type.sql` qui insère les différents types.

- Ajouter la fonction `maj_efficacite`.

- Éxécuter le fichier `data-efficacite.sql` afin de modifier les efficacités.

- Ajouter la fonction `maj_evolution`.

- Exécuter le fichier `data-pokemon.sql` afin d'ajouter les pokémons.


## Ajout d'un pokémon à un dresseur

## Tournoi
| Function                                                                         | Return Type | Example                                                           |
|----------------------------------------------------------------------------------|-------------|-------------------------------------------------------------------|
| `creer_tournoi(nom varchar, lieu varchar, date date, capacite int)`              | `void`      | `SELECT creer_tournoi('Super power', 'Calais', '15/10/2017', 4);` |
| `demarrer_tournoi(nom varchar, lieu varchar)`                                    | `void`      | `SELECT demarrer_tournoi('Super power', 'Calais');`               |


Cette fonction créé un tournoi. Ce tournoi n'est pas démarré, il faudra attendre le jour d'ouverture pour pouvoir l'ouvrir grâce à la fonction `demarrer_tournoi`.


**Un tournoi peut avoir le même nom dans différents lieux.**. *Clef unique composée sur `nom` et `lieu`*.

## Déroulement d'un combat
- Ajouter la fonction combat `combat`. Rôle : permettre à deux de pokémon de combattre ceux-ci vont s'infliger des dégâts en prenant en compte leur `vitesse` (ordre d'attaque), l'`attaque`, la `défense`, et le `taux` d'`efficacite` par rapport à leurs types respectifs afin de réduire la `vie` de l'autre pokémon à 0. Le pokémon gagnant recevra 1 `points_evolution`.

- L'affichage est effectué par la fonction `affichage_combat`.

- La fonction combat prendre pour paramètre les deux `id` de la table `dresseur_pokemon` des pokémon qui vont combattre.
Exemple : SELECT combat(1,2);

## Les vues
- `dresseur_pokemon_info` qui nous donne le `nom`, `pseudo` `nom` et `id` du dresseur avec l'`id` et le `nom` de son pokémon.

## Normalisation
- Première forme normale : Chaque attribut est unique et créer une dépendance entre les tables grâce aux clés étrangères qui établissent les relations entre les tables.
- Deuxième forme normale : Chaque attibut non clés de la table est dépendant d'un attribut clés.
- Troisième forme normale : Les attributs non clés sont uniquement dépendants d'une ou plusieurs clés, et ne sont pas dépendants d'autres attributs non clés.
- Forme normale de Boyce-Codd : 

## Problèmes rencontrés
Lors du développement de la fonction combat afin de renseigner les variables des Pokémon, nous utilisions un Curseur, de ce fait l'ordre des paramètres était cruciale pour avoir les bon résultats. Les Fetch prenaient les paramètres toujours dans le même ordre. Nous avons résolu ça, via l'utilisation de requêtes.