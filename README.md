# Notice d'installation d'ocaml ORX et de ses problèmes rencontrés

**Tout ce qui suit a été fait sous Ubuntu 22.04**

## Prérequis

* Ocaml 
* gmake

Ces deux logiciels doivent être installé sur la machine avant la suite

## Installations   

### Etape 1

* Opam 
>`$ sudo apt-get install opam`
* ORX suivre ces [instructions](https://wiki.orx-project.org/en/tutorials/orx/cloning_orx_from_github)
* Puis ne pas oublier de compiler la librairie 
  
### Etape 2
```bash
$ opam install dune ctypes ctypes-foreign fmt dune-configurator
$ git clone https://github.com/orx/ocaml-orx
$ cd ocaml-orx
$ dune build
```

### Problèmes possibles

* ctypes problemes voir [ici](https://github.com/orx/ocaml-orx/issues/21#issue-1446918770)
* liborx.so not find -> 

ajouter `export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/path/to/orx/code/lib/dynamic/`

### Bonus ajouter la librairie à opam

`opam pin add orx path/to/ocaml/orx`

### Ressources

* [Ocaml real world](https://dev.realworldocaml.org/files-modules-and-programs.html)
* [Le wiki orx](https://wiki.orx-project.org/)
* Un jeu fini avec la même lib [shatter un jeu complet](https://github.com/hcarty/shatter)
* [La lib ocaml-orx](https://github.com/orx/ocaml-orx)


# Etat du jeu 

## Synopsis

Knil un jeune entrepreneur ambitieux et malin souhaite ouvrir un resto de steak de chamo dans le futur. Cependant les chamo ont disparu de son époque et du futur, il doit donc voyager dans le pc pour chasser du chamo. Suivez la à travers son aventure exceptionel à travers le temps.

## Système de jeu

C'est un jeu d'aventure ou l'on se déplace sur différents tableaux

## Etat d'avancement 

Les niveaux 1,2,3 sont faiblement implémentés

## Projet de developpement 

Continuer le developpement : 
* Implémenter la persistance du score à travers les niveaux
* Tuer les spawners entre les tableaux
* Ecrire du texte ENTRE les niveaux

## Credits

Musique : [Marius Chandèze](github.com/machandeze)
Graphisme : [Guillaume Garros](github.com/RedGuigui)
Scénario : [Axel Pronnier](github.com/Axpronnier) et [Valentin Meunier](github.com/herrlockskun)
Developpement : [Axel Pronnier](github.com/Axpronnier), [Valentin Meunier](github.com/herrlockskun), [Guillaume Garros](github.com/RedGuigui) et [Marius Chandèze](github.com/machandeze)





