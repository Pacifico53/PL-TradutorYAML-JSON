%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    extern char* yytext;
    extern int yylineno;
    extern int yylex();
    void yyerror(char*);
    char *strconcat(char *str1, char *str2);
%}

%union{
    double num;
    char* str;
    char** list;
}

%type <num> NUM
%type <str> CHAVE MEMBRO MEMBROKV NOME Elements Elem KEYVALUE
%type <str> Array Objeto Childs Child
%type <num> ST

%token NUM CHAVE MEMBRO MEMBROKV NOME ST KEYVALUE

%%

Start: ST Childs
     ;

Childs: Child Childs    {sprintf($$,"%s%s",$1,$2);}
      | Child           {$$ = $1;}
      ;

Child: NOME Array   {
        printf("\"%s\": [\n%s\n],\n", $1, $2);
     }
     | NOME Objeto  {
        printf("\"%s\": {\n%s\n},\n", $1, $2);
     }
     | KEYVALUE     {
        printf("%s\n", $$);
     }
     ;

Array: Elements {
        $$ = (char*)malloc(sizeof(char)*(strlen($1)+10));
        sprintf($$,"%s",$1);
     }
     ;

Objeto: KEYVALUE Childs {
            $$ = malloc(sizeof(char*)*(strlen($1)+strlen($2)+10));
            sprintf($$,"%s\n%s",$1,$2);
      }
      ;

Elements: Elem Elements { $$ = strconcat($1,$2); }
        | Elem          { $$ = $1; }
        ;

Elem: MEMBRO {
        $$ = (char*)malloc(sizeof(char)*(strlen($1)+8));
        sprintf($$,"  \"%s\",",$1);
    }
    | MEMBROKV {
        $$ = (char*)malloc(sizeof(char)*(strlen($1)+8));
        sprintf($$,"  {\n    %s\n  },",$1);
    }
    ;

%%
#include "lex.yy.c"

int main(){
    yyparse();
    return 0;
}

void yyerror(char* erro){
    fprintf(stderr, "%s, %s, %d \n", erro, yytext, yylineno);
}

char* strconcat(char *str1, char *str2){
    int len1 = strlen(str1);
    int len2 = strlen(str2);
    char *str3 = (char *)malloc(sizeof(char)*(len1+len2+1));

    strcpy(str3,str1);
    strcpy(&(str3[len1]),"\n");
    strcpy(&(str3[len1])+1,str2);

    return str3;
}

