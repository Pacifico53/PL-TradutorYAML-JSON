%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>
#include"y.tab.h"
char* info;

%}
%%
---                     { 
        printf("Inicio YAML.\n");
        yylval.str = strdup(yytext);
        return INIT;
}
#.+                     { printf("Comment\n"); }
(\ )*([a-zA-Z_]+(\ )?)+ {
        printf("STR \'%s\'\n", yytext);
        yylval.str = strdup(yytext);
        return STR;
}
[();:+\-*/={}<>!]       { printf("PONTUAÇAO \'%c\'\n", yytext[0]); }
.|\n                    {;}
%%

int yywrap(){
    return 1;
}

