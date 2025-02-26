CC=gcc
CFLAGS=-Werror

all: ASM C

ASM: asm/small_hello_world
asm/small_hello_world: asm/small_hello_world.asm
	nasm -X gnu $(CFLAGS) -f bin -o $@ $<

C: CFLAGS += -Wall -Wextra -Wpedantic
C: c/small_hello_world
c/small_hello_world: c/small_hello_world.c

clean:
	$(RM) $(BIN)

.PHONY: all clean
