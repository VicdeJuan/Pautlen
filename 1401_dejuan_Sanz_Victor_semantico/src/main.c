#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#include "symbol_table.h"
#include "y.tab.h"

#define MAX 150

#define JUMP "\n"
#define SPACE "        "

extern FILE * yyin;
extern FILE * yyout;

int main(int argc, char const *argv[])
{
	int ret_yyparse = -1;
	/* Close files and free memory used. */
	yyin = fopen(argv[1],"r");
	yyout = stderr;
	//yyout = fopen(argv[2],"w");
	fprintf(stderr, "\n\n\n\n\t\t\tFichero %s\n", argv[1]);
	yyparse();
}
