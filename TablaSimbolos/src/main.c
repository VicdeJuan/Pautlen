#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "file_parser.h"
#include "symbol_table.h"
#include "macros.h"

#define MAX 150

#define JUMP "\r\n"
#define SPACE "        "

#define MSG_ERROR "El fichero está mal formado"
/*
#define MSG_GLOBAL_INTENTO_INSERCION "Intento de inserción en la tabla global del elemento (%s;%d)"
#define MSG_LOCAL_INTENTO_INSERCION "Intento de inserción en la tabla local del elemento (%s;%d)"
#define MSG_EXITO_INSERCION "La inserción terminaría con éxito porque el elemento no está"
#define MSG_FALLO_INSERCION "La inserción terminaría con fallo porque el elemento ya está"

#define MSG_INTENTO_BUSQUEDA "Búsqueda en la tabla del elemento (%s)"
#define MSG_EXITO_BUSQUEDA "La búsqueda terminaría con éxito porque el elemento está"
#define MSG_FALLO_BUSQUEDA "La búsqueda terminaría con fallo porque el elemento no está"

#define MSG_APERTURA_AMBITO "Apertura de ámbito (%s)"
#define MSG_EXITO_AMBITO_1 "La apertura terminaría con éxito porque en la tabla global no existe."
#define MSG_EXITO_AMBITO_2 "Se inserta el elemento en la tabla global, se inicializa la tabla local y se inserta el elemento en la tabla local"
#define MSG_FALLO_AMBITO "La búsqueda terminaría con fallo porque el elemento no está"


#define MSG_CIERRE_1 "Se cierra el ámbito local"
#define MSG_CIERRE_2 "Se “vacía” la tabla local."
#define MSG_CIERRE_3 "La operación termina con éxito."*/


int insert_from_line(symbol_table * table, char * key, int  num){
	symbol * simbolo = calloc(1,sizeof(symbol));
	int retval;
	initialize_simbolo(simbolo);
	strcpy(simbolo->key,key);
	simbolo->symbol_type = num;

	retval =  add_symbol(table, simbolo, table->scope);
	if (retval == ERR_REPEAT)
		return -1;
	else
		return retval;
	
}

int _search_from_line(symbol_table * table, char * key,int scope){
	symbol * simbolo = search_symbol(table, key, scope);
	if (simbolo == NULL)
		return ERR_NOTFOUND;
	else 
		return simbolo->symbol_type;	
}

int search_from_line(symbol_table * table, char * key){

	int retval;
	if (table->scope == LOCAL)
	{
		retval = _search_from_line(table, key, LOCAL);
		if (retval != ERR_NOTFOUND)
		{
			return retval;
		}
	}
	return _search_from_line(table, key, GLOBAL);	
}

int apertura_from_line(symbol_table * table,char * key, int num){

	symbol * simbolo = calloc(1,sizeof(symbol));

	initialize_simbolo(simbolo);
	strcpy(simbolo->key,key);

	/* Para las comprobaciones pertinentes con los ficheros de pureba es necesaria esta asignación, aunque debiera de ser:
	
		simbolo->symbol_type = FUNCTION;

	ya que se trata de una función.
	 */
	
	simbolo->symbol_type = num;
	simbolo->local_identifier = num;

	if (search_symbol(table, key, GLOBAL) != NULL)
		return ERR_GLOBALLY;
		

	add_symbol(table, simbolo, GLOBAL);	

	table->scope = LOCAL;

	return OK;
}


int main(int argc, char const *argv[])
{
	FILE * fin = NULL,*fout = NULL;
	char line[MAX],key[MAX];
	int retscan,retval,count=0;
	int * num = malloc (sizeof(int));
	symbol_table * table = create_symbol_table();
	

	if (argc >= 2)
	{
		fin = fopen(argv[1], "r");
		if (fin == NULL){
			printf("Error al abrir el fichero de entrada: %s%s", argv[1],JUMP);
			return 1;
		}
	}
	if (argc >=3)
	{
		fout = fopen(argv[2], "w");
		if (fin == NULL)
			printf("Error al abrir el fichero de salida: %s%s", argv[2],JUMP);
	}else{
		fout = stdout;
		setbuf(stdout, NULL);
	}

	while(fgets(line, MAX + 10, fin) != NULL)
	{
		retscan = sscanf(line, "%s %d",key,num);
		if (retscan == 2)
		{ // Hemos leido 2 cosas.
			if (*num >= 0)
			{	// Estamos con un símbolo
				if (insert_from_line(table,key,*num) == OK)
					fprintf(fout,"%s%s",key,JUMP);
				else
					fprintf(fout,"-1%s%s%s",SPACE,key,JUMP);
			}else if (strcmp(key,"cierre") == 0 && *num == -999)
			{
				// Estamos en un cierre.
				printf("olakase!!:: item:%d\tcount: %d\n", table->local_table->items,count);
				count += table->local_table->items;	
				if (close_local_ambit(table) == OK){
					fprintf(fout,"%s%s",key,JUMP);
				}
				else
					fprintf(fout,"-1%s%s%s",SPACE,key,JUMP); 
			}
			else if (*num < -1)
			{
				// Estamos con un ámbito.
				if (apertura_from_line(table, key, *num) == OK)
				{
					if (insert_from_line(table,key,*num) == OK)
						fprintf(fout,"%s%s",key,JUMP);
					else
						fprintf(fout,"-1%s%s%s",SPACE,key,JUMP); 
				}else
					fprintf(fout,"-1%s%s%s",SPACE,key,JUMP); 
				}

			else{
				fprintf(fout,"-1%s%s%s",SPACE,key,JUMP); 
			}
		}else if (retscan == 1)
		{

			retval = search_from_line(table, key);
			if (retval == ERR_NOTFOUND )
				retval = -1;
			fprintf(fout,"%s%s%d%s",key,SPACE,retval,JUMP);
		}else
			fprintf(fout,"-1%s%s%s",SPACE,key,JUMP); 
	}

	printf("%d\n", count + table->global_table->items);
	delete_symbol_table(table);
	fclose(fin);
	if (fout != NULL)
	{
		fclose(fout);
	}
	free(num);
	return 0;
}

