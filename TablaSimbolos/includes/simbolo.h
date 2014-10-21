#ifndef simbolo_H
#define simbolo_H

#include "errors.h"

typedef struct {
	char * key;
	short simbolo_type; /* VARIABLE or PARAMETER or FUNCTION */
	short data_type; /* INT or BOOLEAN*/
	short variable_type; /* ESCALAR or VECTOR */
	int size;	/* size of the vector */
	int num_parameter; /* just for functions */
	int pos_parameter; /* just for functions */
	int num_local_variables; /* just for functions */
	int pos_local_variables; /* just for functions */
}simbolo;


int initialize_simbolo(simbolo * simbolo);


#endif