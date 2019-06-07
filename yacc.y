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
	| comment
    | STR
	;

objeto: nome':' info;

nome: STR;

array: '-' info;

comment: '#' STR;

linebreak: '|''-' info;

nolinebreak: '>' info;

%%

int main(){
   yyparse();
   return 0;
}
