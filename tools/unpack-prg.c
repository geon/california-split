#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <sys/stat.h>
#include <string.h>
#include "my-little-endian.h"

uint8_t readNext(const uint8_t **iterator)
{
    return *(*iterator)++;
}

void writeNext(uint8_t **iterator, const uint8_t *end, const uint8_t value)
{
    assert(*iterator < end && "Writing out of bounds.");
    *(*iterator)++ = value;
}

const size_t c64RamSize = 0x10000;

size_t unpack(
    // const size_t loadAddress,
    const size_t packedAddress,
    const size_t unpackedAddress,
    const uint8_t *packed,
    uint8_t *unpacked)
{
    const uint8_t *read = packed;
    uint8_t *write = unpacked;
    const uint8_t *readEnd = read + (c64RamSize - packedAddress);
    uint8_t *writeEnd = write + (c64RamSize - unpackedAddress);

    while (read < readEnd)
    {
        const uint8_t byte = readNext(&read);

        if (byte == 0xbf)
        {
            const uint8_t length = readNext(&read);
            for (size_t index = 0; index < length; ++index)
            {
                writeNext(&write, writeEnd, 0);
            }
        }
        else if (byte == 0xcf)
        {
            const uint8_t length = readNext(&read);
            const uint8_t value = readNext(&read);
            for (size_t index = 0; index < length; ++index)
            {
                writeNext(&write, writeEnd, value);
            }
        }
        else
        {
            writeNext(&write, writeEnd, byte);
        }
    }

    return write - unpacked;
}

int parseHexDigit(char digit)
{
    if (digit >= '0' && digit <= '9')
    {
        return digit - '0';
    }
    else if (digit >= 'a' && digit <= 'f')
    {
        return digit - 'a' + 10;
    }
    else if (digit >= 'A' && digit <= 'F')
    {
        return digit - 'A' + 10;
    }
    else
    {
        return -1;
    }
}

int main(int argc, char *argv[])
{
    if (argc != 4)
    {
        printf("Usage: %s input.prg output.prg unpack_from_address\n", argv[0]);
        return 1;
    }

    char *inputPath = argv[1];
    char *outputPath = argv[2];
    FILE *inputFile;
    FILE *outputFile;
    inputFile = fopen(inputPath, "rb");
    outputFile = fopen(outputPath, "wb");

    if (!inputFile)
    {
        printf("Failed to open input file: %s\n", inputPath);
        return 1;
    }
    if (!outputFile)
    {
        printf("Failed to open output file: %s\n", outputPath);
        return 1;
    }

    char *unpackFromAddressString = argv[3];
    uint16_t unpackFromAddress = 0;
    if (strlen(unpackFromAddressString) != 4)
    {
        printf("The address must be 4 hexdecimal digits.\n");
    }
    for (int index = 0; index < 4; ++index)
    {
        char digit = unpackFromAddressString[index];
        int value = parseHexDigit(digit);
        if (value == -1)
        {
            printf("Not a hexadecimal digit: %c\n", digit);
        }

        unpackFromAddress *= 16;
        unpackFromAddress += value;
    }

    uint8_t *packedBuffer = malloc(c64RamSize);
    uint8_t *unpackedBuffer = malloc(c64RamSize);

    const size_t loadAddress = fget16le(inputFile);
    fseek(inputFile, unpackFromAddress - loadAddress + 2, SEEK_SET);
    fread(packedBuffer, 1, c64RamSize, inputFile);
    fclose(inputFile);

    // Hardcoded for all prgs.
    const uint16_t unpackToAddress = 0x0a00;

    size_t sizeUnpacked = unpack(
        unpackFromAddress,
        unpackToAddress,
        packedBuffer,
        unpackedBuffer);

    fput16le(unpackToAddress, outputFile);
    fwrite(unpackedBuffer, 1, sizeUnpacked, outputFile);
    fclose(outputFile);

    return 0;
}
