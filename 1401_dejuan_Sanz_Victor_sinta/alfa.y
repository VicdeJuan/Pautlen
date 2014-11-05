%{
	#include <stdio.h>
	#include <stdlib.h>
%}

%token TOK_MAIN
%token TOK_INT
%token TOK_BOOLEAN
%token TOK_ARRAY
%token TOK_FUNCTION
%token TOK_IF
%token TOK_ELSE
%token TOK_WHILE
%token TOK_SCANF
%token TOK_PRINTF
%token TOK_RETURN
%token TOK_PUNTOYCOMA
%token TOK_COMA
%token TOK_PARENTESISIZQUIERDO
%token TOK_PARENTESISDERECHO
%token TOK_CORCHETEIZQUIERDO
%token TOK_CORCHETEDERECHO
%token TOK_LLAVEIZQUIERDA
%token TOK_LLAVEDERECHA
%token TOK_ASIGNACION
%token TOK_MAS
%token TOK_MENOS
%token TOK_DIVISION
%token TOK_ASTERISCO
%token TOK_AND
%token TOK_OR
%token TOK_NOT
%token TOK_IGUAL
%token TOK_DISTINTO
%token TOK_MENORIGUAL
%token TOK_MAYORIGUAL
%token TOK_MENOR
%token TOK_MAYOR
%token TOK_IDENTIFICADOR
%token TOK_CONSTANTE_ENTERA
%token TOK_TRUE
%token TOK_FALSE
%token TOK_JUMP
%token TOK_LINE_UP
%token TOK_COL_UP
%token TOK_ERROR
%token TOK_ERROR_LONG

%start texto

%%
 
programa : main TOK_LLAVEIZQUIERDA declaraciones funciones sentencias TOK_LLAVEDERECHA { printf(";R1	<programa> ::= main TOK_LLAVEIZQUIERDA <declaraciones> <funciones> <sentencias> TOK_LLAVEDERECHA\n"); }
	;
declaraciones : declaracion  { printf(";R2	<declaraciones> ::= <declaracion>\n"); }
	| declaracion declaraciones  { printf(";R2	<declaraciones> ::= <declaracion> <declaraciones>\n"); }
	;
declaracion : clase identificadores TOK_PUNTOYCOMA  { printf(";R2	<declaracion> ::= <clase> <identificadores> TOK_PUNTOYCOMA\n"); }
	;
clase : clase_escalar  { printf(";R5	<clase> ::= <clase_escalar>\n"); }
	| clase_vector  { printf(";R5	<clase> ::= <clase_vector>\n"); }
	;
clase_escalar : tipo  { printf(";R9	<clase_escalar> ::= <tipo>\n"); }
	;
tipo : TOK_INT  { printf(";R10	<tipo> ::= TOK_INT\n"); }
	| TOK_BOOLEAN { printf(";R10	<tipo> ::= TOK_BOOLEAN\n"); }
	;
clase_vector : TOK_ARRAY tipo TOK_CORCHETEIZQUIERDO constante_entera  TOK_CORCHETEDERECHO { printf(";R15	<clase_vector> ::= TOK_ARRAY <tipo> TOK_CORCHETEIZQUIERDO <constante_entera>  TOK_CORCHETEDERECHO\n"); }
	;
identificadores : identificador  { printf(";R18	<identificadores> ::= <identificador>\n"); }
	| identificador TOK_COMA identificadores  { printf(";R18	<identificadores> ::= <identificador> TOK_COMA <identificadores>\n"); }
	;
funciones : funcion funciones  { printf(";R20	<funciones> ::= <funcion> <funciones>\n"); }
	|  { printf(";R20	<funciones> ::= \n"); }
	;
funcion : function tipo identificador TOK_PARENTESISIZQUIERDO parametros_funcion TOK_PARENTESISDERECHO TOK_LLAVEIZQUIERDA  { printf(";R20	<funcion> ::= function <tipo> <identificador> TOK_PARENTESISIZQUIERDO <parametros_funcion> TOK_PARENTESISDERECHO TOK_LLAVEIZQUIERDA\n"); }
	;
parametros_funcion : parametro_funcion resto_parametros_funcion  { printf(";R23	<parametros_funcion> ::= <parametro_funcion> <resto_parametros_funcion>\n"); }
	|  { printf(";R23	<parametros_funcion> ::= \n"); }
	;
