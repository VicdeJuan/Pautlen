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

typedef struct{
	char lexema[MAX_LONG_ID+1];
	int tipo;
	int valor_entero;
	int es_direccion;
	int etiqueta;
}tipo_atributos;

#endif
