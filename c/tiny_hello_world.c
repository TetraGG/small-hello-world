#include <unistd.h>

int main() {
    #pragma GCC diagnostic push
    #pragma GCC diagnostic ignored "-Wunused-result"
    write(1, "Hello, World!\n", 14);
    #pragma GCC diagnostic pop
}
