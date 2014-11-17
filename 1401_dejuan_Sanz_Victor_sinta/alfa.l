 /** Codigo c que se copia integro */
%{

#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "y.tab.h"
#define ERROR_IFACE_MORFO stderr

int column = 0;
int line = 1;
int error = 0;
%}

 /** Opción de compilación:  Para decirle a flex que solo vamos a trabajar con 1 fichero */
%option noyywrap

%%


"//".* {
	column = 0;

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
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_MAIN;
}

 /** Palabras reservadas */
int {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_INT;
}
boolean {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_BOOLEAN;
}
array {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_ARRAY;
}
"function" {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_FUNCTION;
}
if {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_IF;
}
else {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_ELSE;
}
while {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_WHILE;
}
scanf {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_SCANF;
}
printf {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_PRINTF;
}
return {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_RETURN;
}


 /** Simbolos */
";" {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return ';';
 }
"," {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return ',';
 }
"(" {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return '(';
 }
")" {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return ')';
 }
"[" {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return '[';
 }
"]" {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return ']';
 }
"{" {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return '{';
 }
"}" {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return '}';
 }
"=" {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return '=';
 }
"+" {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return '+';
	}
"-" {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return '-';
  	}
"/" {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return '/';
  	}
"*" {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return '*';
}
"&&" {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_AND;
}
"||" {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_OR;
}

"!=" {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_DISTINTO;
}

"!" {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return '!';
 }
"==" {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_IGUAL;
}
"<=" {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_MENORIGUAL;
}
">=" {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_MAYORIGUAL;
}
"<" {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return '<';
 }
">" {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return '>';
 }


"true" {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_TRUE;
}
"false" {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_FALSE;
}

[0-9]+ {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_CONSTANTE_ENTERA;
}

[a-zA-Z]+[a-zA-Z0-9]{100,} {
	fprintf(yyout,";D:	%s\n",yytext);
	fprintf(ERROR_IFACE_MORFO,"****Error en [lin %d, col %d]: identificador demasiado largo (%s)\n",line,column,yytext);
 	error = 1;
 	return TOK_ERROR_LONG;
}

[a-zA-Z]+[a-zA-Z0-9]{0,100} {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
 	return TOK_IDENTIFICADOR;
}

 /** Errores */

. {
	fprintf(yyout,";D:	%s\n",yytext);
 	column += strlen(yytext);
	fprintf(ERROR_IFACE_MORFO,"****Error en [lin %d, col %d]: simbolo no permitido (%s)\n",line,column,yytext);
 	error = 1;
 	return TOK_ERROR;
}


%%

