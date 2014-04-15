
.PHONY: build
build: setup.data src/listApis_t.ml src/listApis_j.ml
	ocaml setup.ml -build

setup.data: _oasis
	ocaml setup.ml -configure

src/listApis_t.ml src/listApis_j.ml: src/listApis.atd
	atdgen -o-no-name-overlap -o src/listApis -t src/listApis.atd
	atdgen -o-no-name-overlap -o src/listApis -j src/listApis.atd

.PHONY: clean
clean:
	ocaml setup.ml -clean
	rm -f src/listApis_t.ml src/listApis_t.mli src/listApis_j.ml src/listApis_j.mli
