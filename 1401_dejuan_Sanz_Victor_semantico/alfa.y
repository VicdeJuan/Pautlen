%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "lex.yy.h"
	#include "symbol_table.h"
extern int column,line,error;


void yyerror(char* s){
	if (error == 0)
		fprintf(ERROR_IFACE_SINTA,"****Error sintáctico en [lin %d, col %d]\n",line,column); 
	return;
}

%}


%union{
	tipo_atributo atributo;
}


%token <atributo> TOK_MAIN
%token <atributo> TOK_INT
%token <atributo> TOK_BOOLEAN
%token <atributo> TOK_ARRAY
%token <atributo> TOK_FUNCTION
%token <atributo> TOK_IF
%token <atributo> TOK_ELSE
%token <atributo> TOK_WHILE
%token <atributo> TOK_SCANF
%token <atributo> TOK_PRINTF
%token <atributo> TOK_RETURN
%token <atributo> TOK_AND
%token <atributo> TOK_OR
%token <atributo> TOK_IGUAL
%token <atributo> TOK_DISTINTO
%token <atributo> TOK_MENORIGUAL
%token <atributo> TOK_MAYORIGUAL
%token <atributo> TOK_IDENTIFICADOR
%token <atributo> TOK_CONSTANTE_ENTERA
%token <atributo> TOK_TRUE
%token <atributo> TOK_FALSE
%token <atributo> TOK_JUMP
%token <atributo> TOK_LINE_UP
%token <atributo> TOK_COL_UP
%token <atributo> TOK_ERROR
%token <atributo> TOK_ERROR_LONG

%type <atributo> programa
%type <atributo> declaraciones
%type <atributo> declaracion
%type <atributo> clase
%type <atributo> clase_escalar
%type <atributo> tipo
%type <atributo> clase_vector
%type <atributo> identificadores
%type <atributo> funciones
%type <atributo> parametros_funcion
%type <atributo> resto_parametros_funcion
%type <atributo> parametro_funcion
%type <atributo> declaraciones_funcion
%type <atributo> sentencias
%type <atributo> sentencia
%type <atributo> sentencia_simple
%type <atributo> bloque
%type <atributo> asignacion
%type <atributo> elemento_vector
%type <atributo> condicional
%type <atributo> bucle
%type <atributo> lectura
%type <atributo> escritura
%type <atributo> retorno_funcion
%type <atributo> exp
%type <atributo> lista_expresiones
%type <atributo> resto_lista_expresiones
%type <atributo> comparacion
%type <atributo> constante
%type <atributo> constante_logica
%type <atributo> constante_entera
%type <atributo> identificador
%type <atributo> funcion


%right '='
%left TOK_OR 
%left TOK_AND 
%left TOK_IGUAL TOK_MENORIGUAL TOK_MAYORIGUAL '<' '>'
%left '+' '-' 
%left '*' '/' 
%right '!' 


%start programa

%%
 programa : main '{' declaraciones funciones sentencias '}' { fprintf(yyout,";R1:	<programa> ::= main { <declaraciones> <funciones> <sentencias> }\n"); }
	;
main: TOK_MAIN
	;
declaraciones : declaracion  { fprintf(yyout,";R2:	<declaraciones> ::= <declaracion>\n"); }
	| declaracion declaraciones  { fprintf(yyout,";R3:	<declaraciones> ::= <declaracion> <declaraciones>\n"); }
	;
declaracion : clase identificadores ';'  { fprintf(yyout,";R4:	<declaracion> ::= <clase> <identificadores> ;\n"); }
	;
clase : clase_escalar  { fprintf(yyout,";R5:	<clase> ::= <clase_escalar>\n"); }
	| clase_vector  { fprintf(yyout,";R7:	<clase> ::= <clase_vector>\n"); }
	;
clase_escalar : tipo  { fprintf(yyout,";R9:	<clase_escalar> ::= <tipo>\n"); }
	;
tipo : TOK_INT  { fprintf(yyout,";R10:	<tipo> ::= int\n"); }
	| TOK_BOOLEAN { fprintf(yyout,";R11:	<tipo> ::= boolean\n"); }
	;
clase_vector : TOK_ARRAY tipo '[' constante_entera  ']' { fprintf(yyout,";R15:	<clase_vector> ::= array <tipo> [ <constante_entera>  ]\n"); }
	;
