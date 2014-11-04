%{
#include <stdio.h>
#include "y.tab.h"
#define print_token(MAC) { fprintf(stdout, "%s: %s", #MAC, yytext) }
%}
%option noyywrap

DEFARTICULO el|la|los|las
DEFNOMBRE yo|tú|chico|chica|chicos|chicas|manzanas|carne|casa 
DEFVERBO  como|comes|come|comen 
DEFPREPOSICION en|de 


%%


{DEFARTICULO} {
	print_token(ARTICULO);
	return ARTICULO;
} 

{DEFNOMBRE} {
	print_token(NOMBRE);
	return NOMBRE;
}

{DEFPREPOSICION} {
	print_token(PREPOSICION);
	return PREPOSICION;
}

{DEFVERBO} {
	print_token(VERBO);
	return VERBO;
}

"." {
	fprintf(stdout,"SEPARADOR ORACIONES .");
	return '.';
}

. {
	
} 


%%