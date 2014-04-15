
.PHONY: build
build:
	$(MAKE) -C generator build
	./generator/generator.native -json ./generator/apis.json -generated client/lib -mode library
	./generator/generator.native -json ./generator/apis.json -generated client/cloud -mode cmdliner
	$(MAKE) -C client build

.PHONY: clean
clean:
	$(MAKE) -C generator clean
	$(MAKE) -C client clean
	rm -f client/lib/cmdliner_commands.ml client/lib/request.ml client/lib/request.mli
