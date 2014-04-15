
JSON:=api/4ba688f07d9b629aa8e6420eda8092c92aa3d180.json

.PHONY: build
build:
	$(MAKE) -C generator build
	./generator/generator.native -json $(JSON) -generated client/lib -mode library
	./generator/generator.native -json $(JSON) -generated client/cloud -mode cmdliner
	$(MAKE) -C client build

.PHONY: clean
clean:
	$(MAKE) -C generator clean
	$(MAKE) -C client clean
	rm -f client/cloud/cmdliner_commands.ml client/lib/request.ml client/lib/request.mli
