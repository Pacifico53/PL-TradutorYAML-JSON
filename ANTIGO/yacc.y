%{
#include <stdio.h>
#include <string.h>
%}
%union { char* str; int num;}
%token STR INIT
%type <str> INIT STR infos info objeto array nolinebreak linebreak
%%

programa: INIT infos     { printf("'%s'\n'%s'\nSTOP\n", $1, $2); }

infos: infos info
    | info
	;

info: objeto        { $$ = $1; printf("?%s?\n", $1); }
    | array         { $$ = $1; printf("!%s!\n", $1); }
	| nolinebreak   { $$ = $1; printf(";%s;\n", $1); }
	| linebreak     { $$ = $1; printf("@%s@\n", $1); }
    | STR           { $$ = $1; printf("^%s^\n", $1); }
	;

objeto: STR ':' info        { printf("yo'%s' e '%s'", $1, $3); }

array: STR '-' info         { printf("yo'%s' e '%s'", $1, $3); }

linebreak: STR '|''-' info  { printf("yo'%s' e '%s'", $1, $4); }

nolinebreak: STR '>' info   { printf("yo'%s' e '%s'", $1, $3); }

%%
#include "lex.yy.c"

int yyerror(char* s) {
	printf("Erro:%s\n",s);
} 

int main () {
	yyparse();
	return 0;
}