resto_parametros_funcion : TOK_PUNTOYCOMA parametro_funcion resto_parametros_funcion  { printf(";R25	<resto_parametros_funcion> ::= TOK_PUNTOYCOMA <parametro_funcion> <resto_parametros_funcion>\n"); }
	|  { printf(";R25	<resto_parametros_funcion> ::= \n"); }
	;
parametro_funcion : tipo identificador  { printf(";R27	<parametro_funcion> ::= <tipo> <identificador>\n"); }
	;
declaraciones_funcion : declaraciones  { printf(";R28	<declaraciones_funcion> ::= <declaraciones>\n"); }
	|  { printf(";R28	<declaraciones_funcion> ::= \n"); }
	;
sentencias : sentencia  { printf(";R30	<sentencias> ::= <sentencia>\n"); }
	| sentencia sentencias  { printf(";R30	<sentencias> ::= <sentencia> <sentencias>\n"); }
	;
sentencia : sentencia_simple TOK_PUNTOYCOMA  { printf(";R30	<sentencia> ::= <sentencia_simple> TOK_PUNTOYCOMA\n"); }
	| bloque  { printf(";R30	<sentencia> ::= <bloque>\n"); }
	;
sentencia_simple : asignacion  { printf(";R34	<sentencia_simple> ::= <asignacion>\n"); }
	| lectura  { printf(";R34	<sentencia_simple> ::= <lectura>\n"); }
	| escritura { printf(";R34	<sentencia_simple> ::= <escritura>\n"); }
	| retorno_funcion  { printf(";R34	<sentencia_simple> ::= <retorno_funcion>\n"); }
	;
bloque : condicional  { printf(";R40	<bloque> ::= <condicional>\n"); }
	| bucle  { printf(";R40	<bloque> ::= <bucle>\n"); }
	;
asignacion : identificador = exp  { printf(";R43	<asignacion> ::= <identificador> = <exp>\n"); }
	| elemento_vector = exp { printf(";R43	<asignacion> ::= <elemento_vector> = <exp>\n"); }
	;
elemento_vector : identificador TOK_CORCHETEIZQUIERDO exp TOK_CORCHETEDERECHO  { printf(";R48	<elemento_vector> ::= <identificador> TOK_CORCHETEIZQUIERDO <exp> TOK_CORCHETEDERECHO\n"); }
	;
condicional : TOK_IF TOK_PARENTESISIZQUIERDO exp TOK_PARENTESISDERECHO TOK_LLAVEIZQUIERDA sentencias TOK_LLAVEDERECHA  { printf(";R50	<condicional> ::= TOK_IF TOK_PARENTESISIZQUIERDO <exp> TOK_PARENTESISDERECHO TOK_LLAVEIZQUIERDA <sentencias> TOK_LLAVEDERECHA\n"); }
	| TOK_IF TOK_PARENTESISIZQUIERDO exp TOK_PARENTESISDERECHO TOK_LLAVEIZQUIERDA sentencias TOK_LLAVEDERECHA else TOK_LLAVEIZQUIERDA sentencias TOK_LLAVEDERECHA  { printf(";R50	<condicional> ::= TOK_IF TOK_PARENTESISIZQUIERDO <exp> TOK_PARENTESISDERECHO TOK_LLAVEIZQUIERDA <sentencias> TOK_LLAVEDERECHA else TOK_LLAVEIZQUIERDA <sentencias> TOK_LLAVEDERECHA\n"); }
	;
bucle : TOK_WHILE TOK_PARENTESISIZQUIERDO exp TOK_PARENTESISDERECHO TOK_LLAVEIZQUIERDA sentencias TOK_LLAVEDERECHA  { printf(";R52	<bucle> ::= TOK_WHILE TOK_PARENTESISIZQUIERDO <exp> TOK_PARENTESISDERECHO TOK_LLAVEIZQUIERDA <sentencias> TOK_LLAVEDERECHA\n"); }
	;
lectura : TOK_SCANF identificador  { printf(";R54	<lectura> ::= TOK_SCANF <identificador>\n"); }
	;
escritura : TOK_PRINTF exp { printf(";R56	<escritura> ::= TOK_PRINTF <exp>\n"); }
	;
