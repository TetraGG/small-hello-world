## Introduction

This project aims to create the smallest possible binary file that outputs "Hello, World!" using various programming languages.
The goal is to explore the limits, understand the minimal requirements for a functional executable in each language and how to optimize
their sizes.
The target architecture is Unix System V Advanced Micro Devices X86-64 ABI.

## Prerequisites

The project build is base on Makefile. Make sure you have `make` installed.
To compile and execute the tiny binaries, ensure you have the following tools installed for each language:

- [nasm](https://www.nasm.us/) (Netwide Assembler): is required to convert assembly source code into an executable binary;
- [gcc](https://gcc.gnu.org/): the GNU Compiler Collection is used to compile the C code;
- [g++](https://gcc.gnu.org/): the GNU C++ Compiler is necessary for compiling C++;
- [go](https://go.dev/): Go toolchain is required for compiling Go code;
- [java](https://openjdk.org/): the Java Development Kit is necessary for compiling Java code, though alternative approaches may involve native executables. You can choose
your preferred jdk;
- [python3](https://www.python.org/): python interpreter is needed to run Python file, though Python scripts are not compiled into binaries;
- [rust](https://www.rust-lang.org): the Rust compiler toolchain is used to build rust binary;
- [shell](https://en.wikipedia.org/wiki/Unix_shell/): nothing required, shell scripts leverage the system's built-in interpreter, making them dependency-free;
- [zig](https://ziglang.org/): the Zig compiler is used to generate corresponding binary.

## Build

Use the provided Makefile to build, test and generate results:

```shell
make
make tests
```

## Results

| Langage       | Kind          | Size    |
|---------------|---------------|---------|
| ASM_corrupted | Compiled      | 149     |
| ASM           | Compiled      | 163     |
| Zig           | Compiled      | 12952   |
| C             | Compiled      | 14280   |
| CPP           | Compiled      | 16240   |
| Go            | Compiled      | 1819356 |
| Rust          | Compiled      | 3975016 |
| Java          | Semi-compiled | 766     |
| Shell         | Interpreted   | 31      |
| Python        | Interpreted   | 41      |
