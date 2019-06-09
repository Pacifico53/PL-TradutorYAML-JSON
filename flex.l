%{
#include <stdio.h>
#include "y.tab.h"

char* aux; 
int atual = 0;

void trim(char *str, char *seps){
    size_t totrim;
    int i = 0;
    if(!seps){
        seps = "\t\n\v\f\r ";
    }
    totrim = strspn(str, seps);
    if (totrim > 0) {
        size_t len = strlen(str);
        if (totrim == len) {
            str[0] = '\0';
        }
        else {
            memmove(str, str + totrim, len + 1 - totrim);
        }
    }

    i = strlen(str) - 1;
    while (i >= 0 && strchr(seps, str[i]) != NULL) {
        str[i] = '\0';
        i--;
    }
}

%}

%option noyywrap

%%

^---    { return ST; }; //inicio do ficheiro yaml

^#.+    { printf("Comment\n"); }; //apanhar os comentários para ignorar

^[\t| ]*[a-zA-Z_]+:[^ a-zA-Z] {
    // para apanhar o nome do array / objeto
    aux = strtok(strdup(yytext),":");
    trim(aux, NULL);
    yylval.str = strdup(aux);
    aux = NULL;
    return NOME;
}

^[\t| ]*-\ *[a-zA-Z_ ]+ {
    // para apanhar os membros de um array
    aux = strdup(yytext);
    trim(aux, " -");
    yylval.str = strdup(aux);
    aux = NULL;
    return MEMBRO;
}

^[\t| ]*-\ [a-zA-Z_]+:[ _a-zA-Z0-9]* {
    // para apanhar os auxros KEYVALUE de um array
    aux = strdup(yytext);
    trim(aux, " -");
    yylval.str = strdup(aux);
    aux = NULL;
    return MEMBROKV;
}

[a-zA-Z_]+:\ [a-zA-Z_]+ {
    //para apanhar o par key:value
    yylval.str = strdup(yytext);
    return KEYVALUE;
}

[\n\t] {;}

%%

int get_spaces(char* line) {
    int i;
    for(i = 0; line[i] == ' '; i++);
    return i;
}

