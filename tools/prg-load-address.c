#include <stdio.h>
#include <stdlib.h>
#include "my-little-endian.h"

int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        printf("Usage: %s filename", argv[0]);
        return 1;
    }

    char *path = argv[1];
    FILE *file;
    file = fopen(path, "rb");

    if (!file)
    {
        printf("Failed to open file: %s", path);
        return 1;
    }

    const uint16_t loadAddress = fget16le(file);

    fclose(file);

    printf("%04x", loadAddress);

    return 0;
}
