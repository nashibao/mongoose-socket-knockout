
build: components index.coffee mongoose-knockout/index.js
	@echo build..
	coffee --compile --bare mongoose-knockout/index.coffee
	coffee --compile --bare index.coffee
	@component build --dev

components: component.json
	@component install --dev

clean:
	rm -fr build components index.js

.PHONY: clean
