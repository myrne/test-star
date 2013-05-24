build:
	mkdir -p js
	rm -rf js/*
	node_modules/.bin/coffee --compile -m --output js/ coffee/
	browserify js/fixtures/test.js --debug > public/test.js
	coffee coffee/makeIndexHTML.coffee

watch:
	node_modules/.bin/coffee --watch --compile --output js/ coffee/
	
test:
	node_modules/.bin/mocha js/test/*.js

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