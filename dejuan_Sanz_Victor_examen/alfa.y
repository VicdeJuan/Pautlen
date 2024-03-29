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

	int en_explist,num_parametros_llamada_actual,tipo_retorno,vector_size = 0;

	int tag_num;
	symbol_table * tabla;
	FILE * logfile;
	FILE * nasm_file;
	FILE * aux_nasm_file;

	void print_sem_error(char * msg){
		fprintf(stderr,"\t****Error semantico en lin %d debido a : %s\n",line,msg); 
		free(msg);
		delete_symbol_table(tabla);
		exit(0);
	}

	void yyerror(char* s){
		if (error == 0)
			fprintf(ERROR_IFACE_SINTA,"\t****Error sintactico en [lin %d, col %d]\n",line,column); 
		exit(0);
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
	%token <atributo> TOK_INIT

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
	%type <atributo> init_vector
	%type <atributo> ini_v_exp_list
	%type <atributo> init_vector_aux

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
		ambito_actual = GLOBAL;
		tamanio_vector_actual = NONE;
		pos_variable_local_actual = 1;
		num_variables_locales_actual = 0;
		pos_parametro_actual = 0;
		num_parametro_actual = 0;
		tag_num = 0;

		/* Inicializamos otras variables.*/
		nasm_file = yyout;

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
			vector_size = 1;
	}
	;
	identificadores : identificador  { fprintf(logfile,";R18:	<identificadores> ::= <identificador>\n"); }
	| identificador ',' identificadores  { fprintf(logfile,";R19:	<identificadores> ::= <identificador> , <identificadores>\n"); }
	;

	funciones : funcion funciones  { fprintf(logfile,";R20:	<funciones> ::= <funcion> <funciones>\n"); }
	|  { fprintf(logfile,";R21:	<funciones> ::= \n"); }
	;

	fn_name : TOK_FUNCTION tipo TOK_IDENTIFICADOR { 
		symbol * sim,*sim2;
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		int i;
		CHECK_IDENT_NOT_DEFINED($3)
		else{
			sim = malloc(sizeof(symbol));
			sim2 = malloc(sizeof(symbol));
			initialize_simbolo(sim);
			initialize_simbolo(sim2);
			strcpy(sim->key,$3.lexema);
			strcpy(sim2->key,$3.lexema);

			sim->data_type = tipo_actual;
			sim2->data_type = tipo_actual;
			sim->symbol_type = FUNCTION;
			sim2->symbol_type = FUNCTION;

			add_symbol(tabla,sim,LOCAL);
			add_symbol(tabla,sim2,GLOBAL);
			ambito_actual = LOCAL;
				

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
			sprintf(err_msg,SEM_ERROR__MISSING_RET,$1.lexema);
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
		CHECK_IDENT_DEFINED($2,1)
		else{
			sim->data_type = tipo_actual;
			tipo_actual = NONE;
			sim->variable_type = ESCALAR;
			sim->symbol_type = PARAMETER;
			free(err_msg);	
		}

	}
	;

	idpf : TOK_IDENTIFICADOR {
		if (ambito_actual != LOCAL)
			fprintf(logfile,"Tenemos un problema. Buscame y lo vemos");
		symbol * sim = search_symbol(tabla,$1.lexema,LOCAL);
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
			strcpy($$.lexema,$1.lexema);
		}
		else{
			char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
			sprintf(err_msg, SEM_ERROR__ALREADY_DEF);
			print_sem_error(err_msg);
		}


	}
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
	| init_vector { $$.hay_retorno = 0; }
	;
	bloque : condicional  { fprintf(logfile,";R40:	<blfoque> ::= <condicional>\n"); }
	| bucle  { fprintf(logfile,";R41:	<bloque> ::= <bucle>\n"); }
	;
	asignacion : TOK_IDENTIFICADOR '=' exp  { 
		fprintf(logfile,";R43:	<asignacion> ::= <identificador> = <exp>\n"); 
		symbol * sim;
		int is_local = 0;
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		sim = search_symbol(tabla,$1.lexema,ambito_actual);	
			if(!sim && ambito_actual == GLOBAL){
				sprintf(err_msg, SEM_ERROR__VAR_NOT_DEFINED ,$1.lexema);
				print_sem_error(err_msg);
			}else if (!sim){
				sim = search_symbol(tabla,$1.lexema,GLOBAL);
			}else{
				is_local = 1;
			}
			if (!sim){
				sprintf(err_msg, SEM_ERROR__VAR_NOT_DEFINED ,$1.lexema);
				print_sem_error(err_msg);
			}else {
			CHECK_IS_NOT_FUNCTION($1.lexema);
			if (sim->data_type != $3.tipo){
				sprintf(err_msg,SEM_ERROR__ASIG_INCOMPATIBLE_TYPES);
				print_sem_error(err_msg);
			}
			CHECK_IS_ESCALAR($1.lexema)
			if(ambito_actual != LOCAL)
				write_assign(nasm_file,$1.lexema,$3.es_direccion,0);
			else
				if(sim->symbol_type == PARAMETER)
					write_assign__local_param(nasm_file,num_parametro_actual,sim->pos_parameter,$3.es_direccion);
				else if(is_local)
					write_assign__local_var(nasm_file,sim->pos_local_variables,$3.es_direccion);
				else
					write_assign(nasm_file,$1.lexema,$3.es_direccion,0);
		}
		free(err_msg);	

	}
	| elemento_vector '=' exp { 
		fprintf(logfile,";R44:	<asignacion> ::= <elemento_vector> = <exp>\n"); 
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		if ($1.tipo == $3.tipo){
			$$.es_direccion = $1.es_direccion;
		}else{
			sprintf(err_msg,SEM_ERROR__ASIG_INCOMPATIBLE_TYPES);
			print_sem_error(err_msg);
		}

		write_assign(nasm_file,$1.lexema,$3.es_direccion,1);
		free(err_msg);	

	}
	;


	elemento_vector : TOK_IDENTIFICADOR '[' exp ']'  { 
		fprintf(logfile,";R48:	<elemento_vector> ::= <identificador> [ <exp> ]\n"); 
		symbol * sim;
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		sim = search_symbol(tabla,$1.lexema,ambito_actual);	
		if(!sim && ambito_actual == GLOBAL){
			sprintf(err_msg, SEM_ERROR__VAR_NOT_DEFINED ,$1.lexema);
			print_sem_error(err_msg);
		}else if (!sim){
			sim = search_symbol(tabla,$1.lexema,GLOBAL);	
		}
		if (!sim){
			sprintf(err_msg, SEM_ERROR__VAR_NOT_DEFINED ,$1.lexema);
			print_sem_error(err_msg);
		}
		else{
			CHECK_IS_VECTOR($1.lexema)
			if ($3.tipo != INT){
				sprintf(err_msg,SEM_ERROR__INTEGER_INDEX);
				print_sem_error(err_msg);
			}
			$$.tipo = sim->data_type;
			write_load_vector_element(nasm_file,$1.lexema,$3.es_direccion,en_explist,ambito_actual,sim->size);
		}

		if (en_explist)
			$$.es_direccion = 0;
		else
			$$.es_direccion = 1;
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
		CHECK_BOOLEAN_TYPE($$,$3,SEM_ERROR__CONDITION_WITH_INT)
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
		CHECK_BOOLEAN_TYPE($$,$3,SEM_ERROR__LOOP_WITH_INT)
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
		int is_local = 0;
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		sim = search_symbol(tabla,$2.lexema,ambito_actual);
		if (!sim && ambito_actual == LOCAL){
			sim = search_symbol(tabla,$2.lexema,GLOBAL);
			
		}else if (ambito_actual == LOCAL)
			is_local = 1;

		if(!sim){
			sprintf(err_msg, SEM_ERROR__VAR_NOT_DEFINED ,$2.lexema);
			print_sem_error(err_msg);
		}
		else{
			CHECK_IS_NOT_FUNCTION(sim->key);
			CHECK_IS_ESCALAR(sim->key);
			if(sim->symbol_type == PARAMETER)
				write_scanf__param(nasm_file,sim->key,sim->data_type==INT,num_parametro_actual, sim->pos_parameter);
			else if(is_local)
				write_scanf__var_local(nasm_file,sim->key,sim->data_type == INT, sim->pos_local_variables);
			else
				write_scanf__var(nasm_file,sim->key,sim->data_type==INT);
		}
		free(err_msg);	

	}
	;

	escritura : TOK_PRINTF exp { 
		fprintf(logfile,";R56:	<escritura> ::= printf <exp>\n"); 
		symbol * sim;
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));

		write_printf(nasm_file,$2.es_direccion,$2.tipo);

		free(err_msg);	

	}
	;
	retorno_funcion : TOK_RETURN exp  { 
		fprintf(logfile,";R61:	<retorno_funcion> ::= return <exp>\n"); 
		symbol * sim;
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		if(tipo_retorno != $2.tipo){
				sprintf(err_msg,SEM_ERROR__RET_INCOMPATIBLE_TYPES);
				print_sem_error(err_msg);
		}
		free(err_msg);	
		write_fn__ret(nasm_file,$2.es_direccion);
	} 
	;
	exp : exp '+' exp  { 
		fprintf(logfile,";R72:	<exp> ::= <exp> + <exp>\n"); 
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_INT_TYPES($$,$1,$3,SEM_ERROR__ARIT_WITH_BOOL);
		free(err_msg);	
		write_expression(nasm_file,'+',$3.es_direccion + 2*$1.es_direccion);
		$$.es_direccion = 0;
	}
	| exp '-' exp  { 
		fprintf(logfile,";R73:	<exp> ::= <exp> - <exp>\n"); 
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_INT_TYPES($$,$1,$3,SEM_ERROR__ARIT_WITH_BOOL);
		write_expression(nasm_file,'-',$3.es_direccion + 2*$1.es_direccion);
		free(err_msg);	

		$$.es_direccion = 0;
	}
	| exp '/' exp  { 
		fprintf(logfile,";R74:	<exp> ::= <exp> / <exp>\n"); 
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_INT_TYPES($$,$1,$3,SEM_ERROR__ARIT_WITH_BOOL);
		write_expression(nasm_file,'/',$3.es_direccion + 2*$1.es_direccion);
		free(err_msg);	

		$$.es_direccion = 0;
	}
	| exp '*' exp  { 
		fprintf(logfile,";R75:	<exp> ::= <exp> * <exp>\n"); 
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_INT_TYPES($$,$1,$3,SEM_ERROR__ARIT_WITH_BOOL);
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
		CHECK_BOOLEAN_TYPE($$,$2,SEM_ERROR__LOGIC_WITH_INT);
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
			if (!sim){
				sim = search_symbol(tabla,$1.lexema,GLOBAL);
			}
			else{
				is_local = 1;
			}
		}else
			sim = search_symbol(tabla,$1.lexema,GLOBAL);

		if (sim)
		{
			if (sim->symbol_type == FUNCTION ){
				sprintf(err_msg, SEM_ERROR__NOT_FUNCTION,$1.lexema);
				print_sem_error(err_msg);
			}else{
				CHECK_IS_ESCALAR($1);
				$$.tipo = sim->data_type;
				$$.es_direccion = 1;
			}
		}
		else{
			sprintf(err_msg,SEM_ERROR__VAR_NOT_DEFINED ,$1.lexema);
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


	}
	| idf_llamada_funcion '(' lista_expresiones ')'  { 
		fprintf(logfile,";R88:	<exp> ::= <identificador> ( <lista_expresiones> )\n"); 
		symbol * sim = search_symbol(tabla,$1.lexema,ambito_actual);
		if (!sim && ambito_actual == LOCAL)
			sim = search_symbol(tabla,$1.lexema,GLOBAL);

		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		if (sim)
		{
			if (sim->num_parameter > num_parametros_llamada_actual){
				sprintf(err_msg, SEM_ERROR__NEED_MORE_PARAM);
				print_sem_error(err_msg);					
			} else if (sim->num_parameter < num_parametros_llamada_actual){
				sprintf(err_msg, SEM_ERROR__TOO_MUCH_PARAM);
				print_sem_error(err_msg);					
			}else{
					/* Todo bien, todo correcto. Seguimos: */
				en_explist = 0;
				$$.tipo = sim->data_type;
				$$.es_direccion = 0;
				num_parametros_llamada_actual = 0;
			}
		}else{
			sprintf(err_msg, SEM_ERROR__FATAL ,$1.lexema);
			print_sem_error(err_msg);
		}
		free(err_msg);	
		write_fn__call(nasm_file,$1.lexema,sim->num_parameter);

	}
	;

	idf_llamada_funcion : TOK_IDENTIFICADOR {
		fprintf(logfile, ";R108.2 <llamada a funcion> ::= identificador\n");
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		symbol * sim = search_symbol(tabla,$1.lexema,ambito_actual);
		if (!sim && ambito_actual == LOCAL)
			sim = search_symbol(tabla,$1.lexema,GLOBAL);

		if (!sim){
			sprintf(err_msg,SEM_ERROR__FUN_NOT_DEFINED,$1.lexema);
			print_sem_error(err_msg);
			free(err_msg);
		}
		else{
			CHECK_IS_FUNCTION(sim->key);
			if (en_explist == 1){
				sprintf(err_msg,SEM_ERROR__FUNCTION_NOT_ALLOWED_AS_ARG);
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
		CHECK_INT_TYPES($$,$1,$3,SEM_ERROR__COMPARE_WITH_BOOL);
		$$.tipo = BOOLEAN;	
		free(err_msg);
	}
	| exp TOK_DISTINTO exp  { 
		fprintf(logfile,";R94:	<comparacion> ::= <exp> != <exp>\n"); 
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		write_comparation(nasm_file,CMP_DISTINTO,$3.es_direccion + 2*$1.es_direccion);
		CHECK_INT_TYPES($$,$1,$3,SEM_ERROR__COMPARE_WITH_BOOL);
		$$.tipo = BOOLEAN; 
		free(err_msg);
	}
	| exp TOK_MENORIGUAL exp  { 
		fprintf(logfile,";R95:	<comparacion> ::= <exp> <= <exp>\n"); 
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_INT_TYPES($$,$1,$3,SEM_ERROR__COMPARE_WITH_BOOL);
		write_comparation(nasm_file,CMP_MENORIGUAL,$3.es_direccion + 2*$1.es_direccion);
		$$.tipo = BOOLEAN; 
		free(err_msg);
	}
	| exp TOK_MAYORIGUAL exp  { 
		fprintf(logfile,";R96:	<comparacion> ::= <exp> >= <exp>\n"); 
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_INT_TYPES($$,$1,$3,SEM_ERROR__COMPARE_WITH_BOOL);
		write_comparation(nasm_file,CMP_MAYORIGUAL,$3.es_direccion + 2*$1.es_direccion);
		$$.tipo = BOOLEAN; 
		free(err_msg);
	}
	| exp '<' exp  { 
		fprintf(logfile,";R97:	<comparacion> ::= <exp> < <exp>\n"); 
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_INT_TYPES($$,$1,$3,SEM_ERROR__COMPARE_WITH_BOOL);
		write_comparation(nasm_file,CMP_MENOR,$3.es_direccion + 2*$1.es_direccion);
		$$.tipo = BOOLEAN; 
		free(err_msg);
	}
	| exp '>' exp  { 
		fprintf(logfile,";R98:	<comparacion> ::= <exp> > <exp>\n"); 
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		write_comparation(nasm_file,CMP_MAYOR,$3.es_direccion + 2*$1.es_direccion);
		CHECK_INT_TYPES($$,$1,$3,SEM_ERROR__COMPARE_WITH_BOOL);
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

	

	identificador : TOK_IDENTIFICADOR {
		fprintf(logfile,";R108:	<identificador> ::= TOK_IDENTIFICADOR\n\t\t clase_actual: %s \t tipo_actual %s\n",clase_actual == ESCALAR ? "ESCALAR" : "VECTOR" ,tipo_actual == INT ? "INT" : "BOOLEAN"); 
		symbol * sim;
		char * err_msg = calloc (MAX_LONG_ID + 50,sizeof(char));
		CHECK_IDENT_NOT_DEFINED($1)
		else
		{
			if(clase_actual != ESCALAR && ambito_actual == LOCAL){
				print_sem_error(SEM_ERROR__LOCAL_NOT_ESCALAR);
			}else{		
				sim = malloc(sizeof(symbol));
				initialize_simbolo(sim);
				strcpy(sim->key,$1.lexema);

				sim->data_type = tipo_actual;
				sim->variable_type = clase_actual;
				if (clase_actual == VECTOR){
					if (vector_size){
						sprintf(err_msg, SEM_ERROR__VECTOR_SIZE,$1.lexema);
						print_sem_error(err_msg);
					}
					sim->size = tamanio_vector_actual;
				}
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


	init_vector : TOK_INIT TOK_IDENTIFICADOR init_vector_aux {
		symbol * sim;
		char * err_msg = calloc(MAX_LONG_ID + 50,sizeof(char));
		sim = search_symbol(tabla,$2.lexema,ambito_actual);
		if(!sim && ambito_actual == GLOBAL){
			sprintf(err_msg, SEM_ERROR__VAR_NOT_DEFINED ,$2.lexema);
			print_sem_error(err_msg);
		}else if (!sim){
			sim = search_symbol(tabla,$2.lexema,GLOBAL);	
		}
		if (!sim){
			sprintf(err_msg, SEM_ERROR__VAR_NOT_DEFINED ,$2.lexema);
			print_sem_error(err_msg);
		}
		else{
			if ( sim->variable_type != VECTOR ){
				sprintf(err_msg,SEM_ERROR__INIT_NOT_VECTOR);
				print_sem_error(err_msg);
			}else{
				/* Es un vector definido, local o globalmente. */
				if ($3.indice_vector >= sim->size) {
					sprintf(err_msg, SEM_ERROR__INIT_TOO_MUCH);
					print_sem_error(err_msg);
				}else if ($3.tipo != sim->data_type) {
					sprintf(err_msg,SEM_ERROR__INCOMPATIBLE_TYPES);
					print_sem_error(err_msg);
				}else{
					$$.indice_vector = $3.indice_vector;
				}
			}
		}
		int i;
		for (i = $3.indice_vector; i >= 0 ; i--)
		{
			write_examen__init(nasm_file,$2.lexema, i,$3.es_direccion >> i & 1,1);
		}
		for (i = sim->size; i> $3.indice_vector; i--){
			write_examen__init(nasm_file,$2.lexema, i,0,0);
		}
	}

	init_vector_aux : '{' ini_v_exp_list '}' {
		$$.tipo = $2.tipo;
		$$.indice_vector = $2.indice_vector;
		$$.es_direccion = $2.es_direccion;
	}

	ini_v_exp_list : exp {
		$$.indice_vector = 0;
		$$.tipo = $1.tipo;
		$$.es_direccion = $1.es_direccion;
	}
	| exp ';' ini_v_exp_list {
		char * err_msg = calloc(MAX_LONG_ID + 50,sizeof(char));

		$$.indice_vector = $3.indice_vector + 1;
		/* Check types */
		if ($1.tipo != $3.tipo) {
			$$.tipo = $1.tipo;
			sprintf(err_msg,SEM_ERROR__INCOMPATIBLE_TYPES);
			print_sem_error(err_msg);
		}
		$$.es_direccion = $3.es_direccion * 2 + $1.es_direccion;
	}

	%%
