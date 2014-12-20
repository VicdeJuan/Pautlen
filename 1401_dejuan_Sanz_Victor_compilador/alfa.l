 /** Codigo c que se copia integro */
%{

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "symbol_table.h"
#include "y.tab.h"

int column = 0;
int line = 1;
int error = 0;
extern FILE * logfile;
%}

 /** Opción de compilación:  Para decirle a flex que solo vamos a trabajar con 1 fichero */
%option noyywrap

%%


"//".* {

}

\r {

}

\n {
	column = 0;
	line +=1;
}

[ \t] {
	column +=1;
}



main {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_MAIN;
}

 /** Palabras reservadas */
int {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_INT;
}
boolean {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_BOOLEAN;
}
array {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_ARRAY;
}
"function" {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_FUNCTION;
}
if {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_IF;
}
else {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_ELSE;
}
while {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_WHILE;
}
scanf {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_SCANF;
}
printf {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_PRINTF;
}
return {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_RETURN;
}


 /** Simbolos */
";" {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return ';';
 }
"," {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return ',';
 }
"(" {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return '(';
 }
")" {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return ')';
 }
"[" {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return '[';
 }
"]" {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return ']';
 }
"{" {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return '{';
 }
"}" {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return '}';
 }
"=" {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return '=';
 }
"+" {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return '+';
	}
"-" {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return '-';
  	}
"/" {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return '/';
  	}
"*" {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return '*';
}
"&&" {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_AND;
}
"||" {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_OR;
}

"!=" {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_DISTINTO;
}

"!" {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return '!';
 }
"==" {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_IGUAL;
}
"<=" {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_MENORIGUAL;
}
">=" {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_MAYORIGUAL;
}
"<" {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return '<';
 }
">" {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return '>';
 }


"true" {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_TRUE;
}
"false" {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_FALSE;
}

[0-9]+ {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
	yylval.atributo.valor_entero = atoi(yytext);
 	return TOK_CONSTANTE_ENTERA;
}

[a-zA-Z]+[a-zA-Z0-9]{100,} {
	fprintf(logfile,";D:	%s\n",yytext);
	fprintf(ERROR_IFACE_MORFO,"****Error en [lin %d, col %d]: identificador demasiado largo (%s)\n",line,column,yytext);
 	error = 1;
 	return TOK_ERROR_LONG;
}

[a-zA-Z]+[a-zA-Z0-9]{0,100} {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	strcpy(yylval.atributo.lexema,yytext);
 	return TOK_IDENTIFICADOR;
}

 /** Errores */

. {
	fprintf(logfile,";D:	%s\n",yytext);
 	column += strlen(yytext);
	fprintf(ERROR_IFACE_MORFO,"****Error en [lin %d, col %d]: simbolo no permitido (%s)\n",line,column,yytext);
 	error = 1;
 	return TOK_ERROR;
}


%%

