.PHONY: all clean

all: out/shipper.sh

clean:
	rm -rf out/

out/shipper.sh: out
	./build_bundle.sh out/shipper.sh

out:
	mkdir out