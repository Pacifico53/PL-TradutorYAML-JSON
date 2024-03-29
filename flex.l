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

void fix_key_val(char* keyval, char* res){
    char* token;
    char* strs[2];
    strs[0] = NULL;
    strs[1] = NULL;
    int i = 0;
    
    token = strtok(keyval, ":");
    
    while(token && i<2){
        strs[i++] = strdup(token);
        token = strtok(NULL, ":");
    }
    if(strs[1] != NULL){
        snprintf(res, 64, "\"%s\": \"%s\"", strs[0], strs[1]+1);
    }
    else{
        snprintf(res, 64, "\"%s\": null", strs[0]);
    }

    free(token);
    free(strs[0]);
    free(strs[1]);
}

%}

%option noyywrap

%%

^---    { return ST; }; //inicio do ficheiro yaml

^#.+    { ; }; //apanhar os comentários para ignorar

^[\t| ]*[a-zA-Z_0-9 ]+:$ {
    // para apanhar o nome do array / objeto
    aux = strtok(strdup(yytext),":");
    trim(aux, NULL);
    yylval.str = strdup(aux);
    free(aux);
    return NOME;
}

^[\t| ]*-\ *[a-zA-Z_ 0-9]+ {
    // para apanhar os membros de um array
    aux = strdup(yytext);
    trim(aux, " -");
    yylval.str = strdup(aux);
    free(aux);
    return MEMBRO;
}

^[\t| ]*-\ [a-zA-Z_0-9]+:[ _a-zA-Z0-9]* {
    // para apanhar os membros KEYVALUE de um array
    char auxKV[64];
    aux = strdup(yytext);
    trim(aux, " -");
    fix_key_val(aux, auxKV);
    yylval.str = strdup(auxKV);
    free(aux);
    return MEMBROKV;
}

[a-zA-Z_0-9]+:\ [a-zA-Z_0-9]+ {
    //para apanhar o par key:value
    char auxKV[64];
    fix_key_val(yytext, auxKV);
    yylval.str = strdup(auxKV);
    return KEYVALUE;
}

^[\t| ]*[a-zA-Z0-9_]+:\ \|-$ {
    // para apanhar o nome de um linebreak
    aux = strtok(strdup(yytext),":");
    trim(aux, NULL);
    yylval.str = strdup(aux);
    free(aux);
    return LINEBREAK;
}

^[\t| ]*[,.a-zA-Z 0-9]+$ {
    // para apanhar texto simples
    aux = strdup(yytext);
    trim(aux, NULL);
    yylval.str = strdup(aux);
    free(aux);
    return STR;
}

^[\t| ]*[a-zA-Z0-9_]+:\ >$ {
    // para apanhar o nome de um nolinebreak
    aux = strtok(strdup(yytext),":");
    trim(aux, NULL);
    yylval.str = strdup(aux);
    free(aux);
    return NOLINEBREAK;
}

.|\n {;}

%%

int get_spaces(char* line) {
    int i;
    for(i = 0; line[i] == ' '; i++);
    return i;
}

