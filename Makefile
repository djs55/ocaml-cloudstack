
.PHONY: build
build: setup.data generator/listApis_t.ml generator/listApis_j.ml
	ocaml setup.ml -build

setup.data: _oasis
	ocaml setup.ml -configure

generator/listApis_t.ml generator/listApis_j.ml: generator/listApis.atd
	atdgen -o-no-name-overlap -o generator/listApis -t generator/listApis.atd
	atdgen -o-no-name-overlap -o generator/listApis -j generator/listApis.atd

.PHONY: clean
clean:
	ocaml setup.ml -clean
