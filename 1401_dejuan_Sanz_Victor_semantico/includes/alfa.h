#ifndef _ALFA_H
#define _ALFA_H

#include "errors.h"


#define ERROR_IFACE_SINTA stderr
#define ERROR_IFACE_MORFO stderr

#define NONE -1

#define LOCAL 0
#define GLOBAL 1

#define VARIABLE 1
#define PARAMETER 2
#define FUNCTION 3

#define INT 1
#define BOOLEAN 2

#define ESCALAR 1
#define VECTOR 2

#define MAX_TAMANIO_VECTOR 64

#define MAX_LONG_ID 100
 


#define SEM_ERROR_ALREADY_DEF "Error semántico: %s ya se encuentra definido"
#define SEM_ERROR_VECTOR_SIZE "Error semántico: Vector demasiado grande (64 es el máximo)"
#define SEM_ERROR_JUST_ESCALAR_IN_LOCAL "Error semántico: Sólo se pueden definir variables escalares en funciones."



#define SEM_ERROR_INCOMPATIBLE_TYPES "Error semántico: Tipos incompatibles (%s) y (%s) [expected INT, INT]."
#define SEM_ERROR_INCOMPATIBLE_TYPE "Error semántico: Tipo incompatible (%s) [expected INT]"

#define CHECK_BOOLEAN_TYPES "if ($1.tipo == BOOLEAN && $3.tipo == BOOLEAN){ $$.tipo = BOOLEAN; $$.es_direccion = 0;}else{char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));sprintf(err_msg, SEM_ERROR_INCOMPATIBLE_TYPES ,$1.tipo==BOOLEAN ? \"BOOLEAN\" : \"INT\", $3.tipo == BOOLEAN ? \"BOOLEAN\" : \"INT\");print_sem_error(err_msg);free(err_msg);}"
#define CHECK_BOOLEAN_TYPE "if ($2.tipo == BOOLEAN){ $$.tipo = BOOLEAN; $$.es_direccion = 0;}else{char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));sprintf(err_msg, SEM_ERROR_INCOMPATIBLE_TYPE ,$2.tipo==BOOLEAN ? \"BOOLEAN\" : \"INT\");print_sem_error(err_msg);free(err_msg);}"

#define CHECK_INT_TYPES "if ($1.tipo == INT && $3.tipo == INT){ $$.tipo = INT; $$.es_direccion = 0;}else{char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));sprintf(err_msg, SEM_ERROR_INCOMPATIBLE_TYPES ,$1.tipo==INT ? \"INT\" : \"BOOLEAN\", $3.tipo == INT ? \"INT\" : \"BOOLEAN\");print_sem_error(err_msg);free(err_msg);}"
#define CHECK_INT_TYPE "if ($2.tipo == INT){ $$.tipo = INT; $$.es_direccion = 0;}else{char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));sprintf(err_msg, SEM_ERROR_INCOMPATIBLE_TYPE ,$2.tipo==INT ? \"INT\" : \"BOOLEAN\");print_sem_error(err_msg);free(err_msg);}"




#define CHECK_SAME_TYPES "if ($1.tipo == $3.tipo && $1.es_direccion == $3.es_direccion){ $$.tipo = $1.tipo; $$.es_direccion = $1.es_direccion; } else{ char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char)); sprintf(err_msg, SEM_ERROR_INCOMPATIBLE_TYPES ,$1.tipo == INT ? \"INT\" : \"BOOLEAN\", $3.tipo == INT ? \"INT\" : \"BOOLEAN\"); print_sem_error(err_msg); free(err_msg); }"

typedef struct{
	char lexema[MAX_LONG_ID+1];
	int tipo;
	int valor_entero;
	int es_direccion;
	int etiqueta;
}tipo_atributos;

#endif
