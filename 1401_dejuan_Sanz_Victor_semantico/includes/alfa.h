#ifndef _ALFA_H
#define _ALFA_H

#include "errors.h"

#define LOGFILE "log"

#define ERROR_IFACE_SINTA stderr
#define ERROR_IFACE_MORFO stderr
#define ERROR_IFACE_SEMAN stderr

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
 
#define NASM_FILE_NAME "alfa.asm"


#define SEM_ERROR__RET_INCOMPATIBLE_TYPES "Retorno incompatible. (no de la lista)"

#define SEM_ERROR__VECTOR_SIZE "El tamanyo del vector %s excede los limites permitidos (1,64)"
#define SEM_ERROR__MISSING_RET "Funcion %s sin sentencia de retorno."

#define SEM_ERROR__ALREADY_DEF "Declaracion duplicada."
#define SEM_ERROR__VAR_NOT_DEFINED "Acceso a variable no declarada (%s)."
#define SEM_ERROR__FUN_NOT_DEFINED "Funcion no declarada (%s)."
#define SEM_ERROR__JUST_ESCALAR_IN_LOCAL "Variable local de tipo no escalar."

#define SEM_ERROR__FUNCTION_NOT_ALLOWED_AS_ARG "No esta permitido el uso de llamadas a funciones como parametros de otras funciones."
#define SEM_ERROR__NOT_FUNCTION "%s no es una función. (no de la lista)"

#define SEM_ERROR__LOCAL_NOT_ESCALAR "Variable local de tipo no escalar."
#define SEM_ERROR__ASIG_INCOMPATIBLE_TYPES "Asignacion incompatible."
#define SEM_ERROR__NEED_MORE_PARAM "Numero incorrecto de parametros en llamada a funcion."
#define SEM_ERROR__TOO_MUCH_PARAM "Numero incorrecto de parametros en llamada a funcion."
#define SEM_ERROR__FATAL "FATAL: (%s) No propagado."
#define SEM_ERROR__INTEGER_INDEX "El indice en una operacion de indexacion tiene que ser de tipo entero."
#define SEM_ERROR__MISPLACED_RET "Sentencia de retorno fuera del cuerpo de una función."


/* Faltan */
#define SEM_ERROR__ARIT_WITH_BOOL "Operacion aritmetica con operandos boolean."
#define SEM_ERROR__LOGIC_WITH_INT "Operacion logica con operandos int."
#define SEM_ERROR__COMPARE_WITH_BOOL "Comparacion con operandos boolean."
#define SEM_ERROR__CONDITION_WITH_INT "Condicional con condicion de tipo int."
#define SEM_ERROR__LOOP_WITH_INT "Bucle con condicion de tipo int."


/** A revisar  */
#define SEM_ERROR__NOT_VECTOR "Intento de indexacion de una variable que no es de tipo vector."
#define SEM_ERROR__NOT_VARIABLE "No es una variable (no de la lista)"
#define SEM_ERROR__NOT_ESCALAR "No es escalar (no de la lista)"
#define SEM_ERROR__INCOMPATIBLE_TYPES  "Tipos incompatibles."
#define SEM_ERROR__INCOMPATIBLE_TYPE "Tipo incompatible."


#define CHECK_BOOLEAN_TYPES(dd,d1,d3)  if (d1.tipo == BOOLEAN && d3.tipo == BOOLEAN){\
		dd.tipo = BOOLEAN; dd.es_direccion = 0;\
	}else{\
		sprintf(err_msg, SEM_ERROR__LOGIC_WITH_INT);\
		print_sem_error(err_msg);\
	}
#define CHECK_BOOLEAN_TYPE(dd,d2,msg)  if (d2.tipo == BOOLEAN){\
		dd.tipo = BOOLEAN; dd.es_direccion = 0;\
	}else{\
		sprintf(err_msg, msg);\
		print_sem_error(err_msg);\
		free(err_msg);\
	}

