CC=gcc
CFLAGS=-Werror
CPPFLAGS=$(CFLAGS)

ASM=asm/tiny_hello_world asm/corrupted_hello_world
C=c/tiny_hello_world
CPP=cpp/tiny_hello_world
GO=go/tiny_hello_world
RUST=rust/tiny_hello_world
ZIG=zig/tiny_hello_world
BIN=$(ASM) $(C) $(CPP) $(GO) $(RUST) $(ZIG)
JAVA=java/TinyHelloWorld.jar
SEMI_COMP=$(JAVA)
PYTHON=python/tiny_hello_world
SH=shell/tiny_hello_world
INT=$(PYTHON) $(SH)

all: $(BIN) $(SEMI_COMP)

asm/tiny_hello_world: asm/tiny_hello_world.asm
	nasm -X gnu $(CFLAGS) -f bin -o $@ $<

asm/corrupted_hello_world: asm/corrupted_hello_world.asm
	nasm -X gnu $(CFLAGS) -f bin -o $@ $<

c/tiny_hello_world: CFLAGS += -Wall -Wextra -Wpedantic -ffunction-sections -fdata-sections -Os
c/tiny_hello_world: LDFLAGS += -Wl,--gc-sections
c/tiny_hello_world: c/tiny_hello_world.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<
	strip -s -R .comment -R .gnu.version --strip-unneeded $@

cpp/tiny_hello_world: CPPFLAGS += -Wall -Wextra -Wpedantic -ffunction-sections -fdata-sections -Os
cpp/tiny_hello_world: LDFLAGS += -Wl,--gc-sections

go/tiny_hello_world: go/tiny_hello_world.go
	go build -o $@ $<

java/TinyHelloWorld.jar: java/TinyHelloWorld.class
	jar cvf $@ $<

java/TinyHelloWorld.class: java/TinyHelloWorld.java
	javac $<

rust/tiny_hello_world: rust/tiny_hello_world.rs
	rustc -o $@ $<

zig/tiny_hello_world: zig/tiny_hello_world.zig
	zig build-exe -O ReleaseSmall -femit-bin=$@ $<
	$(RM) $@.o

tests: all
	./tests/tests.py -c $(BIN)
	./tests/tests.py -sc $(SEMI_COMP)
	./tests/tests.py -i $(INT)

clean:
	$(RM) $(BIN) java/TinyHelloWorld.class java/TinyHelloWorld.jar

.PHONY: all strip tests clean
