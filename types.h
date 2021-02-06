#include <stdbool.h>
#ifndef typesH
#define typesH

#define INT 0
#define FLOAT 1
#define STRING 2
#define BOOLEAN 3

typedef struct{
    char *string;
    int integer;
    float real;
    bool boolean;
    char type;
} structure;

#endif
