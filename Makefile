CC=gcc
CFLAGS=-Werror

all: ASM C

ASM: asm/small_hello_world asm/corrupted_hello_world
asm/small_hello_world: asm/small_hello_world.asm
	nasm -X gnu $(CFLAGS) -f bin -o $@ $<

asm/corrupted_hello_world: asm/corrupted_hello_world.asm
	nasm -X gnu $(CFLAGS) -f bin -o $@ $<

C: CFLAGS += -Wall -Wextra -Wpedantic -ffunction-sections -fdata-sections -Os
C: LDFLAGS += -Wl,--gc-sections
C: strip
c/small_hello_world: c/small_hello_world.c

strip: c/small_hello_world
	strip -s -R .comment -R .gnu.version --strip-unneeded c/small_hello_world

clean:
	$(RM) $(BIN)

.PHONY: all clean
