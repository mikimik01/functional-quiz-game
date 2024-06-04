ALL: build run

build:
	opam exec -- dune build

run:
	opam exec -- dune exec Take_It_Caml_Quiz