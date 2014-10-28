 /** Codigo c que se copia integro */
%{
#include "includes/tokens.h"


%}

 /** Opción de compilación:  Para decirle a flex que solo vamos a trabajar con 1 fichero */
%option noyywrap

%%

MAIN {
 	 return TOK_MAIN;
}
 /** Palabras reservadas */
INT {
 	 return TOK_INT;
}
BOOLEAN {
 	 return TOK_BOOLEAN;
}
ARRAY {
 	 return TOK_ARRAY;
}
FUNCTION {
 	 return TOK_FUNCTION;
}
IF {
 	 return TOK_IF;
}
ELSE {
 	 return TOK_ELSE;
}
WHILE {
 	 return TOK_WHILE;
}
SCANF {
 	 return TOK_SCANF;
}
PRINTF {
 	 return TOK_PRINTF;
}
RETURN {
 	 return TOK_RETURN;
}


 /** Simbolos */
";" {
 	 return TOK_PUNTOYCOMA;
}
"," {
 	 return TOK_COMA;
}
"(" {
 	 return TOK_PARENTESISIZQUIERDO;
}
")" {
 	 return TOK_PARENTESISDERECHO;
}
"[" {
 	 return TOK_CORCHETEIZQUIERDO;
}
"]" {
 	 return TOK_CORCHETEDERECHO;
}
"{" {
 	 return TOK_LLAVEIZQUIERDA;
}
"}" {
 	 return TOK_LLAVEDERECHA;
}
"=" {
 	 return TOK_ASIGNACION;
}
"+" {
 	 return TOK_MAS;
}
"-" {
 	 return TOK_MENOS;
}
"/" {
 	 return TOK_DIVISION;
}
"*" {
 	 return TOK_ASTERISCO;
}
"&&" {
 	 return TOK_AND;
}
"||" {
 	 return TOK_OR;
}

"!=" {
 	 return TOK_DISTINTO;
}

"!" {
 	 return TOK_NOT;
}
"==" {
 	 return TOK_IGUAL;
}
">=" {
 	 return TOK_MENORIGUAL;
}
"<=" {
 	 return TOK_MAYORIGUAL;
}
"<" {
 	 return TOK_MENOR;
}
">" {
 	 return TOK_MAYOR;
}

 /** Identificadores */

IDENTIFICADOR {
 	 return TOK_IDENTIFICADOR;
}

 /** Constantes */

CONSTANTE {
 	 return TOK_CONSTANTE_ENTERA;
}

TRUE {
 	 return TOK_TRUE;
}
FALSE {
 	 return TOK_FALSE;
}

 /** Errores */
ERROR {
 	 return TOK_ERROR;
}


. {}



%%

