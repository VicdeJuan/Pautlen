/******************************************************
Nombre: tokens.h
Descripción: Definición de tokens para el lenguaje ALFA
******************************************************/
#ifndef _TOKENS_H
#define _TOKENS_H


/* Palabras reservadas */ 
#define TOK_MAIN                100
#define TOK_INT                 101
#define TOK_BOOLEAN             102
#define TOK_ARRAY               103
#define TOK_FUNCTION            104
#define TOK_IF                  105
#define TOK_ELSE                106
#define TOK_WHILE               107
#define TOK_SCANF               108
#define TOK_PRINTF              109
#define TOK_RETURN              110


/* Símbolos */
#define TOK_PUNTOYCOMA          200
#define TOK_COMA                201
#define TOK_PARENTESISIZQUIERDO 202
#define TOK_PARENTESISDERECHO   203
#define TOK_CORCHETEIZQUIERDO   204
#define TOK_CORCHETEDERECHO     205
#define TOK_LLAVEIZQUIERDA      206
#define TOK_LLAVEDERECHA        207
#define TOK_ASIGNACION          208
#define TOK_MAS                 209
#define TOK_MENOS               210
#define TOK_DIVISION            211
#define TOK_ASTERISCO           212
#define TOK_AND                 213
#define TOK_OR                  214
#define TOK_NOT                 215
#define TOK_IGUAL               216
#define TOK_DISTINTO            217
#define TOK_MENORIGUAL          218
#define TOK_MAYORIGUAL          219
#define TOK_MENOR               220
#define TOK_MAYOR               221


/* Identificadores  */
#define TOK_IDENTIFICADOR       300

/* Constantes */ 

#define TOK_CONSTANTE_ENTERA    400
#define TOK_TRUE                401
#define TOK_FALSE               402

/* Errores */

#define TOK_ERROR 1
/* Mensajes */

#define TOK_MAIN_STR "TOK_MAIN %d %s"
#define TOK_INT_STR "TOK_INT %d %s"
#define TOK_BOOLEAN_STR "TOK_BOOLEAN %d %s"
#define TOK_ARRAY_STR "TOK_ARRAY %d %s"
#define TOK_FUNCTION_STR "TOK_FUNCTION %d %s"
#define TOK_IF_STR "TOK_IF %d %s"
#define TOK_ELSE_STR "TOK_ELSE %d %s"
#define TOK_WHILE_STR "TOK_WHILE %d %s"
#define TOK_SCANF_STR "TOK_SCANF %d %s"
#define TOK_PRINTF_STR "TOK_PRINTF %d %s"
#define TOK_RETURN_STR "TOK_RETURN %d %s"
#define TOK_PUNTOYCOMA_STR "TOK_PUNTOYCOMA %d %s"
#define TOK_COMA_STR "TOK_COMA %d %s"
#define TOK_PARENTESISIZQUIERDO_STR "TOK_PARENTESISIZQUIERDO %d %s"
#define TOK_PARENTESISDERECHO_STR "TOK_PARENTESISDERECHO %d %s"
#define TOK_CORCHETEIZQUIERDO_STR "TOK_CORCHETEIZQUIERDO %d %s"
#define TOK_CORCHETEDERECHO_STR "TOK_CORCHETEDERECHO %d %s"
#define TOK_LLAVEIZQUIERDA_STR "TOK_LLAVEIZQUIERDA %d %s"
#define TOK_LLAVEDERECHA_STR "TOK_LLAVEDERECHA %d %s"
#define TOK_ASIGNACION_STR "TOK_ASIGNACION %d %s"
#define TOK_MAS_STR "TOK_MAS %d %s"
#define TOK_MENOS_STR "TOK_MENOS %d %s"
#define TOK_DIVISION_STR "TOK_DIVISION %d %s"
#define TOK_ASTERISCO_STR "TOK_ASTERISCO %d %s"
#define TOK_AND_STR "TOK_AND %d %s"
#define TOK_OR_STR "TOK_OR %d %s"
#define TOK_NOT_STR "TOK_NOT %d %s"
#define TOK_IGUAL_STR "TOK_IGUAL %d %s"
#define TOK_DISTINTO_STR "TOK_DISTINTO %d %s"
#define TOK_MENORIGUAL_STR "TOK_MENORIGUAL %d %s"
#define TOK_MAYORIGUAL_STR "TOK_MAYORIGUAL %d %s"
#define TOK_MENOR_STR "TOK_MENOR %d %s"
#define TOK_MAYOR_STR "TOK_MAYOR %d %s"
#define TOK_IDENTIFICADOR_STR "TOK_IDENTIFICADOR %d %s"
#define TOK_CONSTANTE_ENTERA_STR "TOK_CONSTANTE_ENTERA %d %s"
#define TOK_TRUE_STR "TOK_TRUE %d %s"
#define TOK_FALSE_STR "TOK_FALSE %d %s"
#define TOK_ERROR_STR "TOK_ERROR %d %s"


#endif
