#ifndef simbolo_H
#define simbolo_H

#include "alfa.h"


typedef struct {
	char  key[MAX_LONG_ID+1];
	short symbol_type; /* VARIABLE or PARAMETER or FUNCTION */
	short data_type; /* INT or BOOLEAN*/
	short variable_type; /* ESCALAR or VECTOR */
	int size;	/* size of the vector */
	int num_parameter; /* just for functions */
	int pos_parameter; /* just for functions */
	int num_local_variables; /* just for functions */
	int pos_local_variables; /* just for functions */
	int local_identifier;
}symbol;


int initialize_simbolo(symbol * simbolo);


#endif