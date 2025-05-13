%{
#include "parser.tab.h"
#include <string.h>
#include <stdio.h>
int lineno = 0;
%}

digit      [0-9]+
ws         [ \t]+
variable   [a-zA-Z]+[0-9]*

%%

"daire_ciz"      { return DAIRE_CIZ; }
"kare_ciz"       { return KARE_CIZ; }
"ucgen_ciz"      { return UCGEN_CIZ; }
"cizgi_ciz"      { return CIZGI_CIZ; }

"eger"           { return EGER; }
"ise"            { return ISE; }
"dongu"          { return DONGU; }
"neki"           { return NEKI; }


"+"                 return PLUS;
"-"                 return MINUS;
"/"                 return DIVIDE;
"*"                 return MULTIPLY;
"^"                 return POWER;
"%"                 return MODULO;

"<-"                return ASSIGN;
">"                 return BIGGER;
"=>"                return BIGGER_OR_EQUAL;
"<"                 return SMALLER;
"<="                return SMALLER_OR_EQUAL;
"=="                return ISEQUAL;
"!="                return NOT_ISEQUAL;
"!"                 return NOT;
"&&"                return AND;
"||"                return OR;
"="                 return EQUAL;

\n                  {lineno++; return EOL;}
--[^\n]*            { /* Yorum */ return COMMENT; }

"fonk"               { return FUNCTION; }
"knof"               { return END_OF_FUNCTION; }
:                    { return COLUMN; }
"dondur"             { return RETURN; }


"tus_basildi"         return TUS_BASILDI;
"TUS_YUKARI"          return TUS_YUKARI;
"TUS_ASAGI"           return TUS_ASAGI;
"TUS_SOLA"            return TUS_SOLA;
"TUS_SAGA"            return TUS_SAGA;


{variable}          { yylval.string = strdup(yytext); return VARIABLE; }
{digit}             { yylval.num = atoi(yytext); return NUMBER; }
{ws}                { }

.                   return yytext[0];

%%

int yywrap() {
    return 1;
}
