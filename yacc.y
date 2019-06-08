%{
#include <stdio.h>
#include <string.h>
%}

%token STR
%%

programa: infos;

infos: info
    | info infos
	;

info: objeto
    | array
	| nolinebreak
	| linebreak
    | STR
	;

objeto: nome ':' info;

nome: STR;

array: '-' info;

linebreak: '|''-' info;

nolinebreak: '>' info;

%%
#include "lex.yy.c"
int yyerror(char* s) {
	printf("Erro:%s\n",s);
} 

int main () {
	yyparse();
	return 0;
}

