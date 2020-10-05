%{
#include<stdio.h>
extern FILE *yyin;
extern char* yytext;
extern yylineno;
%}
%token BGIN END CLASA ID NR ATRIBUT TIP IF THEN ELSE OP_LOGIC OP_NOT OP_ARITM DO WHILE FOR TO DOWN_TO RETURN MAIN CONST
%start s
%%
s	:	inainte_de_main		main	 END{printf("input corect\n");}
	;
inainte_de_main		:	BGIN	ID	lista_declaratii
			;
lista_declaratii	:	declaratie
			|	lista_declaratii	declaratie
			;
declaratie	:	declaratie_clasa
		|	declaratie_functie
		;
declaratie_clasa	:	CLASA	ID	derivat	BGIN	lista_continut_clasa	END
			;
derivat		:	'<' ATRIBUT CLASA ID
		| /*eps*/
		;
lista_continut_clasa	:	continut_clasa
			|	lista_continut_clasa continut_clasa
			;
continut_clasa	:	ATRIBUT decl_var_sau_vector
		|	ATRIBUT declaratie_constanta
		|	ATRIBUT	declaratie_functie
		;
decl_var_sau_vector	:	TIP lista_var_sau_vector	';'
			|	ID lista_var_sau_vector		';' /*pt declaratie de obiecte*/
			;
lista_var_sau_vector	:	id_var
			|	id_vector
			|	lista_var_sau_vector	','	id_var
			|	lista_var_sau_vector	','	id_vector
			;					
id_var	:	ID
	|	ID '='	NR 
	;

id_vector	:	ID '['']' '=' '{' lista_elemente_vector '}' 
		|	ID '['']''=''{''}'
		|	ID '['NR']'	
		;
lista_elemente_vector	:	NR
			|	'"' ID '"'
			|	'"''"'
			|	lista_elemente_vector ',' NR
			|	lista_elemente_vector ',' '"' ID '"'
			|	lista_elemente_vector ',' '"''"' 
			;	
declaratie_constanta	:	CONST TIP ID '=' NR ';'
			|	CONST TIPD ID '=' '"' ID '"' ';'
			;
declaratie_functie	: TIP ID '(' lista_parametrii ')' BGIN lista_instructiuni END
			| ID ID '(' lista_parametrii ')' BGIN lista_instructiuni END	/*ca sa pot returna un obiect*/
			;
lista_parametrii	:	parametru
			|	lista_parametrii ',' parametru
			;
parametru	:	TIP ID
		|	TIP ID '['NR']'
		|	ID ID		/*obiect ca parametru*/
		|	ID ID '['NR']'	/*vector de obiecte */
		;
lista_instructiuni	:	instructiune
			|	lista_instructiuni instructiune
			;
instructiune	:	decl_var_sau_vector
		|	declaratie_constanta
		|	atribuire
		|	IF_instructiune
		|	WH_instructiune
		|	FOR_instructiune
		|	DOWH_instructiune
		|	apel_functie
		|	return
		;
atribuire	:	ID '=' expresie ';'
		;
IF_instructiune	:	IF '(' lista_conditie ')' THEN consecinte else
		;
else	:	ELSE consecinte
	|	/*eps*/
	;
lista_conditie	:	conditie
		|	lista_conditie	OP_LOGIC	conditie
		|	OP_NOT	'('conditie')'
		|	lista_conditie OP_LOGIC	OP_NOT '(' conditie ')'
		;	
conditie	:	expresie '=''=' expresie
		|	expresie '<''=' expresie
		|	expresie '>''=' expresie
		|	expresie '>' expresie
		|	expresie '<' expresie
		|	expresie 
		;
expresie	:	ID
		|	NR
		|	expresie OP_ARITM expresie
		|	'(' expresie ')'
		;
consecinte	:	BGIN lista_consecinte END
		;
lista_consecinte	:	lista_consecinte instructiune
			|	instructiune
			;
WH_instructiune	:	WHILE '(' lista_conditie ')' DO consecinte
		;
FOR_instructiune	:	FOR '(' ID '=' expresie TO expresie ')' DO consecinte
			|	FOR '(' ID '=' expresie DOWN_TO expresie ')' DO consecinte
			;
DOWH_instructiune	:	DO consecinte WHILE '(' lista_conditie ')' ';'	
			;
apel_functie	:	ID '(' lista_param_apel ')' ';'
		;
lista_param_apel	:	expresie
			|	ID '(' lista_param_apel ')' /* apel_functie fara ; */
			|	lista_param_apel ',' expresie	
			|	lista_param_apel ',' ID '(' lista_param_apel ')'
			;
return	:	RETURN expresie ';'
	|	RETURN apel_functie
	;

main	:	MAIN BGIN lista_instructiuni END
	;
%% int yyerror(char* s)
{
	printf("eroare: %s la linia: %d\n", s,yylineno);
}
int main(int argc, char** argv)
{
	yyin=fopen(argv[1],"r");
	yyparse();
}
