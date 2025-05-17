%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *yyin;
extern int lineno;
int parse_error = 0;

int yylex();
void yyerror(const char *s) {
    printf("Hata: Satir %d\n", lineno);
    parse_error = 1;
}
%}

%union {
    int num;
    char* string;
}

%token <string> VARIABLE
%token <num> NUMBER

%token DAIRE_CIZ KARE_CIZ UCGEN_CIZ CIZGI_CIZ
%token EGER ISE DONGU NEKI IKEN AKSI_HALDE
%token FUNCTION END_OF_FUNCTION COLUMN RETURN
%token TUS_BASILDI
%token TUS_YUKARI TUS_ASAGI TUS_SOLA TUS_SAGA
%token ASSIGN EQUAL ISEQUAL BIGGER SMALLER BIGGER_OR_EQUAL SMALLER_OR_EQUAL NOT AND OR NOT_ISEQUAL
%token PLUS MINUS DIVIDE POWER MODULO MULTIPLY
%token COMMENT
%token EOL


%%

statements:
    | statements statement
    ;

statement:
      draw_command
    | if_statement
    | function
    | RETURN expression
    | COMMENT
    | expression
    | declaration
    | EOL
    | dongu_statement
    | tus_tusu
    | TUS_BASILDI
    ;

expression:
      NUMBER
    | VARIABLE
    | expression PLUS expression
    | expression MINUS expression
    | expression MULTIPLY expression
    | expression DIVIDE expression
    | expression MODULO expression
    | expression POWER expression
    | expression ISEQUAL expression
    | expression NOT_ISEQUAL expression
    | expression BIGGER expression
    | expression SMALLER expression
    | expression BIGGER_OR_EQUAL expression
    | expression SMALLER_OR_EQUAL expression
    | expression AND expression
    | expression OR expression
    | NOT expression
    | TUS_BASILDI tus_tusu
    ;

declaration:
      VARIABLE ASSIGN expression
    ;

function:
    FUNCTION VARIABLE parametres COLUMN block END_OF_FUNCTION
    ;

parametres:
    | parametres VARIABLE
    | parametres NUMBER
    ;

draw_command:
      DAIRE_CIZ NUMBER NUMBER NUMBER
    | KARE_CIZ NUMBER NUMBER NUMBER
    | CIZGI_CIZ NUMBER NUMBER NUMBER NUMBER
    | UCGEN_CIZ NUMBER NUMBER NUMBER NUMBER NUMBER NUMBER
    ;

if_statement:
    EGER expression ISE block
    | EGER expression ISE block AKSI_HALDE block
    ;

block:
      statement
    | '{' statements '}'
    ;

dongu_statement:
    DONGU expression IKEN block NEKI
    ;

tus_tusu:
    TUS_YUKARI
    | TUS_ASAGI
    | TUS_SOLA
    | TUS_SAGA
    ;

%%

int main(int argc, char **argv) {
    printf("=== Çizim Program ===\n");
    if (argc > 1) {
         yyin = fopen(argv[1], "r");
         if (!yyin) {
            perror("Dosya açılamadı");
            return 1;
         }
    }

    yyparse();

    if (!parse_error)
        printf("Kod gramer kurallarina uygundur.\n");

    return 0;
}