identificadores : identificador  { fprintf(yyout,";R18:	<identificadores> ::= <identificador>\n"); }
	| identificador ',' identificadores  { fprintf(yyout,";R19:	<identificadores> ::= <identificador> , <identificadores>\n"); }
	;
funciones : funcion funciones  { fprintf(yyout,";R20:	<funciones> ::= <funcion> <funciones>\n"); }
	|  { fprintf(yyout,";R21:	<funciones> ::= \n"); }
	;
funcion : TOK_FUNCTION tipo identificador '(' parametros_funcion ')' '{' declaraciones_funcion sentencias '}' { fprintf(yyout,";R20:	<funcion> ::= funcion <tipo> <identificador> ( <parametros_funcion> ) { <declaraciones_funcion> <sentencias> }  \n"); }
	;
parametros_funcion : parametro_funcion resto_parametros_funcion  { fprintf(yyout,";R23:	<parametros_funcion> ::= <parametro_funcion> <resto_parametros_funcion>\n"); }
	|  { fprintf(yyout,";R24:	<parametros_funcion> ::= \n"); }
	;
resto_parametros_funcion : ';' parametro_funcion resto_parametros_funcion  { fprintf(yyout,";R25:	<resto_parametros_funcion> ::= ; <parametro_funcion> <resto_parametros_funcion>\n"); }
	|  { fprintf(yyout,";R25:	<resto_parametros_funcion> ::= \n"); }
	;
parametro_funcion : tipo identificador  { fprintf(yyout,";R27:	<parametro_funcion> ::= <tipo> <identificador>\n"); }
	;
declaraciones_funcion : declaraciones  { fprintf(yyout,";R28:	<declaraciones_funcion> ::= <declaraciones>\n"); }
	|  { fprintf(yyout,";R29:	<declaraciones_funcion> ::= \n"); }
	;
sentencias : sentencia  { fprintf(yyout,";R30:	<sentencias> ::= <sentencia>\n"); }
	| sentencia sentencias  { fprintf(yyout,";R31:	<sentencias> ::= <sentencia> <sentencias>\n"); }
	;
sentencia : sentencia_simple ';'  { fprintf(yyout,";R32:	<sentencia> ::= <sentencia_simple> ;\n"); }
	| bloque  { fprintf(yyout,";R33:	<sentencia> ::= <bloque>\n"); }
	;
sentencia_simple : asignacion  { fprintf(yyout,";R34:	<sentencia_simple> ::= <asignacion>\n"); }
	| lectura  { fprintf(yyout,";R35:	<sentencia_simple> ::= <lectura>\n"); }
	| escritura { fprintf(yyout,";R36:	<sentencia_simple> ::= <escritura>\n"); }
	| retorno_funcion  { fprintf(yyout,";R38:	<sentencia_simple> ::= <retorno_funcion>\n"); }
	;
bloque : condicional  { fprintf(yyout,";R40:	<bloque> ::= <condicional>\n"); }
	| bucle  { fprintf(yyout,";R41:	<bloque> ::= <bucle>\n"); }
	;
asignacion : identificador '=' exp  { fprintf(yyout,";R43:	<asignacion> ::= <identificador> = <exp>\n"); }
	| elemento_vector '=' exp { fprintf(yyout,";R44:	<asignacion> ::= <elemento_vector> = <exp>\n"); }
	;
elemento_vector : identificador '[' exp ']'  { fprintf(yyout,";R48:	<elemento_vector> ::= <identificador> [ <exp> ]\n"); }
	;
condicional : TOK_IF  '(' exp ')' '{' sentencias '}'  { fprintf(yyout,";R50:	<condicional> ::= if ( <exp> ) { <sentencias> }\n"); }
	| TOK_IF '(' exp ')' '{' sentencias '}' TOK_ELSE '{' sentencias '}'  { fprintf(yyout,";R51:	<condicional> ::= if ( <exp> ) { <sentencias> } else { <sentencias> }\n"); }
	;
bucle : TOK_WHILE '(' exp ')' '{' sentencias '}'  { fprintf(yyout,";R52:	<bucle> ::= while ( <exp> ) { <sentencias> }\n"); }
	;
lectura : TOK_SCANF identificador  { fprintf(yyout,";R54:	<lectura> ::= scanf <identificador>\n"); }
	;
