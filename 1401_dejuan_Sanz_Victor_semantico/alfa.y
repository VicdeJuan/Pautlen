%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "alfa.h"
	#include "lex.yy.h"
	#include "symbol_table.h"

extern int column,line,error;


void print_sem_error(char * msg){
		fprintf(ERROR_IFACE_SINTA,"****Error sintáctico en [lin %d, col %d]\n",line,column); 
	return;
}

void yyerror(char* s){
	if (error == 0)
		fprintf(ERROR_IFACE_SINTA,"****Error sintáctico en [lin %d, col %d]\n",line,column); 
	return;
}

/** A inicializar */
int clase_actual, tipo_actual,ambito_actual,tamanio_vector_actual;
int pos_variable_local_actual,num_variables_locales_actual,pos_parametro_actual,num_parametro_actual;

/** Ya escrita su inicialización */
symbol_table * tabla;
FILE * logfile;

%}


%union{
	tipo_atributos atributo;
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
%type <atributo> fn_name
%type <atributo> fn_declaration


%right '='
%left TOK_OR 
%left TOK_AND 
%left TOK_IGUAL TOK_MENORIGUAL TOK_MAYORIGUAL '<' '>'
%left '+' '-' 
%left '*' '/' 
%right '!' 


%start programa

%%
 programa : inicioTabla main '{' declaraciones funciones sentencias '}' { fprintf(logfile,";R1:	<programa> ::= main { <declaraciones> <funciones> <sentencias> }\n"); }
	;

inicioTabla: {
		tabla = create_symbol_table();
		logfile = stderr;
		clase_actual = NONE;
		tipo_actual = NONE;
		ambito_actual = NONE;
		tamanio_vector_actual = NONE;
		pos_variable_local_actual = 1;
		num_variables_locales_actual = 0;
		pos_parametro_actual = 0;
		num_parametro_actual = 0;
	}
	;

main: TOK_MAIN
	;
declaraciones : declaracion  { fprintf(logfile,";R2:	<declaraciones> ::= <declaracion>\n"); }
	| declaracion declaraciones  { fprintf(logfile,";R3:	<declaraciones> ::= <declaracion> <declaraciones>\n"); }
	;
declaracion : clase identificadores ';'  {
		clase_actual = NONE;
		tipo_actual = NONE;
		tamanio_vector_actual = NONE;
		fprintf(logfile,";R4:	<declaracion> ::= <clase> <identificadores> ;\n"); 
	}
	;
clase : clase_escalar  {
			fprintf(logfile,";R5:	<clase> ::= <clase_escalar>\n"); 
			clase_actual = ESCALAR;
		}
	| clase_vector  {
			fprintf(logfile,";R7:	<clase> ::= <clase_vector>\n"); 
			clase_actual = VECTOR;
		}
	;
clase_escalar : tipo  { fprintf(logfile,";R9:	<clase_escalar> ::= <tipo>\n"); }
	;
tipo : TOK_INT  { 
			fprintf(logfile,";R10:	<tipo> ::= int\n"); 
			tipo_actual = INT;
		}
	| TOK_BOOLEAN { 
			fprintf(logfile,";R11:	<tipo> ::= boolean\n"); 
			tipo_actual = BOOLEAN;
		}
	;
clase_vector : TOK_ARRAY tipo '[' constante_entera  ']' {
	fprintf(logfile,";R15:	<clase_vector> ::= array <tipo> [ <constante_entera>  ]\n"); 
	tamanio_vector_actual = $4.valor_entero;
	if ((tamanio_vector_actual < 1) || (tamanio_vector_actual >= MAX_TAMANIO_VECTOR))
	{
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		sprintf(err_msg, SEM_ERROR_VECTOR_SIZE);
		print_sem_error(err_msg);
		free(err_msg);
	}
	}
	;
identificadores : identificador  { fprintf(logfile,";R18:	<identificadores> ::= <identificador>\n"); }
	| identificador ',' identificadores  { fprintf(logfile,";R19:	<identificadores> ::= <identificador> , <identificadores>\n"); }
	;

funciones : funcion funciones  { fprintf(logfile,";R20:	<funciones> ::= <funcion> <funciones>\n"); }
	|  { fprintf(logfile,";R21:	<funciones> ::= \n"); }
	;

fn_name : TOK_FUNCTION tipo TOK_IDENTIFICADOR { 
	symbol * sim = search_symbol(tabla,$3.lexema,GLOBAL); 
	int i;
	if (!sim)
	{
		for (i=0;i<2;i++){
			/* Recordamos local es 0 y global es 1 */
			sim = malloc(sizeof(symbol));
			initialize_simbolo(sim);
			strcpy(sim->key,$3.lexema);

			sim->data_type = tipo_actual;
			sim->symbol_type = FUNCTION;

			add_symbol(tabla,sim,i);
			ambito_actual = LOCAL;
			
		}
		
		num_variables_locales_actual = 0;
		pos_variable_local_actual = 1;
		num_parametro_actual = 0;
		pos_parametro_actual = 0;
		strcpy($$.lexema,$3.lexema);

	}
	else{
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		sprintf(err_msg, SEM_ERROR_ALREADY_DEF ,$1.lexema);
		print_sem_error(err_msg);
		free(err_msg);
	}
	}	
	;


fn_declaration : fn_name '(' parametros_funcion ')' '{' declaraciones_funcion {
	int i = 0;
	for(i = 0; i<2; i++){
		symbol * sim = search_symbol(tabla,$3.lexema,i); 	

		sim->num_parameter = num_parametro_actual;
		sim->num_local_variables = num_variables_locales_actual;
	
	}
	strcpy($$.lexema,$1.lexema);

}
;
funcion : fn_declaration sentencias '}' {	
	fprintf(logfile,";R20:	<funcion> ::= funcion <tipo> <identificador> ( <parametros_funcion> ) { <declaraciones_funcion> <sentencias> }  \n"); 
	close_local_ambit(tabla);
	ambito_actual = GLOBAL;
	/* Ya están actualizados los num de la función. */
	pos_variable_local_actual = 1;

}

parametros_funcion : parametro_funcion resto_parametros_funcion  { fprintf(logfile,";R23:	<parametros_funcion> ::= <parametro_funcion> <resto_parametros_funcion>\n"); }
	|  { fprintf(logfile,";R24:	<parametros_funcion> ::= \n"); }
	;
resto_parametros_funcion : ';' parametro_funcion resto_parametros_funcion  { fprintf(logfile,";R25:	<resto_parametros_funcion> ::= ; <parametro_funcion> <resto_parametros_funcion>\n"); }
	|  { fprintf(logfile,";R26:	<resto_parametros_funcion> ::= \n"); }
	;
parametro_funcion : tipo idpf  {
	fprintf(logfile,";R27:	<parametro_funcion> ::= <tipo> <identificador>\n"); 
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
	}
	;
declaraciones_funcion : declaraciones  { fprintf(logfile,";R28:	<declaraciones_funcion> ::= <declaraciones>\n"); }
	|  { fprintf(logfile,";R29:	<declaraciones_funcion> ::= \n"); }
	;
sentencias : sentencia  { fprintf(logfile,";R30:	<sentencias> ::= <sentencia>\n"); }
	| sentencia sentencias  { fprintf(logfile,";R31:	<sentencias> ::= <sentencia> <sentencias>\n"); }
	;
sentencia : sentencia_simple ';'  { fprintf(logfile,";R32:	<sentencia> ::= <sentencia_simple> ;\n"); }
	| bloque  { fprintf(logfile,";R33:	<sentencia> ::= <bloque>\n"); }
	;
sentencia_simple : asignacion  { fprintf(logfile,";R34:	<sentencia_simple> ::= <asignacion>\n"); }
	| lectura  { fprintf(logfile,";R35:	<sentencia_simple> ::= <lectura>\n"); }
	| escritura { fprintf(logfile,";R36:	<sentencia_simple> ::= <escritura>\n"); }
	| retorno_funcion  { fprintf(logfile,";R38:	<sentencia_simple> ::= <retorno_funcion>\n"); }
	;
bloque : condicional  { fprintf(logfile,";R40:	<bloque> ::= <condicional>\n"); }
	| bucle  { fprintf(logfile,";R41:	<bloque> ::= <bucle>\n"); }
	;
asignacion : identificador '=' exp  { fprintf(logfile,";R43:	<asignacion> ::= <identificador> = <exp>\n"); }
	| elemento_vector '=' exp { fprintf(logfile,";R44:	<asignacion> ::= <elemento_vector> = <exp>\n"); }
	;
elemento_vector : identificador '[' exp ']'  { fprintf(logfile,";R48:	<elemento_vector> ::= <identificador> [ <exp> ]\n"); }
	;
condicional : TOK_IF  '(' exp ')' '{' sentencias '}'  { fprintf(logfile,";R50:	<condicional> ::= if ( <exp> ) { <sentencias> }\n"); }
	| TOK_IF '(' exp ')' '{' sentencias '}' TOK_ELSE '{' sentencias '}'  { fprintf(logfile,";R51:	<condicional> ::= if ( <exp> ) { <sentencias> } else { <sentencias> }\n"); }
	;
bucle : TOK_WHILE '(' exp ')' '{' sentencias '}'  { fprintf(logfile,";R52:	<bucle> ::= while ( <exp> ) { <sentencias> }\n"); }
	;
lectura : TOK_SCANF identificador  { fprintf(logfile,";R54:	<lectura> ::= scanf <identificador>\n"); }
	;
escritura : TOK_PRINTF exp { fprintf(logfile,";R56:	<escritura> ::= printf <exp>\n"); }
	;
retorno_funcion : TOK_RETURN exp  { fprintf(logfile,";R61:	<retorno_funcion> ::= return <exp>\n"); }
	;
exp : exp '+' exp  { 
		fprintf(logfile,";R72:	<exp> ::= <exp> + <exp>\n"); 
		CHECK_INT_TYPES;
	}
	| exp '-' exp  { 
		fprintf(logfile,";R73:	<exp> ::= <exp> - <exp>\n"); 
		CHECK_INT_TYPES;
	}
	| exp '/' exp  { 
		fprintf(logfile,";R74:	<exp> ::= <exp> / <exp>\n"); 
		CHECK_INT_TYPES;
	}
	| exp '*' exp  { 
		fprintf(logfile,";R75:	<exp> ::= <exp> * <exp>\n"); 
		CHECK_INT_TYPES;
	}
	| '-' exp  { 
		fprintf(logfile,";R76:	<exp> ::= - <exp>\n"); 
		CHECK_INT_TYPE;
	}
	| exp TOK_AND exp  { 
		fprintf(logfile,";R77:	<exp> ::= <exp> && <exp>\n"); 
		CHECK_BOOLEAN_TYPES;
	}
	| exp TOK_OR exp  { 
		fprintf(logfile,";R78:	<exp> ::= <exp> || <exp>\n"); 
		CHECK_BOOLEAN_TYPES;
	}
	| '!' exp  { 
		fprintf(logfile,";R79:	<exp> ::= ! <exp>\n"); 
		CHECK_BOOLEAN_TYPE;
	}
	| '(' exp ')'  { 
		fprintf(logfile,";R82:	<exp> ::= ( <exp> )\n"); 
		$$.tipo = $2.tipo;
	}
	| '(' comparacion ')'  { 
		fprintf(logfile,";R83:	<exp> ::= ( <comparacion> )\n"); 
		$$.tipo = $2.tipo;
	}
	| identificador  { 
			fprintf(logfile,";R80:	<exp> ::= <identificador>\n"); 
		}
	| constante  { 
			fprintf(logfile,";R81:	<exp> ::= <constante>\n"); 
		}
	| elemento_vector  { 
			fprintf(logfile,";R85:	<exp> ::= <elemento_vector>\n"); 
		}
	| identificador '(' lista_expresiones ')'  { 
			fprintf(logfile,";R88:	<exp> ::= <identificador> ( <lista_expresiones> )\n"); 
		}
	;
lista_expresiones : exp resto_lista_expresiones  { fprintf(logfile,";R89:	<lista_expresiones> ::= <exp> <resto_lista_expresiones>\n"); }
	|  { fprintf(logfile,";R90:	<lista_expresiones> ::= \n"); }
	;
resto_lista_expresiones : ',' exp resto_lista_expresiones  { fprintf(logfile,";R91:	<resto_lista_expresiones> ::= , <exp> <resto_lista_expresiones>\n"); }
	|  {/*vacia*/} { fprintf(logfile,";R91:	<resto_lista_expresiones> ::= \n"); }
	;
comparacion : exp TOK_IGUAL exp  { fprintf(logfile,";R93:	<comparacion> ::= <exp> == <exp>\n"); CHECK_INT_TYPES; $$.tipo = BOOLEAN;	}
	| exp TOK_DISTINTO exp  { fprintf(logfile,";R94:	<comparacion> ::= <exp> != <exp>\n"); CHECK_INT_TYPES; $$.tipo = BOOLEAN; }
	| exp TOK_MENORIGUAL exp  { fprintf(logfile,";R95:	<comparacion> ::= <exp> <= <exp>\n"); CHECK_INT_TYPES; $$.tipo = BOOLEAN; }
	| exp TOK_MAYORIGUAL exp  { fprintf(logfile,";R96:	<comparacion> ::= <exp> >= <exp>\n"); CHECK_INT_TYPES; $$.tipo = BOOLEAN; }
	| exp '<' exp  { fprintf(logfile,";R97:	<comparacion> ::= <exp> < <exp>\n"); CHECK_INT_TYPES; $$.tipo = BOOLEAN; }
	| exp '>' exp  { fprintf(logfile,";R98:	<comparacion> ::= <exp> > <exp>\n"); CHECK_INT_TYPES; $$.tipo = BOOLEAN; }
	;
constante : constante_logica  { fprintf(logfile,";R99:	<constante> ::= <constante_logica>\n"); $$.tipo = $1.tipo; $$.es_direccion = $1.es_direccion;}
	| constante_entera  { fprintf(logfile,";R100:	<constante> ::= <constante_entera>\n");  $$.tipo = $1.tipo; $$.es_direccion = $1.es_direccion;}
	;
constante_logica : TOK_TRUE  { fprintf(logfile,";R102:	<constante_logica> ::= TOK_TRUE\n");$$.tipo = BOOLEAN; $$.es_direccion = 0;}
	| TOK_FALSE { fprintf(logfile,";R103:	<constante_logica> ::= TOK_FALSE\n"); $$.tipo = BOOLEAN; $$.es_direccion = 0;}
	;
constante_entera : TOK_CONSTANTE_ENTERA { fprintf(logfile,";R104:	<constante_entera> ::= TOK_CONSTANTE_ENTERA\n"); $$.tipo = INT; $$.es_direccion = 0;}
	;

idpf : TOK_IDENTIFICADOR {
	if (ambito_actual != LOCAL)
		fprintf(logfile,"Tenemos un problema. Buscame y lo vemos");
	symbol * sim = search_symbol(tabla,$1.lexema,ambito_actual);
	if (!sim)
	{
		sim = malloc(sizeof(symbol));
		initialize_simbolo(sim);
		strcpy(sim->key,$1.lexema);

		sim->data_type = tipo_actual;
		sim->variable_type = clase_actual;
		sim->symbol_type = VARIABLE;
		
		add_symbol(tabla,sim,ambito_actual);

		pos_parametro_actual++;
		num_parametro_actual++;
	}
	else{
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		sprintf(err_msg, SEM_ERROR_ALREADY_DEF ,$1.lexema);
		print_sem_error(err_msg);
		free(err_msg);
	}
	

}

identificador : TOK_IDENTIFICADOR {
	fprintf(logfile,";R108:	<identificador> ::= TOK_IDENTIFICADOR\n"); 
	symbol * sim = search_symbol(tabla,$1.lexema,ambito_actual);
	if (!sim)
	{
		if(clase_actual == ESCALAR && ambito_actual == LOCAL){
			print_sem_error(SEM_ERROR_JUST_ESCALAR_IN_LOCAL);
		}else{		
			sim = malloc(sizeof(symbol));
			initialize_simbolo(sim);
			strcpy(sim->key,$1.lexema);

			sim->data_type = tipo_actual;
			sim->variable_type = clase_actual;
			sim->symbol_type = VARIABLE;
			
			add_symbol(tabla,sim,ambito_actual);
			
			if (ambito_actual == LOCAL){
				pos_variable_local_actual++;
				num_variables_locales_actual++;
			}
		}
	}
	else{
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		sprintf(err_msg, SEM_ERROR_ALREADY_DEF ,$1.lexema);
		print_sem_error(err_msg);
		free(err_msg);
	}

	}
	; 

%%
