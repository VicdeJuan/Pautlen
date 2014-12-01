#include <stdio.h>
#include <stdlib.h>
#include <string.h>


#include "symbol_table.h"
#include "y.tab.h"

#define MAX 150

#define JUMP "\n"
#define SPACE "        "


int main(int argc, char const *argv[])
{
	int ret_yyparse = -1;
	/* Close files and free memory used. */
	printf("Ola k ase\n");

	if (ret_yyparse  == -1)
	{
		printf("Antes\n");
		printf("Despues\n");
	}
	yyparse();
}
