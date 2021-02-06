#ifndef functionsH
#define functionsH

#include "types.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "symtab.h"

structure check_boolean(structure op1, structure operator, structure op2);
structure calculate(structure op1, structure operator, structure op2);
structure negate(structure value);
structure trigonometric_op(structure value, structure op);
void print_result(structure result);
void yyerror(const char *msg);

#endif