retorno_funcion : TOK_RETURN exp  { printf(";R61	<retorno_funcion> ::= TOK_RETURN <exp>\n"); }
	;
exp : exp TOK_MAS exp  { printf(";R72	<exp> ::= <exp> TOK_MAS <exp>\n"); }
	| exp TOK_MENOS exp  { printf(";R72	<exp> ::= <exp> TOK_MENOS <exp>\n"); }
	| exp TOK_DIVISION exp  { printf(";R72	<exp> ::= <exp> TOK_DIVISION <exp>\n"); }
	| exp TOK_ASTERISCO exp  { printf(";R72	<exp> ::= <exp> TOK_ASTERISCO <exp>\n"); }
	| TOK_MENOS exp  { printf(";R72	<exp> ::= TOK_MENOS <exp>\n"); }
	| exp TOK_AND exp  { printf(";R72	<exp> ::= <exp> TOK_AND <exp>\n"); }
	| exp TOK_OR exp  { printf(";R72	<exp> ::= <exp> TOK_OR <exp>\n"); }
	| TOK_NOT exp  { printf(";R72	<exp> ::= TOK_NOT <exp>\n"); }
	| identificador  { printf(";R72	<exp> ::= <identificador>\n"); }
	| constante  { printf(";R72	<exp> ::= <constante>\n"); }
	| TOK_PARENTESISIZQUIERDO exp TOK_PARENTESISDERECHO  { printf(";R72	<exp> ::= TOK_PARENTESISIZQUIERDO <exp> TOK_PARENTESISDERECHO\n"); }
	| TOK_PARENTESISIZQUIERDO comparacion TOK_PARENTESISDERECHO { printf(";R72	<exp> ::= TOK_PARENTESISIZQUIERDO <comparacion> TOK_PARENTESISDERECHO\n"); }
	| elemento_vector  { printf(";R72	<exp> ::= <elemento_vector>\n"); }
	| identificador TOK_PARENTESISIZQUIERDO lista_expresiones TOK_PARENTESISDERECHO  { printf(";R72	<exp> ::= <identificador> TOK_PARENTESISIZQUIERDO <lista_expresiones> TOK_PARENTESISDERECHO\n"); }
	;
lista_expresiones : exp resto_lista_expresiones  { printf(";R89	<lista_expresiones> ::= <exp> <resto_lista_expresiones>\n"); }
	|  { printf(";R89	<lista_expresiones> ::= \n"); }
	;
resto_lista_expresiones : TOK_COMA exp resto_lista_expresiones  { printf(";R91	<resto_lista_expresiones> ::= TOK_COMA <exp> <resto_lista_expresiones>\n"); }
	|  {//vacia} { printf(";R91	<resto_lista_expresiones> ::= {//vacia}\n"); }
	;
comparacion : exp == exp  { printf(";R93	<comparacion> ::= <exp> == <exp>\n"); }
	| exp TOK_DISTINTO exp  { printf(";R93	<comparacion> ::= <exp> TOK_DISTINTO <exp>\n"); }
	| exp TOK_MENORIGUAL exp  { printf(";R93	<comparacion> ::= <exp> TOK_MENORIGUAL <exp>\n"); }
	| exp TOK_MAYORIGUAL exp  { printf(";R93	<comparacion> ::= <exp> TOK_MAYORIGUAL <exp>\n"); }
	| exp TOK_MENOR exp  { printf(";R93	<comparacion> ::= <exp> TOK_MENOR <exp>\n"); }
	| exp TOK_MAYOR exp  { printf(";R93	<comparacion> ::= <exp> TOK_MAYOR <exp>\n"); }
	;
constante : constante_logica  { printf(";R99	<constante> ::= <constante_logica>\n"); }
	| constante_entera  { printf(";R99	<constante> ::= <constante_entera>\n"); }
	;
constante_logica : TOK_TRUE  { printf(";R102	<constante_logica> ::= TOK_TRUE\n"); }
	| TOK_FALSE { printf(";R102	<constante_logica> ::= TOK_FALSE\n"); }
	;
constante_entera : TOK_CONSTANTE_ENTERA { printf(";R104	<constante_entera> ::= TOK_CONSTANTE_ENTERA\n"); }
identificador : TOK_IDENTIFICADOR { printf(";R18	<identificador> ::= TOK_IDENTIFICADOR\n"); }
	; 


%%
