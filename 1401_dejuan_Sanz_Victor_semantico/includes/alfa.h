#ifndef _ALFA_H
#define _ALFA_H

#include "errors.h"

#define MAX_LONG_ID 100
#define MAX_SIZE_VECTOR 64

#define ERROR_IFACE_SINTA stderr
#define ERROR_IFACE_MORFO stderr
 
#define ESCALAR 1
#define VECTOR 2

#define INT 1
#define BOOLEAN 2

#define VARIABLE 1
#define PARAMETER 2
#define FUNCTION 3


typedef struct{
	char lexema[MAX_LONG_ID+1];
	int tipo;
	int valor_entero;
	int es_direccion;
	int etiqueta;
}tipo_atributos;

#endif
