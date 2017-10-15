# Documentation

## Présentation générale

## Insertion des données
- Ajouter la fonction et son trigger présent dans le fichier `type_id_to_uppercase_func_trig.sql` qui permet de mettre en majuscule les identifiants des `type`s.

- Ajouter la fonction `insert_auto_efficacite` et son trigger. Rôle : remplir la table efficacité lorsqu'un nouveau type est ajouté. Le taux d'efficacité contre tous les types est fixé à 1 par défaut.

- Exécuter le fichier `data-type.sql` qui insère les différents types.

- Ajouter la fonction `maj_efficacite`.

- Éxécuter le fichier `data-efficacite.sql` afin de modifier les efficacités.


## Ajout d'un pokémon à un dresseur

## Tournoi
| Function                                                                         | Return Type | Example  |
| -------------------------------------------------------------------------------- |:-----------:| -----:|
| `creer_tournoi(p_nom varchar, p_lieu varchar, p_date date, p_capacite int)`      | `void`      | `SELECT creer_tournoi('Super power', 'Calais', '15/10/2017', 4);` |
| `demarrer_tournoi(p_nom varchar)` | `void` | `SELECT demarrer_tournoi('Super power');` |


Cette fonction créé un tournoi. Ce tournoi n'est pas démarré, il faudra attendre le jour d'ouverture pour pouvoir l'ouvrir grâce à la fonction `demarrer_tournoi`.

## Déroulement d'un combat
- Ajouter la fonction combat `combat`. Rôle : permettre à deux de pokémon de combattre ceux-ci vont s'infliger des dégâts en prenant en compte leur `vitesse` (ordre d'attaque), l'`attaque`, la `défense`, et le `taux` d'`efficacite` par rapport à leurs types respectifs afin de réduire la `vie` de l'autre pokémon à 0. Le pokémon gagnant recevra 1 `points_evolution`.

- La fonction combat prendre pour paramètre les deux `id` de la table `dresseur_pokemon` des pokémon qui vont combattre.
Exemple : SELECT combat(1,2);
