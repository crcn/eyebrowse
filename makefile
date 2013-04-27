clean:
	rm -rf lib;
	rm -rf build;

build:
	nexe -i ./lib/index.js -o ./build/apuppet;


app: 
	coffee -o lib -c src;


app-watch:
	coffee -o lib -cw src;


