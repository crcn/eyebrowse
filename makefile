

all: 
	coffee -o lib -c src;

clean:
	rm -rf lib;
	rm -rf build;


all-watch:
	coffee -o lib -cw src;


