 /** Codigo c que se copia integro */
%{
#include "includes/tokens.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

%}

 /** Opción de compilación:  Para decirle a flex que solo vamos a trabajar con 1 fichero */
%option noyywrap

%%


"//".* {
	return TOK_LINE_UP;

}
\n {
	return TOK_JUMP;
}

[ \t] {
	return TOK_COL_UP;
}

main {
 	 return TOK_MAIN;
}

 /** Palabras reservadas */
int {
 	 return TOK_INT;
}
boolean {
 	 return TOK_BOOLEAN;
}
array {
 	 return TOK_ARRAY;
}
function {
 	 return TOK_FUNCTION;
}
if {
 	 return TOK_IF;
}
else {
 	 return TOK_ELSE;
}
while {
 	 return TOK_WHILE;
}
scanf {
 	 return TOK_SCANF;
}
printf {
 	 return TOK_PRINTF;
}
return {
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
"<=" {
 	 return TOK_MENORIGUAL;
}
">=" {
 	 return TOK_MAYORIGUAL;
}
"<" {
 	 return TOK_MENOR;
}
">" {
 	 return TOK_MAYOR;
}


"true" {
 	 return TOK_TRUE;
}
"false" {
 	 return TOK_FALSE;
}

[0-9]+ {
 	 return TOK_CONSTANTE_ENTERA;
}

[a-zA-Z]+[a-zA-Z0-9]{100,} {
 	 return TOK_ERROR_LONG;
}

[a-zA-Z]+[a-zA-Z0-9]{0,100} {
 	 return TOK_IDENTIFICADOR;
}

 /** Errores */
. {
 	 return TOK_ERROR;
}


%%

int print_all(int aux,int * line, int * column);



int main(int argc , char ** argv){

	int aux,line = 1,column = 1;

	if(argc >= 1){
		yyin = fopen(argv[1],"r");
	}
	else return 0;

	if(argc >= 2){
		yyout = fopen(argv[2],"w");
	}else{
		yyout = stdout;
	}

	if (yyin != NULL)
	{
		aux = yylex();
		while (aux != 0)
		{
			print_all(aux,&line,&column);		
			aux = yylex();
			
		}
	}
	return 0;
}

int print_all(int aux,int * line, int * column){
	switch (aux){
			case TOK_LINE_UP:
				break;
			case TOK_COL_UP:
				*column+=1;
				break;
			case TOK_MAIN:
				fprintf(yyout,TOK_MAIN_STR,TOK_MAIN,yytext);
				*column += strlen(yytext);
			break;
			case TOK_INT:
				fprintf(yyout,TOK_INT_STR,TOK_INT,yytext);
				*column += strlen(yytext);
			break;
			case TOK_BOOLEAN:
				fprintf(yyout,TOK_BOOLEAN_STR,TOK_BOOLEAN,yytext);
				*column += strlen(yytext);
			break;
			case TOK_ARRAY:
				fprintf(yyout,TOK_ARRAY_STR,TOK_ARRAY,yytext);
				*column += strlen(yytext);
			break;
			case TOK_FUNCTION:
				fprintf(yyout,TOK_FUNCTION_STR,TOK_FUNCTION,yytext);
				*column += strlen(yytext);
			break;
			case TOK_IF:
				fprintf(yyout,TOK_IF_STR,TOK_IF,yytext);
				*column += strlen(yytext);
			break;
			case TOK_ELSE:
				fprintf(yyout,TOK_ELSE_STR,TOK_ELSE,yytext);
				*column += strlen(yytext);
			break;
			case TOK_WHILE:
				fprintf(yyout,TOK_WHILE_STR,TOK_WHILE,yytext);
				*column += strlen(yytext);
			break;
			case TOK_SCANF:
				fprintf(yyout,TOK_SCANF_STR,TOK_SCANF,yytext);
				*column += strlen(yytext);
			break;
			case TOK_PRINTF:
				fprintf(yyout,TOK_PRINTF_STR,TOK_PRINTF,yytext);
				*column += strlen(yytext);
			break;
			case TOK_RETURN:
				fprintf(yyout,TOK_RETURN_STR,TOK_RETURN,yytext);
				*column += strlen(yytext);
			break;
			case TOK_PUNTOYCOMA:
				fprintf(yyout,TOK_PUNTOYCOMA_STR,TOK_PUNTOYCOMA,yytext);
				*column += strlen(yytext);
			break;
			case TOK_COMA:
				fprintf(yyout,TOK_COMA_STR,TOK_COMA,yytext);
				*column += strlen(yytext);
			break;
			case TOK_PARENTESISIZQUIERDO:
				fprintf(yyout,TOK_PARENTESISIZQUIERDO_STR,TOK_PARENTESISIZQUIERDO,yytext);
				*column += strlen(yytext);
			break;
			case TOK_PARENTESISDERECHO:
				fprintf(yyout,TOK_PARENTESISDERECHO_STR,TOK_PARENTESISDERECHO,yytext);
				*column += strlen(yytext);
			break;
			case TOK_CORCHETEIZQUIERDO:
				fprintf(yyout,TOK_CORCHETEIZQUIERDO_STR,TOK_CORCHETEIZQUIERDO,yytext);
				*column += strlen(yytext);
			break;
			case TOK_CORCHETEDERECHO:
				fprintf(yyout,TOK_CORCHETEDERECHO_STR,TOK_CORCHETEDERECHO,yytext);
				*column += strlen(yytext);
			break;
			case TOK_LLAVEIZQUIERDA:
				fprintf(yyout,TOK_LLAVEIZQUIERDA_STR,TOK_LLAVEIZQUIERDA,yytext);
				*column += strlen(yytext);
			break;
			case TOK_LLAVEDERECHA:
				fprintf(yyout,TOK_LLAVEDERECHA_STR,TOK_LLAVEDERECHA,yytext);
				*column += strlen(yytext);
			break;
			case TOK_ASIGNACION:
				fprintf(yyout,TOK_ASIGNACION_STR,TOK_ASIGNACION,yytext);
				*column += strlen(yytext);
			break;
			case TOK_MAS:
				fprintf(yyout,TOK_MAS_STR,TOK_MAS,yytext);
				*column += strlen(yytext);
			break;
			case TOK_MENOS:
				fprintf(yyout,TOK_MENOS_STR,TOK_MENOS,yytext);
				*column += strlen(yytext);
			break;
			case TOK_DIVISION:
				fprintf(yyout,TOK_DIVISION_STR,TOK_DIVISION,yytext);
				*column += strlen(yytext);
			break;
			case TOK_ASTERISCO:
				fprintf(yyout,TOK_ASTERISCO_STR,TOK_ASTERISCO,yytext);
				*column += strlen(yytext);
			break;
			case TOK_AND:
				fprintf(yyout,TOK_AND_STR,TOK_AND,yytext);
				*column += strlen(yytext);
			break;
			case TOK_OR:
				fprintf(yyout,TOK_OR_STR,TOK_OR,yytext);
				*column += strlen(yytext);
			break;
			case TOK_NOT:
				fprintf(yyout,TOK_NOT_STR,TOK_NOT,yytext);
				*column += strlen(yytext);
			break;
			case TOK_IGUAL:
				fprintf(yyout,TOK_IGUAL_STR,TOK_IGUAL,yytext);
				*column += strlen(yytext);
			break;
			case TOK_DISTINTO:
				fprintf(yyout,TOK_DISTINTO_STR,TOK_DISTINTO,yytext);
				*column += strlen(yytext);
			break;
			case TOK_MENORIGUAL:
				fprintf(yyout,TOK_MENORIGUAL_STR,TOK_MENORIGUAL,yytext);
				*column += strlen(yytext);
			break;
			case TOK_MAYORIGUAL:
				fprintf(yyout,TOK_MAYORIGUAL_STR,TOK_MAYORIGUAL,yytext);
				*column += strlen(yytext);
			break;
			case TOK_MENOR:
				fprintf(yyout,TOK_MENOR_STR,TOK_MENOR,yytext);
				*column += strlen(yytext);
			break;
			case TOK_MAYOR:
				fprintf(yyout,TOK_MAYOR_STR,TOK_MAYOR,yytext);
				*column += strlen(yytext);
			break;
			case TOK_IDENTIFICADOR:
				fprintf(yyout,TOK_IDENTIFICADOR_STR,TOK_IDENTIFICADOR,yytext);
				*column += strlen(yytext);
			break;
			case TOK_CONSTANTE_ENTERA:
				fprintf(yyout,TOK_CONSTANTE_ENTERA_STR,TOK_CONSTANTE_ENTERA,yytext);
				*column += strlen(yytext);
			break;
			case TOK_TRUE:
				fprintf(yyout,TOK_TRUE_STR,TOK_TRUE,yytext);
				*column += strlen(yytext);
			break;
			case TOK_FALSE:
				fprintf(yyout,TOK_FALSE_STR,TOK_FALSE,yytext);
				*column += strlen(yytext);
			break;
			case TOK_JUMP:
				*line +=1;
				*column = 1;
			break;
			case TOK_ERROR_LONG:
				fprintf(yyout,"****Error en [lin %d, col %d]: identificador demasiado largo (%s)\n",*line,*column,yytext);
				*column += strlen(yytext);
				fprintf(yyout,TOK_ERROR_STR,TOK_ERROR,yytext);
			break;	
			default:
				fprintf(yyout,"****Error en [lin %d, col %d]: simbolo no permitido (%s)\n",*line,*column,yytext);
				*column += strlen(yytext);
				fprintf(yyout,TOK_ERROR_STR,TOK_ERROR,yytext);
		}
		return 0;
}