#include "y.tab.h"
#include "lex.yy.h"
#include <stdlib.h>
#include <stdio.h>

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

	return	yyparse();

}