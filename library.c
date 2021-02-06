#include "library.h"


structure check_boolean(structure op1, structure operator, structure op2) {
    if (op1.type == STRING || op2.type == STRING)
        yyerror("Strings comparation not allowed");

    char *op = operator.string;
    structure r;
    r.type = BOOLEAN;
    float r1, r2;
    
    if (op1.type == INT) 	r1 = op1.integer;
    if (op1.type == FLOAT) 	r1 = op1.real;
    if (op2.type == INT) 	r2 = op2.integer;
    if (op2.type == FLOAT) 	r2 = op2.real;

    if (strlen(op) == 1) {
        if(op[0] == '>') r.boolean = r1 > r2;
        if(op[0] == '<') r.boolean = r1 < r2;
    } 
    else {
        if(op[0] == '>' && op[1] == '=') r.boolean = r1 >= r2;
        if(op[0] == '<' && op[1] == '=') r.boolean = r1 <= r2;
        if(op[0] == '=' && op[1] == '=') r.boolean = r1 == r2;
        if(op[0] == '<' && op[1] == '>') r.boolean = r1 != r2;
    }
    return r;
}

structure negate(structure value) {
    if(value.type == INT) 	value.integer = -value.integer;
    if(value.type == FLOAT) 	value.real = -value.real;
    return value;
}

structure calculate(structure op1, structure operator, structure op2) {
    structure r;
    float r1, r2, number;
    char op = (operator.string)[0];
    
    if (op1.type == INT) r1 = op1.integer;
    if (op1.type == FLOAT) r1 = op1.real;
    if (op2.type == INT) r2 = op2.integer;
    if (op2.type == FLOAT) r2 = op2.real;
    
    if (op1.type == INT && op2.type == INT) r.type = INT;
    else r.type = FLOAT;
    
    if (op == '+') {
        if (op1.type == STRING || op2.type == STRING) {
            r.type = STRING;
            char *aux;
            if (op1.type == STRING) {
                if(op2.type == INT) {
                        aux = malloc(strlen(op1.string) + sizeof(int));
                        sprintf(aux, "%s%i", op1.string, op2.integer);
                }
                if(op2.type == FLOAT) {
                        aux = malloc(strlen(op1.string) + sizeof(float));
                        sprintf(aux, "%s%f", op1.string, op2.real);
                }
                if(op2.type == STRING) {
                        aux = malloc(strlen(op1.string) + strlen(op2.string));
                        sprintf(aux, "%s%s", op1.string, op2.string);
                };
            } 
            else {
                if(op1.type == INT) {
                        aux = malloc(strlen(op2.string) + sizeof(int));
                        sprintf(aux, "%i%s", op1.integer, op2.string);
                }
                if(op1.type == FLOAT) {
                        aux = malloc(strlen(op2.string) + sizeof(float));
                        sprintf(aux, "%f%s", op1.real, op2.string);
                };
            }
            r.string = aux;
        }
        else number = r1 + r2;
    }

    if (op != '+' && (op1.type == STRING || op2.type == STRING))
        yyerror("String operation not allowed");

    if (op == '-') number = r1 - r2;
    if (op == '*') number = r1 * r2;
    if (op == '/') number = r1 / r2;
    if (op == '^') number = pow(r1, r2);
    if (op == '%') {
        if (op1.type == INT && op2.type == INT) number = (int)r1 % (int)r2;
        else yyerror("MOD operation require only integers");
    }
    
    if (op1.type == INT && op2.type == INT) r.integer = number;
    else if(!(op1.type == STRING || op2.type == STRING)) r.real = number;
    
    return r;
}

structure trigonometric_op(structure value, structure op){
	structure r;
	r.type = FLOAT; 
	float number;
	if(value.type == INT) 	number = value.integer;
	if(value.type == FLOAT) number = value.real;
	if(!strcmp(op.string, "cos")) r.real = (float)cos(number);
	if(!strcmp(op.string, "sin")) r.real = (float)sin(number);
	if(!strcmp(op.string, "tan")) r.real = (float)tan(number);
	return r;
}

void print_result(structure r) {
    if(r.type == INT) 		printf("Type: integer -- Value: %i\n", (int)r.integer);
    if(r.type == FLOAT) 	printf("Type: float -- Value: %f\n", r.real);
    if(r.type == STRING) 	printf("Type: string -- Value: %s\n", r.string);       
    if(r.type == BOOLEAN){
            if (r.boolean) 	printf("Type: boolean -- Value: true \n"); 
            else 		printf("Type: boolean -- Value: false\n"); 
    }
}
