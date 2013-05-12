clean:
	rm -rf lib;
	rm -rf build;

build:
	nexe -i ./lib/index.js -o ./build/apuppet;


all: 
	coffee -o lib -c src;


all-watch:
	coffee -o lib -cw src;