escritura : TOK_PRINTF exp { fprintf(yyout,";R56:	<escritura> ::= printf <exp>\n"); }
	;
retorno_funcion : TOK_RETURN exp  { fprintf(yyout,";R61:	<retorno_funcion> ::= return <exp>\n"); }
	;
exp : exp '+' exp  { fprintf(yyout,";R72:	<exp> ::= <exp> + <exp>\n"); }
	| exp '-' exp  { fprintf(yyout,";R73:	<exp> ::= <exp> - <exp>\n"); }
	| exp '/' exp  { fprintf(yyout,";R74:	<exp> ::= <exp> / <exp>\n"); }
	| exp '*' exp  { fprintf(yyout,";R75:	<exp> ::= <exp> * <exp>\n"); }
	| '-' exp  { fprintf(yyout,";R76:	<exp> ::= - <exp>\n"); }
	| exp TOK_AND exp  { fprintf(yyout,";R77:	<exp> ::= <exp> && <exp>\n"); }
	| exp TOK_OR exp  { fprintf(yyout,";R78:	<exp> ::= <exp> || <exp>\n"); }
	| '!' exp  { fprintf(yyout,";R79:	<exp> ::= ! <exp>\n"); }
	| '(' exp ')'  { fprintf(yyout,";R82:	<exp> ::= ( <exp> )\n"); }
	| '(' comparacion ')'  { fprintf(yyout,";R83:	<exp> ::= ( <comparacion> )\n"); }
	| identificador  { fprintf(yyout,";R80:	<exp> ::= <identificador>\n"); }
	| constante  { fprintf(yyout,";R81:	<exp> ::= <constante>\n"); }
	| elemento_vector  { fprintf(yyout,";R85:	<exp> ::= <elemento_vector>\n"); }
	| identificador '(' lista_expresiones ')'  { fprintf(yyout,";R88:	<exp> ::= <identificador> ( <lista_expresiones> )\n"); }
	;
lista_expresiones : exp resto_lista_expresiones  { fprintf(yyout,";R89:	<lista_expresiones> ::= <exp> <resto_lista_expresiones>\n"); }
	|  { fprintf(yyout,";R90:	<lista_expresiones> ::= \n"); }
	;
resto_lista_expresiones : ',' exp resto_lista_expresiones  { fprintf(yyout,";R91:	<resto_lista_expresiones> ::= , <exp> <resto_lista_expresiones>\n"); }
	|  {/*vacia*/} { fprintf(yyout,";R91:	<resto_lista_expresiones> ::= \n"); }
	;
comparacion : exp TOK_IGUAL exp  { fprintf(yyout,";R93:	<comparacion> ::= <exp> == <exp>\n"); }
	| exp TOK_DISTINTO exp  { fprintf(yyout,";R94:	<comparacion> ::= <exp> != <exp>\n"); }
	| exp TOK_MENORIGUAL exp  { fprintf(yyout,";R95:	<comparacion> ::= <exp> <= <exp>\n"); }
	| exp TOK_MAYORIGUAL exp  { fprintf(yyout,";R96:	<comparacion> ::= <exp> >= <exp>\n"); }
	| exp '<' exp  { fprintf(yyout,";R97:	<comparacion> ::= <exp> < <exp>\n"); }
	| exp '>' exp  { fprintf(yyout,";R98:	<comparacion> ::= <exp> > <exp>\n"); }
	;
constante : constante_logica  { fprintf(yyout,";R99:	<constante> ::= <constante_logica>\n"); }
	| constante_entera  { fprintf(yyout,";R100:	<constante> ::= <constante_entera>\n"); }
	;
constante_logica : TOK_TRUE  { fprintf(yyout,";R102:	<constante_logica> ::= TOK_TRUE\n"); }
	| TOK_FALSE { fprintf(yyout,";R103:	<constante_logica> ::= TOK_FALSE\n"); }
	;
constante_entera : TOK_CONSTANTE_ENTERA { fprintf(yyout,";R104:	<constante_entera> ::= TOK_CONSTANTE_ENTERA\n"); }
	;
identificador : TOK_IDENTIFICADOR { fprintf(yyout,";R108:	<identificador> ::= TOK_IDENTIFICADOR\n"); }
	; 

%%
