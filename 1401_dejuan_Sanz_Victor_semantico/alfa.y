%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "alfa.h"
	#include "lex.yy.h"
	#include "code_generator.h"

	extern int column,line,error;


	int clase_actual, tipo_actual,ambito_actual,tamanio_vector_actual;

	int pos_variable_local_actual,num_variables_locales_actual,pos_parametro_actual,num_parametro_actual;

	int en_explist,num_parametros_llamada_actual,tipo_retorno;

	int tag_num;
	symbol_table * tabla;
	FILE * logfile;
	FILE * nasm_file;
	FILE * aux_nasm_file;

	void print_sem_error(char * msg){
		fprintf(stderr,"\t****Error semático en [lin %d] debido a : %s\n",line,msg); 
		free(msg);
		delete_symbol_table(tabla);
		exit(-1);
	}

	void yyerror(char* s){
		if (error == 0)
			fprintf(ERROR_IFACE_SINTA,"\t****Error sintáctico en [lin %d, col %d]\n",line,column); 
		return;
	}


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
	%type <atributo> idpf
	%type <atributo> if_exp
	%type <atributo> while_exp
	%type <atributo> while
	%type <atributo> if_exp_sentencias

	/* Funciones */
	%type <atributo> fn_name
	%type <atributo> fn_declaration
	%type <atributo> funcion
	%type <atributo> idf_llamada_funcion
	%type <atributo> escritura_main
	%type <atributo> ini_exp_l


	%right '='
	%left TOK_OR 
	%left TOK_AND 
	%left TOK_IGUAL TOK_MENORIGUAL TOK_MAYORIGUAL '<' '>'
	%left '+' '-' 
	%left '*' '/' 
	%right '!' 


	%start programa

	%%
	programa : inicializacion main '{' declaraciones escritura_TS funciones escritura_main sentencias '}' {
		fprintf(logfile,";R1:	<programa> ::= main { <declaraciones> <funciones> <sentencias> }\n"); 
		write_execute_errors(nasm_file);
	}
	;
	/* write_execute_errors*/
	escritura_TS : {
		if (declare_global_variables(nasm_file,tabla) == ERR){
			fprintf(logfile, "No se ha podido iniciar la generación de código.\n");
		}
		
	}
	;
	escritura_main : {
		write_main_tag(nasm_file);
	}
	inicializacion : {
		/* Inicializamos la tabla */
		tabla = create_symbol_table();
		logfile = fopen(LOGFILE,"w");
		clase_actual = NONE;
		tipo_actual = NONE;
		ambito_actual = NONE;
		tamanio_vector_actual = NONE;
		pos_variable_local_actual = 1;
		num_variables_locales_actual = 0;
		pos_parametro_actual = 0;
		num_parametro_actual = 0;
		tag_num = 0;

		/* Inicializamos otras variables.*/
		nasm_file = fopen(NASM_FILE_NAME,"w");

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
		if ((tamanio_vector_actual < 1) || (tamanio_vector_actual > MAX_TAMANIO_VECTOR))
		{
			char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
			sprintf(err_msg, SEM_ERROR_VECTOR_SIZE);
			print_sem_error(err_msg);
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
		symbol * sim;
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		int i;
		CHECK_IDENT_NOT_DEFINED($3)
		else{
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
			tipo_retorno = tipo_actual;
			tipo_actual = NONE;
			strcpy($$.lexema,$3.lexema);
			free(err_msg);	
		}	
	}
	;


	fn_declaration : fn_name '(' parametros_funcion ')' '{' declaraciones_funcion {
		int i = 0;
		for(i = 0; i<2; i++){
			symbol * sim = search_symbol(tabla,$1.lexema,i); 	

			sim->num_parameter = num_parametro_actual;
			sim->num_local_variables = num_variables_locales_actual;

		}
		strcpy($$.lexema,$1.lexema);
		write_fn__begin(nasm_file,$1.lexema,num_variables_locales_actual,num_parametro_actual);

	}
	;
	funcion : fn_declaration sentencias '}' {	
		fprintf(logfile,";R20:	<funcion> ::= funcion <tipo> <identificador> ( <parametros_funcion> ) { <declaraciones_funcion> <sentencias> }  \n"); 
		close_local_ambit(tabla);
		ambito_actual = GLOBAL;
	/* Ya están actualizados los num de la función. */
		pos_variable_local_actual = 1;
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		if ($2.hay_retorno == 0){
			sprintf(err_msg,SEM_ERROR_MISSING_RET);
			print_sem_error(err_msg);			
		}
		free(err_msg);	
		__write_fn__ret(nasm_file);

	}

	parametros_funcion : parametro_funcion resto_parametros_funcion  { fprintf(logfile,";R23:	<parametros_funcion> ::= <parametro_funcion> <resto_parametros_funcion>\n"); }
	|  { fprintf(logfile,";R24:	<parametros_funcion> ::= \n"); }
	;
	resto_parametros_funcion : ';' parametro_funcion resto_parametros_funcion  { fprintf(logfile,";R25:	<resto_parametros_funcion> ::= ; <parametro_funcion> <resto_parametros_funcion>\n"); }
	|  { fprintf(logfile,";R26:	<resto_parametros_funcion> ::= \n"); }
	;
	parametro_funcion : tipo idpf  {
		fprintf(logfile,";R27:	<parametro_funcion> ::= <tipo> <identificador>\n"); 
		symbol * sim;
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_IDENT_DEFINED($2)
		else{
			sim->variable_type = tipo_actual;
			tipo_actual = NONE;
			free(err_msg);	
		}

	}
	;
	declaraciones_funcion : declaraciones  { fprintf(logfile,";R28:	<declaraciones_funcion> ::= <declaraciones>\n"); }
	|  { fprintf(logfile,";R29:	<declaraciones_funcion> ::= \n"); }
	;
	sentencias : sentencia  { fprintf(logfile,";R30:	<sentencias> ::= <sentencia>\n"); $$.hay_retorno = $1.hay_retorno;}
	| sentencia sentencias  { fprintf(logfile,";R31:	<sentencias> ::= <sentencia> <sentencias>\n"); $$.hay_retorno = $1.hay_retorno || $2.hay_retorno;}
	;
	sentencia : sentencia_simple ';'  { fprintf(logfile,";R32:	<sentencia> ::= <sentencia_simple> ;\n"); $$.hay_retorno = $1.hay_retorno; }
	| bloque  { fprintf(logfile,";R33:	<sentencia> ::= <bloque>\n"); $$.hay_retorno = 0; }
	;
	sentencia_simple : asignacion  { fprintf(logfile,";R34:	<sentencia_simple> ::= <asignacion>\n");$$.hay_retorno = 0; }
	| lectura  { fprintf(logfile,";R35:	<sentencia_simple> ::= <lectura>\n"); $$.hay_retorno = 0;}
	| escritura { fprintf(logfile,";R36:	<sentencia_simple> ::= <escritura>\n"); $$.hay_retorno = 0;}
	| retorno_funcion  { fprintf(logfile,";R38:	<sentencia_simple> ::= <retorno_funcion>\n"); $$.hay_retorno = 1; }
	;
	bloque : condicional  { fprintf(logfile,";R40:	<blfoque> ::= <condicional>\n"); }
	| bucle  { fprintf(logfile,";R41:	<bloque> ::= <bucle>\n"); }
	;
	asignacion : TOK_IDENTIFICADOR '=' exp  { 
		fprintf(logfile,";R43:	<asignacion> ::= <identificador> = <exp>\n"); 
		symbol * sim;
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_IDENT_DEFINED($1)
		else{
			CHECK_IS_NOT_FUNCTION($1.lexema);
			if (sim->data_type != $3.tipo){
				sprintf(err_msg,SEM_ERROR_INCOMPATIBLE_TYPES,GET_STR_FROM_TYPE(sim->data_type),GET_STR_FROM_TYPE($3.tipo));
				print_sem_error(err_msg);
			}
			CHECK_IS_ESCALAR($1.lexema)

			write_assign(nasm_file,$1.lexema,$3.es_direccion,0);
		}
		free(err_msg);	

	}
	| elemento_vector '=' exp { 
		fprintf(logfile,";R44:	<asignacion> ::= <elemento_vector> = <exp>\n"); 
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_SAME_TYPES($$,$1,$3)

		write_assign(nasm_file,$1.lexema,$3.es_direccion,1);
		free(err_msg);	

	}
	;
	elemento_vector : TOK_IDENTIFICADOR '[' exp ']'  { 
		fprintf(logfile,";R48:	<elemento_vector> ::= <identificador> [ <exp> ]\n"); 
		symbol * sim;
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_IDENT_DEFINED($1)
		else{
			CHECK_IS_VECTOR($1.lexema)
			if ($3.tipo != INT){
				sprintf(err_msg,SEM_ERROR_INCOMPATIBLE_TYPE,GET_STR_FROM_TYPE($3.tipo));
				print_sem_error(err_msg);
			}
			if (sim->data_type == $1.tipo){
				sprintf(err_msg,SEM_ERROR_INCOMPATIBLE_TYPES,GET_STR_FROM_TYPE(sim->symbol_type),GET_STR_FROM_TYPE($1.tipo));
				print_sem_error(err_msg);
			}
			$$.tipo = sim->data_type;
			write_load_vector_element(nasm_file,$1.lexema,$3.es_direccion,en_explist);
		}

		$$.es_direccion = 1 ? !en_explist : 0;
		free(err_msg);	
	}
	;


	condicional : if_exp '{' sentencias '}'  {
		fprintf(logfile,";R50:	<condicional> ::= if ( <exp> ) { <sentencias> }\n"); 
		write_if_exp__end(nasm_file,$1.etiqueta);

	}
	| if_exp_sentencias TOK_ELSE '{' sentencias '}'  {
		fprintf(logfile,";R51:	<condicional> ::= if ( <exp> ) { <sentencias> } else { <sentencias> }\n"); 
		write_else_exp__end(nasm_file,$1.etiqueta);
	}
	;

	if_exp_sentencias : if_exp '{' sentencias '}' {
		$$.etiqueta = $1.etiqueta;
		write_else_exp__mid(nasm_file,$1.etiqueta);
	}
	;

	if_exp :  TOK_IF  '(' exp ')' {
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_BOOLEAN_TYPE($$,$3)
		$$.etiqueta = tag_num++;
		write_if_exp__begin(nasm_file,$3.es_direccion,$$.etiqueta);
		free(err_msg);	
	}
	;

	bucle : while_exp '{' sentencias '}'  {
		fprintf(logfile,";R52:	<bucle> ::= while ( <exp> ) { <sentencias> }\n"); 
		write_while_exp__end(nasm_file,$1.etiqueta);
	}
	;
	while_exp : while '(' exp ')' { 
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_BOOLEAN_TYPE($$,$3)
		$$.etiqueta = $1.etiqueta;
		write_while_exp__mid(nasm_file,$$.etiqueta,$3.es_direccion);
		free(err_msg);	

	}
	;
	while : TOK_WHILE {
		$$.etiqueta = tag_num++;
		write_while_exp__begin(nasm_file,$$.etiqueta);
	}
	;


	lectura : TOK_SCANF TOK_IDENTIFICADOR  { 
		fprintf(logfile,";R54:	<lectura> ::= scanf <identificador>\n"); 
		symbol * sim;
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_IDENT_DEFINED($2)
		else{
			CHECK_IS_VARIABLE(sim->key);
			CHECK_IS_ESCALAR(sim->key);
			write_scanf(nasm_file,sim->key,sim->data_type==INT);
		}
		free(err_msg);	

	}
	;

	escritura : TOK_PRINTF exp { 
		fprintf(logfile,";R56:	<escritura> ::= printf <exp>\n"); 
		symbol * sim;
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_IDENT_DEFINED($2)
		else{
			CHECK_IS_VARIABLE(sim->key);
			write_printf(nasm_file,$2.es_direccion,sim->data_type==INT);
		}
		free(err_msg);	

	}
	;
	retorno_funcion : TOK_RETURN exp  { 
		fprintf(logfile,";R61:	<retorno_funcion> ::= return <exp>\n"); 
		symbol * sim;
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_IDENT_DEFINED($2)
		else{
			CHECK_IS_VARIABLE(sim->key);
			if(tipo_retorno != sim->data_type){
				sprintf(err_msg,SEM_ERROR_INCOMPATIBLE_TYPES,GET_STR_FROM_TYPE(tipo_retorno),GET_STR_FROM_TYPE(sim->data_type));
				print_sem_error(err_msg);
			}
		}
		free(err_msg);	
		write_fn__ret(nasm_file,$2.es_direccion);
	} 
	;
	exp : exp '+' exp  { 
		fprintf(logfile,";R72:	<exp> ::= <exp> + <exp>\n"); 
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_INT_TYPES($$,$1,$3);
		free(err_msg);	
		write_expression(nasm_file,'+',$3.es_direccion + 2*$1.es_direccion);
		$$.es_direccion = 0;
	}
	| exp '-' exp  { 
		fprintf(logfile,";R73:	<exp> ::= <exp> - <exp>\n"); 
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_INT_TYPES($$,$1,$3);
		write_expression(nasm_file,'-',$3.es_direccion + 2*$1.es_direccion);
		free(err_msg);	

		$$.es_direccion = 0;
	}
	| exp '/' exp  { 
		fprintf(logfile,";R74:	<exp> ::= <exp> / <exp>\n"); 
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_INT_TYPES($$,$1,$3);
		write_expression(nasm_file,'/',$3.es_direccion + 2*$1.es_direccion);
		free(err_msg);	

		$$.es_direccion = 0;
	}
	| exp '*' exp  { 
		fprintf(logfile,";R75:	<exp> ::= <exp> * <exp>\n"); 
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_INT_TYPES($$,$1,$3);
		write_expression(nasm_file,'*',$3.es_direccion + 2*$1.es_direccion);
		free(err_msg);	

		$$.es_direccion = 0;
	}
	| '-' exp  { 
		fprintf(logfile,";R76:	<exp> ::= - <exp>\n"); 
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_INT_TYPE($$,$2);
		write_neg_expression(nasm_file,$2.es_direccion,0);
		free(err_msg);	


		$$.es_direccion = 0;
	}
	| exp TOK_AND exp  { 
		fprintf(logfile,";R77:	<exp> ::= <exp> && <exp>\n"); 
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_BOOLEAN_TYPES($$,$1,$3);
		write_expression(nasm_file,'&',$3.es_direccion + 2*$1.es_direccion);
		free(err_msg);	


		$$.es_direccion = 0;
	}
	| exp TOK_OR exp  { 
		fprintf(logfile,";R78:	<exp> ::= <exp> || <exp>\n"); 
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_BOOLEAN_TYPES($$,$1,$3);
		write_expression(nasm_file,'|',$3.es_direccion + 2*$1.es_direccion);
		free(err_msg);	


		$$.es_direccion = 0;
	}
	| '!' exp  { 
		fprintf(logfile,";R79:	<exp> ::= ! <exp>\n"); 
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_BOOLEAN_TYPE($$,$2);
		write_neg_expression(nasm_file,$2.es_direccion,1);
		free(err_msg);	


		$$.es_direccion = 0;
	}
	| '(' exp ')'  { 
		fprintf(logfile,";R82:	<exp> ::= ( <exp> )\n"); 
		$$.tipo = $2.tipo;
		$$.es_direccion = $2.es_direccion;
	}
	| '(' comparacion ')'  { 
		fprintf(logfile,";R83:	<exp> ::= ( <comparacion> )\n"); 
		$$.tipo = $2.tipo;
		$$.es_direccion = $2.es_direccion;
	}
	| TOK_IDENTIFICADOR  { 
		fprintf(logfile,";R80:	<exp> ::= <identificador>\n"); 
		symbol * sim;
		int is_local = 0;
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		if (ambito_actual == LOCAL){
			sim = search_symbol(tabla,$1.lexema,ambito_actual);

			if (!sim)
				sim = search_symbol(tabla,$1.lexema,GLOBAL);
			else
				is_local = 1;
		}else
			sim = search_symbol(tabla,$1.lexema,GLOBAL);

		if (sim)
		{
			if (!(sim->symbol_type != FUNCTION && sim->variable_type == ESCALAR)){
				sprintf(err_msg, SEM_ERROR_FUNCTION_NOT_ALLOWED,$1.lexema);
				sprintf(err_msg,"%s tipo_sim: %d, tipo_var %d",err_msg,sim->symbol_type, sim->variable_type);
				print_sem_error(err_msg);
			}else{
				$$.tipo = sim->data_type;
				$$.es_direccion = 1;
			}
		}
		else{
			sprintf(err_msg, SEM_ERROR_NOT_DEFINED ,$1.lexema);
			print_sem_error(err_msg);
		}
		free(err_msg);
		if (!is_local){
			if (en_explist){
				$$.es_direccion = 0;
				push_argument(nasm_file,$1.lexema,0);
			}
			else
				push_operator(nasm_file,$1.lexema);			
		} else {		
			$$.es_direccion = 0;
			if (sim->pos_local_variables == -1){
				write_fn__load_argument(nasm_file,num_parametro_actual,sim->pos_parameter,0);
			}else{
				write_fn__local_var(nasm_file,sim->pos_local_variables,0);
			}
		}

	}
	| constante  { 
		fprintf(logfile,";R81:	<exp> ::= <constante>\n"); 
		$$.tipo = $1.tipo;
		$$.es_direccion = 0;
		_write_cte(nasm_file,$1.valor_entero,line);
	}
	| elemento_vector  { 
		fprintf(logfile,";R85:	<exp> ::= <elemento_vector>\n"); 
		$$.es_direccion = $1.es_direccion;
		$$.tipo = $1.tipo;

		if (ambito_actual == LOCAL){
			$$.es_direccion = 0;
			write_fn__local_var(nasm_file,pos_variable_local_actual,0);
		}
	}
	| idf_llamada_funcion '(' lista_expresiones ')'  { 
		fprintf(logfile,";R88:	<exp> ::= <identificador> ( <lista_expresiones> )\n"); 
		symbol * sim = search_symbol(tabla,$1.lexema,ambito_actual);
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		if (sim)
		{
			if (sim->num_parameter > num_parametros_llamada_actual){
				sprintf(err_msg, SEM_ERROR_NEED_MORE_PARAM ,$1.lexema,sim->num_parameter,num_parametros_llamada_actual);
				print_sem_error(err_msg);					
			} else if (sim->num_parameter < num_parametros_llamada_actual){
				sprintf(err_msg, SEM_ERROR_TOO_MUCH_PARAM ,$1.lexema,sim->num_parameter,num_parametros_llamada_actual);
				print_sem_error(err_msg);					
			}else{
					/* Todo bien, todo correcto. Seguimos: */
				en_explist = 0;
				$$.tipo = sim->data_type;
				$$.es_direccion = 0;
				num_parametros_llamada_actual = 0;
			}
		}else{
			sprintf(err_msg, SEM_ERROR_FATAL ,$1.lexema);
			print_sem_error(err_msg);
		}
		free(err_msg);	
		write_fn__call(nasm_file,$1.lexema,sim->num_parameter);

	}
	;

	idf_llamada_funcion : TOK_IDENTIFICADOR {
		fprintf(logfile, ";R108.2 <llamada a funcion> ::= identificador\n");
		symbol * sim;
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_IDENT_DEFINED($1)
		else{
			CHECK_IS_FUNCTION(sim->key);
			if (en_explist == 1){
				sprintf(err_msg,SEM_ERROR_FUNCTION_NOT_ALLOWED,$1.lexema);
				print_sem_error(err_msg);
				num_parametros_llamada_actual = 0;
			}
			strcpy($$.lexema,$1.lexema);
		}
		free(err_msg);	

	}
	;

	ini_exp_l : {en_explist = 1;}

	lista_expresiones : ini_exp_l exp resto_lista_expresiones  {
		fprintf(logfile,";R89:	<lista_expresiones> ::= <exp> <resto_lista_expresiones>\n");
		num_parametros_llamada_actual++; 
	}
	|  {
		fprintf(logfile,";R90:	<lista_expresiones> ::= \n"); 
	}
	;
	resto_lista_expresiones : ',' exp resto_lista_expresiones  {
		fprintf(logfile,";R91:	<resto_lista_expresiones> ::= , <exp> <resto_lista_expresiones>\n"); 
		num_parametros_llamada_actual++; 
	}
	|  {
	 	fprintf(logfile,";R91:	<resto_lista_expresiones> ::= \n"); 
	}
	;

	comparacion : exp TOK_IGUAL exp  { 
		fprintf(logfile,";R93:	<comparacion> ::= <exp> == <exp>\n"); 
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		write_comparation(nasm_file,CMP_IGUAL,$3.es_direccion + 2*$1.es_direccion);
		CHECK_INT_TYPES($$,$1,$3);
		$$.tipo = BOOLEAN;	
		free(err_msg);
	}
	| exp TOK_DISTINTO exp  { 
		fprintf(logfile,";R94:	<comparacion> ::= <exp> != <exp>\n"); 
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		write_comparation(nasm_file,CMP_DISTINTO,$3.es_direccion + 2*$1.es_direccion);
		CHECK_INT_TYPES($$,$1,$3);
		$$.tipo = BOOLEAN; 
		free(err_msg);
	}
	| exp TOK_MENORIGUAL exp  { 
		fprintf(logfile,";R95:	<comparacion> ::= <exp> <= <exp>\n"); 
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_INT_TYPES($$,$1,$3);
		write_comparation(nasm_file,CMP_MENORIGUAL,$3.es_direccion + 2*$1.es_direccion);
		$$.tipo = BOOLEAN; 
		free(err_msg);
	}
	| exp TOK_MAYORIGUAL exp  { 
		fprintf(logfile,";R96:	<comparacion> ::= <exp> >= <exp>\n"); 
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_INT_TYPES($$,$1,$3);
		write_comparation(nasm_file,CMP_MAYORIGUAL,$3.es_direccion + 2*$1.es_direccion);
		$$.tipo = BOOLEAN; 
		free(err_msg);
	}
	| exp '<' exp  { 
		fprintf(logfile,";R97:	<comparacion> ::= <exp> < <exp>\n"); 
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_INT_TYPES($$,$1,$3);
		write_comparation(nasm_file,CMP_MENOR,$3.es_direccion + 2*$1.es_direccion);
		$$.tipo = BOOLEAN; 
		free(err_msg);
	}
	| exp '>' exp  { 
		fprintf(logfile,";R98:	<comparacion> ::= <exp> > <exp>\n"); 
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		write_comparation(nasm_file,CMP_MAYOR,$3.es_direccion + 2*$1.es_direccion);
		CHECK_INT_TYPES($$,$1,$3);
		$$.tipo = BOOLEAN; 
		free(err_msg);
	}
	;
	constante : constante_logica  { 
		fprintf(logfile,";R99:	<constante> ::= <constante_logica>\n"); 
		$$.tipo = $1.tipo;
	 	$$.es_direccion = $1.es_direccion;
	 	$$.valor_entero = $1.valor_entero;
	}
	| constante_entera  { 
		fprintf(logfile,";R100:	<constante> ::= <constante_entera>\n");  
		$$.tipo = $1.tipo;
	 	$$.es_direccion = $1.es_direccion;
	 	$$.valor_entero = $1.valor_entero;

	}
	;
	constante_logica : TOK_TRUE  {
			fprintf(logfile,";R102:	<constante_logica> ::= TOK_TRUE\n");
			$$.tipo = BOOLEAN;
			$$.es_direccion = 0;
			$$.valor_entero = TRUE_ASM;
			//_write_cte(nasm_file,TRUE_ASM,line);

	}
	| TOK_FALSE {
		fprintf(logfile,";R103:	<constante_logica> ::= TOK_FALSE\n"); 
		$$.tipo = BOOLEAN; 
		$$.es_direccion = 0;
		$$.valor_entero = FALSE_ASM;
		//_write_cte(nasm_file,FALSE_ASM,line);

	}
	;
	constante_entera : TOK_CONSTANTE_ENTERA {
		fprintf(logfile,";R104:	<constante_entera> ::= TOK_CONSTANTE_ENTERA\n"); 
		$$.tipo = INT; 
		$$.es_direccion = 0;
		$$.valor_entero = $1.valor_entero;
		//_write_cte(nasm_file,$1.valor_entero,line);

	}
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
			if (clase_actual == VECTOR)
				sim->size = tamanio_vector_actual;
			sim->symbol_type = VARIABLE;

			add_symbol(tabla,sim,ambito_actual);

			sim->pos_parameter = pos_parametro_actual;

			pos_parametro_actual++;
			num_parametro_actual++;
		}
		else{
			char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
			sprintf(err_msg, SEM_ERROR_ALREADY_DEF ,$1.lexema);
			print_sem_error(err_msg);
		}


	}

	identificador : TOK_IDENTIFICADOR {
		fprintf(logfile,";R108:	<identificador> ::= TOK_IDENTIFICADOR\n\t\t clase_actual: %s \t tipo_actual %s\n",clase_actual == ESCALAR ? "ESCALAR" : "VECTOR" ,tipo_actual == INT ? "INT" : "BOOLEAN"); 
		symbol * sim;
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_IDENT_NOT_DEFINED($1)
		else
		{
			if(clase_actual != ESCALAR && ambito_actual == LOCAL){
				print_sem_error(SEM_ERROR_JUST_ESCALAR_IN_LOCAL);
			}else{		
				sim = malloc(sizeof(symbol));
				initialize_simbolo(sim);
				strcpy(sim->key,$1.lexema);

				sim->data_type = tipo_actual;
				sim->variable_type = clase_actual;
				if (clase_actual == VECTOR)
					sim->size = tamanio_vector_actual;
				sim->symbol_type = VARIABLE;

				add_symbol(tabla,sim,ambito_actual);

				if (ambito_actual == LOCAL){
					sim->pos_local_variables = pos_variable_local_actual;
					pos_variable_local_actual++;
					num_variables_locales_actual++;
				}
			}
		}
		free(err_msg);
	}
	; 

	%%
