# Notice d'installation d'ocaml ORX et de ses problèmes rencontrés

**Tout ce qui suit a été fait sous Ubuntu 22.04**

## Prérequis

* Ocaml 
* gmake

Ces deux logiciels doivent être installé sur la machine avant la suite

## Installations   

### Etape ez

* Opam 
>`$ sudo apt-get install opam`
* ORX suivre ces [instructions](https://wiki.orx-project.org/en/tutorials/orx/cloning_orx_from_github)
  
### Etape ocaml-orx
```bash
$ opam install dune ctypes ctypes-foreign fmt
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

### Tuto 

* [Ocaml real world](https://dev.realworldocaml.org/files-modules-and-programs.html)
* [Le wiki orx](https://wiki.orx-project.org/)
* [shatter un jeu complet](https://github.com/hcarty/shatter)

