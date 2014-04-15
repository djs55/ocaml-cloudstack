
.PHONY: build
build: setup.data
	ocaml setup.ml -build

setup.data: _oasis
	ocaml setup.ml -configure

.PHONY: clean
clean:
	ocaml setup.ml -clean
