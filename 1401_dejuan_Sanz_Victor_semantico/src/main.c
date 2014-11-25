#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#include "symbol_table.h"

#define MAX 150

#define JUMP "\n"
#define SPACE "        "

int main(int argc, char const *argv[])
{
	symbol_table * tabla = create_symbol_table();
	int ret_yyparse = -1;
	/* Close files and free memory used. */
	printf("Ola k ase\n");


//	ret_yyparse = yyparse();
	delete_symbol_table(tabla);
}
