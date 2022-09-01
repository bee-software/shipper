.PHONY: all clean

all: out/purpleship.sh

clean:
	rm -rf out/

out/purpleship.sh: out
	./build_bundle.sh out/purpleship.sh

out:
	mkdir out