int main(int argc , char ** argv){
	int aux = yylex();
	
	FILE * fout = stdout;
	int i = 0;
	while (aux != 0)
	{
		switch (aux){
			case TOK_MAIN:
				fprintf(fout,TOK_MAIN_STR,TOK_MAIN,yytext);
			break;
			case TOK_INT:
				fprintf(fout,TOK_INT_STR,TOK_INT,yytext);
			break;
			case TOK_BOOLEAN:
				fprintf(fout,TOK_BOOLEAN_STR,TOK_BOOLEAN,yytext);
			break;
			case TOK_ARRAY:
				fprintf(fout,TOK_ARRAY_STR,TOK_ARRAY,yytext);
			break;
			case TOK_FUNCTION:
				fprintf(fout,TOK_FUNCTION_STR,TOK_FUNCTION,yytext);
			break;
			case TOK_IF:
				fprintf(fout,TOK_IF_STR,TOK_IF,yytext);
			break;
			case TOK_ELSE:
				fprintf(fout,TOK_ELSE_STR,TOK_ELSE,yytext);
			break;
			case TOK_WHILE:
				fprintf(fout,TOK_WHILE_STR,TOK_WHILE,yytext);
			break;
			case TOK_SCANF:
				fprintf(fout,TOK_SCANF_STR,TOK_SCANF,yytext);
			break;
			case TOK_PRINTF:
				fprintf(fout,TOK_PRINTF_STR,TOK_PRINTF,yytext);
			break;
			case TOK_RETURN:
				fprintf(fout,TOK_RETURN_STR,TOK_RETURN,yytext);
			break;
			case TOK_PUNTOYCOMA:
				fprintf(fout,TOK_PUNTOYCOMA_STR,TOK_PUNTOYCOMA,yytext);
			break;
			case TOK_COMA:
				fprintf(fout,TOK_COMA_STR,TOK_COMA,yytext);
			break;
			case TOK_PARENTESISIZQUIERDO:
				fprintf(fout,TOK_PARENTESISIZQUIERDO_STR,TOK_PARENTESISIZQUIERDO,yytext);
			break;
			case TOK_PARENTESISDERECHO:
				fprintf(fout,TOK_PARENTESISDERECHO_STR,TOK_PARENTESISDERECHO,yytext);
			break;
			case TOK_CORCHETEIZQUIERDO:
				fprintf(fout,TOK_CORCHETEIZQUIERDO_STR,TOK_CORCHETEIZQUIERDO,yytext);
			break;
			case TOK_CORCHETEDERECHO:
				fprintf(fout,TOK_CORCHETEDERECHO_STR,TOK_CORCHETEDERECHO,yytext);
			break;
			case TOK_LLAVEIZQUIERDA:
				fprintf(fout,TOK_LLAVEIZQUIERDA_STR,TOK_LLAVEIZQUIERDA,yytext);
			break;
			case TOK_LLAVEDERECHA:
				fprintf(fout,TOK_LLAVEDERECHA_STR,TOK_LLAVEDERECHA,yytext);
			break;
			case TOK_ASIGNACION:
				fprintf(fout,TOK_ASIGNACION_STR,TOK_ASIGNACION,yytext);
			break;
			case TOK_MAS:
				fprintf(fout,TOK_MAS_STR,TOK_MAS,yytext);
			break;
			case TOK_MENOS:
				fprintf(fout,TOK_MENOS_STR,TOK_MENOS,yytext);
			break;
			case TOK_DIVISION:
				fprintf(fout,TOK_DIVISION_STR,TOK_DIVISION,yytext);
			break;
			case TOK_ASTERISCO:
				fprintf(fout,TOK_ASTERISCO_STR,TOK_ASTERISCO,yytext);
			break;
			case TOK_AND:
				fprintf(fout,TOK_AND_STR,TOK_AND,yytext);
			break;
			case TOK_OR:
				fprintf(fout,TOK_OR_STR,TOK_OR,yytext);
			break;
			case TOK_NOT:
				fprintf(fout,TOK_NOT_STR,TOK_NOT,yytext);
			break;
			case TOK_IGUAL:
				fprintf(fout,TOK_IGUAL_STR,TOK_IGUAL,yytext);
			break;
			case TOK_DISTINTO:
				fprintf(fout,TOK_DISTINTO_STR,TOK_DISTINTO,yytext);
			break;
			case TOK_MENORIGUAL:
				fprintf(fout,TOK_MENORIGUAL_STR,TOK_MENORIGUAL,yytext);
			break;
			case TOK_MAYORIGUAL:
				fprintf(fout,TOK_MAYORIGUAL_STR,TOK_MAYORIGUAL,yytext);
			break;
			case TOK_MENOR:
				fprintf(fout,TOK_MENOR_STR,TOK_MENOR,yytext);
			break;
			case TOK_MAYOR:
				fprintf(fout,TOK_MAYOR_STR,TOK_MAYOR,yytext);
			break;
			case TOK_IDENTIFICADOR:
				fprintf(fout,TOK_IDENTIFICADOR_STR,TOK_IDENTIFICADOR,yytext);
			break;
			case TOK_CONSTANTE_ENTERA:
				fprintf(fout,TOK_CONSTANTE_ENTERA_STR,TOK_CONSTANTE_ENTERA,yytext);
			break;
			case TOK_TRUE:
				fprintf(fout,TOK_TRUE_STR,TOK_TRUE,yytext);
			break;
			case TOK_FALSE:
				fprintf(fout,TOK_FALSE_STR,TOK_FALSE,yytext);
			break;
			default:
				fprintf(fout,TOK_ERROR_STR,TOK_ERROR,yytext);
		}
		aux = yylex();
	}
	return 0;
}