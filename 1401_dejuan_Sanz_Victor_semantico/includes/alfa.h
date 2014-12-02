#ifndef _ALFA_H
#define _ALFA_H

#include "errors.h"


#define ERROR_IFACE_SINTA stderr
#define ERROR_IFACE_MORFO stderr

#define NONE -1

#define LOCAL 0
#define GLOBAL 1

/* symbol_type */
#define VARIABLE 1
#define PARAMETER 2
#define FUNCTION 3

/* Tipo */
#define INT 1
#define BOOLEAN 2

/* Clase */
#define ESCALAR 1
#define VECTOR 2

#define MAX_TAMANIO_VECTOR 64

#define MAX_LONG_ID 100
 


#define SEM_ERROR_ALREADY_DEF "Error semántico: %s ya se encuentra definido"
#define SEM_ERROR_NOT_DEFINED "Error semántico: %s no se encuentra definido"
#define SEM_ERROR_VECTOR_SIZE "Error semántico: Vector demasiado grande (64 es el máximo)"
#define SEM_ERROR_JUST_ESCALAR_IN_LOCAL "Error semántico: Sólo se pueden definir variables escalares en funciones."

#define SEM_ERROR_FUNCTION_NOT_ALLOWED "Error semántico: No se permite una función (%s)."
#define SEM_ERROR_NOT_FUNCTION "Error semántico: %s no es una función."

#define SEM_ERROR_INCOMPATIBLE_TYPES "Error semántico: Tipos incompatibles (%s) y (%s) [expected INT, INT]."
#define SEM_ERROR_INCOMPATIBLE_TYPE "Error semántico: Tipo incompatible (%s) [expected INT]"


#define SEM_ERROR_NEED_MORE_PARAM "Insuficientes paramatros en (%s). Esperados: %d, recibidos: %d"
#define SEM_ERROR_TOO_MUCH_PARAM "Demasiados paramatros en (%s). Esperados: %d, recibidos: %d"


#define SEM_ERROR_FATAL "FATAL: (%s) No propagado."




#define CHECK_BOOLEAN_TYPES(dd,d1,d3) if (d1.tipo == BOOLEAN && d3.tipo == BOOLEAN){ dd.tipo = BOOLEAN; dd.es_direccion = 0;}else{char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));sprintf(err_msg, SEM_ERROR_INCOMPATIBLE_TYPES ,d1.tipo==BOOLEAN ? "BOOLEAN" : "INT", d3.tipo == BOOLEAN ? "BOOLEAN" : "INT");print_sem_error(err_msg);free(err_msg);}
#define CHECK_BOOLEAN_TYPE(dd,d2) if (d2.tipo == BOOLEAN){ dd.tipo = BOOLEAN; dd.es_direccion = 0;}else{char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));sprintf(err_msg, SEM_ERROR_INCOMPATIBLE_TYPE ,d2.tipo==BOOLEAN ? "BOOLEAN" : "INT");print_sem_error(err_msg);free(err_msg);}

#define CHECK_INT_TYPES(dd,d1,d3) if (d1.tipo == INT && d3.tipo == INT){ dd.tipo = INT; dd.es_direccion = 0;}else{char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));sprintf(err_msg, SEM_ERROR_INCOMPATIBLE_TYPES ,d1.tipo==INT ? "INT" : "BOOLEAN", d3.tipo == INT ? "INT" : "BOOLEAN");print_sem_error(err_msg);free(err_msg);}
#define CHECK_INT_TYPE(dd,d2) if (d2.tipo == INT){ dd.tipo = INT; dd.es_direccion = 0;}else{char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));sprintf(err_msg, SEM_ERROR_INCOMPATIBLE_TYPE ,d2.tipo==INT ? "INT" : "BOOLEAN");print_sem_error(err_msg);free(err_msg);}


#define CHECK_IDENT_DEFINED(d1) symbol * sim = search_symbol(tabla,$.lexema,ambito_actual); if (!sim){	char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));	sprintf(err_msg, SEM_ERROR_NOT_DEFINED ,d1.lexema);	print_sem_error(err_msg);free(err_msg);}
#define CHECK_IDENT_NOT_DEFINED(d1) symbol * sim = search_symbol(tabla,$.lexema,ambito_actual); if (sim){	char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));	sprintf(err_msg, SEM_ERROR_ALREADY_DEF ,d1.lexema);	print_sem_error(err_msg);free(err_msg);}



#define CHECK_SAME_TYPES "if ($1.tipo == $3.tipo && $1.es_direccion == $3.es_direccion){ $$.tipo = $1.tipo; $$.es_direccion = $1.es_direccion; } else{ char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char)); sprintf(err_msg, SEM_ERROR_INCOMPATIBLE_TYPES ,$1.tipo == INT ? \"INT\" : \"BOOLEAN\", $3.tipo == INT ? \"INT\" : \"BOOLEAN\"); print_sem_error(err_msg); free(err_msg); }"

typedef struct{
	char lexema[MAX_LONG_ID+1];
	int tipo;
	int valor_entero;
	int es_direccion;
	int etiqueta;
}tipo_atributos;

/*typedef struct {
	char  key[MAX_LONG_ID+1];
	short symbol_type;  VARIABLE or PARAMETER or FUNCTION 
	short data_type;  INT or BOOLEAN
	short variable_type;  ESCALAR or VECTOR 
	int size;	 size of the vector 
	int num_parameter;  just for functions 
	int pos_parameter;  just for functions 
	int num_local_variables;  just for functions 
	int pos_local_variables;  just for functions 
	int local_identifier;
}symbol;
*/

#endif
/*


	symbol * sim = search_symbol(tabla,$1.lexema,ambito_actual);
	if (!sim)
	{

	}
	else{
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		sprintf(err_msg, SEM_ERROR_ALREADY_DEF ,$1.lexema);
		print_sem_error(err_msg);
		free(err_msg);
	}
*/

