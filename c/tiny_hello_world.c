#include <unistd.h>

#define UNUSED(x) (void)(x)

int main() {
    UNUSED(write(1, "Hello, World!\n", 14));
}