#define CHECK_INT_TYPES(dd,d1,d3,msg)  if (d1.tipo == INT && d3.tipo == INT){\
		dd.tipo = INT; dd.es_direccion = 0;\
	}else{\
		sprintf(err_msg, msg);\
		print_sem_error(err_msg);\
	}

#define CHECK_INT_TYPE(dd,d2)  if (d2.tipo == INT){\
		dd.tipo = INT; dd.es_direccion = 0;\
	}else{\
		sprintf(err_msg, SEM_ERROR__ARIT_WITH_BOOL);\
		print_sem_error(err_msg);free(err_msg);\
	}


#define CHECK_IDENT_DEFINED(d1,var) sim = search_symbol(tabla,d1.lexema,ambito_actual);\
	if (!sim){\
		if (var) sprintf(err_msg, SEM_ERROR__VAR_NOT_DEFINED ,d1.lexema);\
		else sprintf(err_msg,SEM_ERROR__FUN_NOT_DEFINED,d1.lexema);\
		print_sem_error(err_msg);\
		free(err_msg);\
	}
#define CHECK_IDENT_NOT_DEFINED(d1) sim = search_symbol(tabla,d1.lexema,ambito_actual);\
	if (sim){\
	 	sprintf(err_msg, SEM_ERROR__ALREADY_DEF);\
	 	print_sem_error(err_msg);\
	 	free(err_msg);\
	}

#define GET_STR_FROM_TYPE(d1) d1 == INT ? "INT" : "BOOLEAN"

#define CHECK_SAME_TYPES(dd,d1,d3)  if (d1.tipo == d3.tipo ){\
	 dd.tipo = d1.tipo;\
	 dd.es_direccion = d1.es_direccion;\
	 }else{\
	 sprintf(err_msg, SEM_ERROR__INCOMPATIBLE_TYPES);\
	 print_sem_error(err_msg); \
	}


#define CHECK_IS_VARIABLE(d1) if (sim->symbol_type != VARIABLE){\
		sprintf(err_msg,SEM_ERROR__NOT_VARIABLE);\
		print_sem_error(err_msg);\
	}
#define CHECK_IS_FUNCTION(d1) if (sim->symbol_type != FUNCTION){\
		sprintf(err_msg,SEM_ERROR__NOT_FUNCTION,d1);\
		print_sem_error(err_msg);\
	}
#define CHECK_IS_VECTOR(d1) if (sim->variable_type != VECTOR){\
		sprintf(err_msg,SEM_ERROR__NOT_VECTOR);\
		print_sem_error(err_msg);\
	}
#define CHECK_IS_ESCALAR(d1) if (sim->variable_type != ESCALAR){\
		sprintf(err_msg,SEM_ERROR__NOT_ESCALAR);\
		print_sem_error(err_msg);\
	}

#define CHECK_IS_NOT_VARIABLE(d1) if (sim->symbol_type == VARIABLE){\
		sprintf(err_msg,SEM_ERROR__NOT_VARIABLE);\
		print_sem_error(err_msg);\
	}
#define CHECK_IS_NOT_FUNCTION(d1) if (sim->symbol_type == FUNCTION){\
		sprintf(err_msg,SEM_ERROR__NOT_FUNCTION,d1);\
		print_sem_error(err_msg);\
	}
#define CHECK_IS_NOT_VECTOR(d1) if (sim->variable_type == VECTOR){\
		sprintf(err_msg,SEM_ERROR__NOT_VECTOR);\
		print_sem_error(err_msg);\
	}
#define CHECK_IS_NOT_ESCALAR(d1) if (sim->variable_type == ESCALAR){\
		sprintf(err_msg,SEM_ERROR__NOT_ESCALAR);\
		print_sem_error(err_msg);\
	}

typedef struct{
	char lexema[MAX_LONG_ID+1];
	int tipo;
	int valor_entero;
	int es_direccion;
	int etiqueta;
	int hay_retorno;
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
		
		sprintf(err_msg, SEM_ERROR_ALREADY_DEF ,$1.lexema);
		print_sem_error(err_msg);
		free(err_msg);
	}
*/

