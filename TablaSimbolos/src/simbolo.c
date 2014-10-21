#include "simbolo.h"

#include <stdlib.h>

int initialize_simbolo(simbolo * simbolo){
	if (simbolo == NULL)
		return ERR;
	
	simbolo->simbolo_type = 0; /* VARIABLE or PARAMETER or FUNCTION */
	simbolo->data_type = 0; /* INT or BOOLEAN*/
	simbolo->variable_type = 0; /* ESCALAR or VECTOR */
	simbolo->size = 0;
	simbolo->num_parameter = 0; /* just for functions */
	simbolo->pos_parameter = 0; /* just for functions */
	simbolo->num_local_variables = 0; /* just for functions */
	simbolo->pos_local_variables = 0; /* just for functions */
	return OK;
}

