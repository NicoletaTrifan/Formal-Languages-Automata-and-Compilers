%{
#include<stdio.h>
#include "y.tab.h"
%}
%option noyywrap
%%
"/*"(.|\n)+"*/" ;
"int"|"float"|"char"|"string"|"bool" {return TIP;}
"begin" {return BGIN;}
"clasa" {return CLASA;}
"end" {return END;}
"if" {return IF;}
"then" {return THEN;}
"else" {return ELSE;}
"do" {return DO;}
"while" {return WHILE;}
"for" {return FOR;}
"to" {return TO;}
"down_to" {return DOWN_TO;} 
"return" {return RETURN;}
"main" {return MAIN;}
"const" {return CONST;}
("&&"|"||") {return OP_LOGIC;}
"!" {return OP_NOT;}
[-+*/] {return OP_ARITM;}
"privat"|"public"|"protected" {return ATRIBUT;}
[1-9][0-9]*|0|[1-9][0-9]*"."[0-9]* {return NR;}
[a-zA-Z][a-zA-Z0-9]* {return ID;}
[ \t] ;
\n {yylineno++;}
. {return yytext[0];}
