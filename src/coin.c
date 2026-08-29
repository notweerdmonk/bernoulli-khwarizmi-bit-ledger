#include <errno.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/random.h>

int main(void)
{
    unsigned char byte;

    ssize_t result;

    do {
        result = getrandom(&byte, sizeof(byte), 0);
    } while (result < 0 && errno == EINTR);

    if (result != 1) {
        perror("getrandom");
        return EXIT_FAILURE;
    }

    /*
     * Use the least significant bit.
     * Output is exactly one character: 0 or 1.
     */
    putchar((byte & 1u) ? '1' : '0');
    putchar('\n');

    return EXIT_SUCCESS;
}

