TOOLCHAIN_PREFIX=
INCLUDE_DIR="-I/usr/include/lua5.1"

all: libfceux/lib/libfceux.a Clib/lib/bpdriver.o

libfceux/include/types.h: libfceux/lib/libfceux.a

libfceux/lib/libfceux.a: libfceux-*_src.tar.bz2
	tar xvfj libfceux-*_src.tar.bz2
	if [ ! -d libfceux.src ]; then mv libfceux-?.?.? libfceux.src; fi
	cd libfceux.src;PREFIX=${TOOLCHAIN_PREFIX} INCLUDE=${INCLUDE_DIR} ./compile_lib.sh
	mkdir -p libfceux/include
	mkdir -p libfceux/lib
	cp -p libfceux.src/src/*.h ./libfceux/include
	mkdir -p libfceux/include/utils
	cp -p libfceux.src/src/utils/*.h ./libfceux/include/utils/
	mv libfceux.src/libfceux.a ./libfceux/lib
	rm -rf libfceux.src

Clib/lib/bpdriver.o: libfceux/include/types.h Clib/src/bpdriver.cpp Clib/include/bpdriver.h
	mkdir -p Clib/lib
	c++ -oClib/lib/bpdriver.o -Wno-write-strings -DPSS_STYLE=1 -I${ISE_EIFFEL}/studio/spec/linux-x86-64/include -c Clib/src/bpdriver.cpp

clean:
	rm -rf libfceux.src
	rm -rf libfceux
	rm Clib/lib/bpdriver.o
