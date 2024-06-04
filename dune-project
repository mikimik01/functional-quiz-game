(lang dune 3.7)

(name Take_It_Caml_Quiz)

(generate_opam_files true)

(source
 (github GrajaKonrad/Take_It_Caml_Quiz))

(authors "Mikołaj Kmieciak & Konrad Graja")

(maintainers "Konrad Graja")

(license MIT)

(documentation https://github.com/GrajaKonrad/Take_It_Caml_Quiz)

(package
 (name Take_It_Caml_Quiz)
 (synopsis "Simple quiz game")
 (description "Quiz game written in OCaml. It reads questions from a file and asks them to the user. The user can answer the questions and get a score at the end.")
 (depends ocaml dune)
 )

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/dune-files.html#dune-project
