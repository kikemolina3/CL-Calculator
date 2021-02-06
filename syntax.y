%{
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include <stdlib.h>
#include <math.h>
#include "symtab.h"

extern FILE* yyin;
extern int yylineno;

int yylex();
%}

%code requires {
    #include "library.h"
}

%define parse.error verbose

%union {
    structure var;
};

%token ASIGN OPEN CLOSE TTRUE TFALSE AND OR NOT
%token <var> ADD SUB MUL DIV POW MOD GT LT GE LE EQ NE VAR BOOLEAN_ID ARITHMETIC_ID INTRO COS SIN TAN
%type <var> expression arithmetic_op1 arithmetic_op2 boolean_op arithmetic_exp boolean_exp trigonometric_op sum mul pow and not top_bool instructions instruction

%start instructions

%%

instructions: instructions instruction           
    | instruction                             
;

instruction: ARITHMETIC_ID ASIGN expression INTRO 	{ sym_enter($1.string, &$3); printf("Var \"%s\" -- ", $1.string); print_result($3); }
    | BOOLEAN_ID ASIGN expression INTRO        		{ sym_enter($1.string, &$3); printf("Var \"%s\" -- ", $1.string); print_result($3); }
    | expression INTRO                        		{ print_result($1); };

expression: arithmetic_exp                             
    | boolean_exp                             
;

arithmetic_exp: arithmetic_exp arithmetic_op1 sum	{ $$ = calculate($1, $2, $3); } 
    | sum                                  
;

sum: sum arithmetic_op2 mul                            	{ $$ = calculate($1, $2, $3); } 
    | SUB VAR                              		{ $$ = negate($2);}
    | SUB ARITHMETIC_ID                     		{ structure s; if(sym_lookup($2.string, &s) == SYMTAB_NOT_FOUND) yyerror("Identifier does not exist"); $$ = negate(s); }
    | mul                                   
;

mul: mul POW pow                            		{ $$ = calculate($1, $2, $3); } 
    | pow                                 
;

pow: ARITHMETIC_ID                           		{ if(sym_lookup($1.string, &$$) == SYMTAB_NOT_FOUND) yyerror("Identifier does not exist"); }
    | VAR                                   		{ $$ = $1; }
    | OPEN arithmetic_exp CLOSE                  	{ $$ = $2; }
    | trigonometric_op OPEN arithmetic_exp CLOSE	{ $$ = trigonometric_op($3, $1); }
;

boolean_exp: boolean_exp OR and               		{ $$.boolean = $1.boolean; $$.type = BOOLEAN; }
    | and                                   
;

and: and AND not                          		{ $$.boolean = $1.boolean; $$.type = BOOLEAN; }
    | not                                   
;

not: NOT top_bool                                	{ $$ = $2; $$.boolean = !$$.boolean; $$.type = BOOLEAN; }
    | top_bool                                   
;

top_bool: arithmetic_exp boolean_op arithmetic_exp  	{ $$ = check_boolean($1, $2, $3); } 
    | TTRUE                                  		{ $$.boolean = true; $$.type = BOOLEAN; }
    | TFALSE                                  		{ $$.boolean = false; $$.type = BOOLEAN; }
    | OPEN boolean_exp CLOSE                 		{ $$ = $2; }
    | BOOLEAN_ID                            		{ if(sym_lookup($1.string, &$$) == SYMTAB_NOT_FOUND) yyerror("Identifier does not exist"); }
;

arithmetic_op1: ADD | SUB;                                

arithmetic_op2: MUL | DIV | MOD;      

trigonometric_op: SIN | COS | TAN;                           

boolean_op: GT | LT | GE | LE | EQ | NE;

%%

void yyerror(const char *err)
{
    printf("ERROR!: (%s), line: %i", err, yylineno);
    exit(1);
}

int main(int argc, char **argv)
{
    if (argc > 1)
        yyin = fopen(argv[1],"r");
    else
        yyin = stdin;
    yyparse();
    return 0;
}
