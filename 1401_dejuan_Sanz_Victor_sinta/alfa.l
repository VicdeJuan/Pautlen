 /** Codigo c que se copia integro */
%{

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "y.tab.h"
%}

 /** Opción de compilación:  Para decirle a flex que solo vamos a trabajar con 1 fichero */
%option noyywrap

%%


"//".* {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_LINE_UP;

}
\n {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_JUMP;
}

[ \t] {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_COL_UP;
}

main {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_MAIN;
}

 /** Palabras reservadas */
int {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_INT;
}
boolean {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_BOOLEAN;
}
array {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_ARRAY;
}
function {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_FUNCTION;
}
if {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_IF;
}
else {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_ELSE;
}
while {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_WHILE;
}
scanf {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_SCANF;
}
printf {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_PRINTF;
}
return {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_RETURN;
}


 /** Simbolos */
";" {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_PUNTOYCOMA;
}
"," {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_COMA;
}
"(" {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_PARENTESISIZQUIERDO;
}
")" {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_PARENTESISDERECHO;
}
"[" {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_CORCHETEIZQUIERDO;
}
"]" {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_CORCHETEDERECHO;
}
"{" {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_LLAVEIZQUIERDA;
}
"}" {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_LLAVEDERECHA;
}
"=" {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_ASIGNACION;
}
"+" {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_MAS;
}
"-" {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_MENOS;
}
"/" {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_DIVISION;
}
"*" {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_ASTERISCO;
}
"&&" {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_AND;
}
"||" {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_OR;
}

"!=" {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_DISTINTO;
}

"!" {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_NOT;
}
"==" {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_IGUAL;
}
"<=" {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_MENORIGUAL;
}
">=" {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_MAYORIGUAL;
}
"<" {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_MENOR;
}
">" {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_MAYOR;
}


"true" {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_TRUE;
}
"false" {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_FALSE;
}

[0-9]+ {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_CONSTANTE_ENTERA;
}

[a-zA-Z]+[a-zA-Z0-9]{100,} {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_ERROR_LONG;
}

[a-zA-Z]+[a-zA-Z0-9]{0,100} {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_IDENTIFICADOR;
}

 /** Errores */

. {
	fprintf(yyout,";D: %s",yytext);
 	return TOK_ERROR;
}


%%

