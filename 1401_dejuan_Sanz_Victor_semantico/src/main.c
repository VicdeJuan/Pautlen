#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#include "symbol_table.h"
#include "y.tab.h"
#include "lex.yy.h"

#define MAX 150

#define JUMP "\n"
#define SPACE "        "

extern FILE * yyin;
extern FILE * yyout;


int main(int argc, char const *argv[])
{
	/* Close files and free memory used. */

	if (argc == 1){
		fprintf(stderr, "Error en los parámetros de entrada.\n");
		return 0;
	}


	yyin = fopen(argv[1],"r");
	if (argc >= 2)
		yyout = fopen(argv[2],"w");
	else
		yyout = stderr;
	
	if (argc < 2)
		fprintf(stderr, "\n\n\n\n\t\t\tFichero %s\n", argv[1]);
	
	yyparse();
}
