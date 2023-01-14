(lang dune 2.0)

(name steakdechameau)

(authors "Valentin Meunier,
          Guillaume Garros
          Axel pronnier
          Marius chandèze")

(source
 (github herrlockskun/steakdechameau))

(generate_opam_files true)

(package
 (name steakdechameau)
 (synopsis "A game jam game")
 (depends
  orx
  (dune
   (>= 2.0))
  (ocaml
   (>= 4.10.0))))
