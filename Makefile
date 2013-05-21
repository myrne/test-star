build:
	mkdir -p lib
	rm -rf lib/*
	node_modules/.bin/coffee --compile -m --output lib/ src/

watch:
	node_modules/.bin/coffee --watch --compile --output lib/ src/
	
test:
	node_modules/.bin/mocha

jumpstart:
	curl -u 'meryn' https://api.github.com/user/repos -d '{"name":"test-star", "description":"Minimal test runner for minimal tests.","private":false}'
	mkdir -p src
	touch src/test-star.coffee
	mkdir -p test
	touch test/test-star.coffee
	npm install
	git init
	git remote add origin git@github.com:meryn/test-star
	git add .
	git commit -m "jumpstart commit."
	git push -u origin master

.PHONY: test