# Documentation

## Présentation générale

## Insertion des données
- Ajouter la fonction et son trigger présent dans le fichier `type_id_to_uppercase_func_trig.sql` qui permet de mettre en majuscule les identifiants des `type`s.

- Ajouter la fonction `insert_auto_efficacite` et son trigger. Rôle : remplir la table efficacité lorsqu'un nouveau type est ajouté. Le taux d'efficacité contre tous les types est fixé à 1 par défaut.

- Exécuter le fichier `data-type.sql` qui insère les différents types.

- Ajouter la fonction `maj_efficacite`.

- Éxécuter le fichier `data-efficacite.sql` afin de modifier les efficacités.


## Ajout d'un pokémon à un dresseur

## Création d'un tournoi

## Déroulement d'un combat
- Ajouter la fonction combat `combat`. Rôle : permettre à deux de pokémon de combattre ceux-ci vont s'infliger des dégâts en prenant en compte leur `vitesse` (ordre d'attaque), l'`attaque`, la `défense`, et le `taux` d'`efficacite` par rapport à leurs types respectifs afin de réduire la `vie` de l'autre pokémon à 0. Le pokémon gagnant recevra 1 `points_evolution`.

- La fonction combat prendre pour paramètre les deux `id` de la table `dresseur_pokemon` des pokémon qui vont combattre.
Exemple : SELECT combat(1,2);
