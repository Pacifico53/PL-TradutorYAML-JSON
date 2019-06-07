%{
	#include <stdio.h>
	#include <string.h>
	#include "abin.c"
	
	FILE *ficheiro;
%}

%token COMENTARIO ELEMENTO
%%

programa: infos;

infos: info
        | info infos
	;

info: objeto 
    	| array
	| nolinebreak
	| linebreak
	| COMENTARIO
	;

objeto: nome':' info;

array: '-' info;

nolinebreak: '>' 
%%

