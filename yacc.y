%{
    #define _GNU_SOURCE
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    extern char* yytext;
    extern int yylineno;
    extern int yylex();
    void yyerror(char*);
    char *strconcat(char *str1, char *str2);
    char* paragraph_concat(char *str1, char *str2);
%}

%union{
    double num;
    char* str;
}

%type <str> MEMBRO LINEBREAK MEMBROKV NOME STR KEYVALUE NOLINEBREAK
%type <str> Array Childs Child Text Elements Elem Parag String
%type <num> ST

%token MEMBRO NOLINEBREAK LINEBREAK MEMBROKV NOME ST STR KEYVALUE

%%

Start: ST Childs        { printf("{\n%s\n}\n", $2); }
     ;

Childs: Child Childs    { asprintf(&$$, "%s%s", $1, $2); }
      | Child           { $$ = $1; }
      ;

Child: NOME Array {
        asprintf(&$$, "\"%s\": [\n%s\n],\n", $1, $2);
     }
     | NOME Childs {
        asprintf(&$$, "\"%s\": {\n%s\n},\n", $1, $2);
     }
     | KEYVALUE {
        asprintf(&$$, "%s\n", $1);
     }
     | LINEBREAK Parag {
        asprintf(&$$, "\"%s\": \"%s\"\n", $1, $2);
     }
     | NOLINEBREAK Parag {
        asprintf(&$$, "\"%s\": \"%s\"\n", $1, $2);
     }
     ;

Parag: Text {
        $$ = malloc(sizeof(char)*(strlen($1)+1));
        snprintf($$, strlen($1)+1, "%s",$1);
     }
     ;

Text: String Text   { $$ = paragraph_concat($1, $2); }
    | String        { $$ = $1; }
    ;

String: STR         {
        $$ = malloc(sizeof(char)*(strlen($1)+8));
        snprintf($$, strlen($1) + 8, "%s",$1);
      }
      ;

Array: Elements {
        $$ = malloc(sizeof(char)*(strlen($1)+1));
        snprintf($$, strlen($1)+1, "%s",$1);
     }
     ;

Elements: Elem Elements { $$ = strconcat($1,$2); }
        | Elem          { $$ = $1; }
        ;

Elem: MEMBRO    {
        $$ = malloc(sizeof(char)*(strlen($1)+8));
        snprintf($$, strlen($1) + 8, "  \"%s\",",$1);
    }
    | MEMBROKV  {
        $$ = malloc(sizeof(char)*(strlen($1)+15));
        snprintf($$, strlen($1)+15,"  {\n    %s\n  },",$1);
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
    char *str3 = malloc(sizeof(char)*(len1+len2+2));

    snprintf(str3, len1+len2+2, "%s\n%s", str1, str2);

    return str3;
}

char* paragraph_concat(char *str1, char *str2){
    int len1 = strlen(str1);
    int len2 = strlen(str2);
    char *str3 = malloc(sizeof(char)*(len1+len2+2));

    snprintf(str3, len1+len2+9, "%s\\n%s", str1, str2);

    return str3;
}
