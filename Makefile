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
JAVA=java/TinyHelloWorld
SEMI_COMP=$(JAVA)
PYTHON=python/tiny_hello_world
SH=shell/tiny_hello_world
INT=$(PYTHON) $(SH)

all: $(BIN) $(SEMI_COMP)

asm/tiny_hello_world: asm/tiny_hello_world.asm
	nasm -X gnu $(CFLAGS) -f bin -o $@ $<

asm/corrupted_hello_world: asm/corrupted_hello_world.asm
	nasm -X gnu $(CFLAGS) -f bin -o $@ $<

$(C): CFLAGS += -Wall -Wextra -Wpedantic -ffunction-sections -fdata-sections -Os
$(C): LDFLAGS += -Wl,--gc-sections
$(C): c/tiny_hello_world.c
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $<
	strip -s -R .comment -R .gnu.version --strip-unneeded $@

$(CPP): CPPFLAGS += -Wall -Wextra -Wpedantic -ffunction-sections -fdata-sections -Os
$(CPP): LDFLAGS += -Wl,--gc-sections

$(GO): go/tiny_hello_world.go
	go build -o $@ $<

$(JAVA): java/TinyHelloWorld.class
	jar cvfe $@ TinyHelloWorld -C java $(call notdir,$<)

java/TinyHelloWorld.class: java/TinyHelloWorld.java
	javac $<

$(RUST): rust/tiny_hello_world.rs
	rustc -o $@ $<

$(ZIG): zig/tiny_hello_world.zig
	zig build-exe -O ReleaseSmall -femit-bin=$@ $<
	$(RM) $@.o

tests: all
	./tests/tests.py -c $(BIN)
	./tests/tests.py -sc $(SEMI_COMP)
	./tests/tests.py -i $(INT)

tests-ci: all
	chmod +x $(BIN) $(SEMI_COMP) $(INT)
	./tests/tests.py -ss -c $(BIN)
	./tests/tests.py -ss -sc $(SEMI_COMP)
	./tests/tests.py -ss -i $(INT)

# Manual dependency
deploy:
	cp tests/data_*.yml deploy/

clean:
	$(RM) $(BIN) java/TinyHelloWorld.class $(JAR)

.PHONY: all strip tests deploy clean
