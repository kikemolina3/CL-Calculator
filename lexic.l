%option noyywrap
%{
    #include "syntax.tab.h"
    #include "types.h"
%}

%x COMMENTARY

sep                 [ \t\r]*
int                 0|[1-9][0-9]*
float               [0-9]*\.[0-9]+([eE][-+]?[0-9]+)?
string              \".*\"
commentary          "//".*"\n"
identifier          [a-zA-Z0-9]+

%%

^{sep}\n
"\n"                    return INTRO; 
":="                    return ASIGN; 
"("                    	return OPEN;
")"                     return CLOSE;
"+"                     { yylval.var.type = STRING; yylval.var.string = strdup(yytext); return ADD; }
"-"                     { yylval.var.type = STRING; yylval.var.string = strdup(yytext); return SUB; }
"*"                     { yylval.var.type = STRING; yylval.var.string = strdup(yytext); return MUL; }
"/"                     { yylval.var.type = STRING; yylval.var.string = strdup(yytext); return DIV; }
"mod"                   { yylval.var.type = STRING; yylval.var.string = "%"; return MOD; }
"**"                    { yylval.var.type = STRING; yylval.var.string = "^"; return POW; }
"sin"			{ yylval.var.type = STRING; yylval.var.string = "sin"; return SIN; }
"cos"			{ yylval.var.type = STRING; yylval.var.string = "cos"; return COS; }
"tan"			{ yylval.var.type = STRING; yylval.var.string = "tan"; return TAN; }
">"                     { yylval.var.type = STRING; yylval.var.string = strdup(yytext); return GT; }
"<"                     { yylval.var.type = STRING; yylval.var.string = strdup(yytext); return LT; }
">="                    { yylval.var.type = STRING; yylval.var.string = strdup(yytext); return GE; }
"<="                    { yylval.var.type = STRING; yylval.var.string = strdup(yytext); return LE; }
"=="                    { yylval.var.type = STRING; yylval.var.string = strdup(yytext); return EQ; }
"<>"                    { yylval.var.type = STRING; yylval.var.string = strdup(yytext); return NE; }
"true"                  return TTRUE;
"false"                 return TFALSE;
"not"                   return NOT;
"and"                   return AND;
"or"                    return OR;
{sep}                   
{commentary}            
"/*"                    { BEGIN(COMMENTARY); }
<COMMENTARY>"*/\n" { BEGIN(INITIAL); }
<COMMENTARY>"\n"
<COMMENTARY>.
{int}                   { yylval.var.type = INT; yylval.var.integer = atoi(yytext); return VAR; }
{float}                 { yylval.var.type = FLOAT; yylval.var.real = atof(yytext); return VAR; }
{string}                { 	yylval.var.type = STRING; 
				yylval.var.string = (char*)malloc(yyleng-2); 
				strncpy(yylval.var.string, yytext+1, yyleng-2); 
				return VAR; 
			}
{identifier}            { 	yylval.var.type = STRING; 
				yylval.var.string = strdup(yytext);
				structure v;
    				if(sym_lookup(yylval.var.string, &v) == SYMTAB_NOT_FOUND) 
    					return ARITHMETIC_ID; 
    				if (v.type == BOOLEAN) 
    					return BOOLEAN_ID;
    				else 
    					return ARITHMETIC_ID; 
    			}
.                       { 	printf("[ERROR] Input %s not accepted.\n", yytext); 
				yyterminate(); 
			}
<<EOF>>                 { yyterminate(); }
