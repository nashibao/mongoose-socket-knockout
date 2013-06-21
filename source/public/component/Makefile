
build: components index.js
	@echo build..
	coffee --compile --bare index.coffee
	@component build --dev

components: component.json
	@component install --dev

clean:
	rm -fr build components template.js

.PHONY: clean
