%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include<ctype.h>

char* info;

%}
%x INFO YAML ARRAY OBJECT PARAGRAPH CONTENT
%%
---             { printf("Inicio YAML.\n"); BEGIN YAML;}
<YAML>#.*       { printf("Encontrado comment.\n");}
<YAML>^(\ +)?-.*       {
    printf("Encontrado elemento '%s' do array '%s'\n", yytext, info);
}
<YAML>.*:  {
    printf("Encontrada array/object \"%s\"\n", yytext);
    info = strdup(yytext);
}
<YAML>[^-\n]*:[^>\|\n]+    {
    printf("Encontrado key value pair '%s' do object '%s'\n", yytext, info);
}
<YAML>.+:.>     {
    printf("Encontrado PARAGRAPH\n");
}
<YAML>.+:.\|-?    {
    printf("Encontrado CONTENT\n");
}
.|\n            {;}
<YAML>.|\n      {;}
%%

int yywrap(){
    return 1;
}

int main() {
    printf("Vou começar...\n");

    yylex();

    printf("Input todo percorrido.\n");
    return 0;
}

