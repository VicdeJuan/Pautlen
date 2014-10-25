#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "file_parser.h"
#include "symbol_table.h"
#include "macros.h"

#define MAX 150

#define MSG_ERROR "El fichero está mal formado"

#define MSG_GLOBAL_INTENTO_INSERCION "Intento de inserción en la tabla global del elemento (%s;%d)\n"
#define MSG_LOCAL_INTENTO_INSERCION "Intento de inserción en la tabla local del elemento (%s;%d)\n"
#define MSG_EXITO_INSERCION "La inserción terminaría con éxito porque el elemento no está\n"
#define MSG_FALLO_INSERCION "La inserción terminaría con fallo porque el elemento ya está\n"

#define MSG_INTENTO_BUSQUEDA "Búsqueda en la tabla del elemento (%s)\n"
#define MSG_EXITO_BUSQUEDA "La búsqueda terminaría con éxito porque el elemento está\n"
#define MSG_FALLO_BUSQUEDA "La búsqueda terminaría con fallo porque el elemento no está\n"

#define MSG_APERTURA_AMBITO "Apertura de ámbito (%s)\n"
#define MSG_EXITO_AMBITO_1 "La apertura terminaría con éxito porque en la tabla global no existe.\n"
#define MSG_EXITO_AMBITO_2 "Se inserta el elemento en la tabla global, se inicializa la tabla local y se inserta el elemento en la tabla local\n"
#define MSG_FALLO_AMBITO "La búsqueda terminaría con fallo porque el elemento no está\n"


#define MSG_CIERRE_1 "Se cierra el ámbito local\n"
#define MSG_CIERRE_2 "Se “vacía” la tabla local.\n"
#define MSG_CIERRE_3 "La operación termina con éxito\n"


int insert_from_line(symbol_table * table, char * key, int  num){
	symbol simbolo; 

	initialize_simbolo(&simbolo);
	strcpy(simbolo.key,key);
	simbolo.data_type = num;

	return add_symbol(table, &simbolo, table->scope);
}

int search_from_line(symbol_table * table, char * key,int  num){

	/* Just in actual scope. */
	symbol * simbolo = search_symbol(table, key, table->scope);
	if (simbolo == NULL)
		return ERR_NOTFOUND;
	else if(simbolo->data_type == num){
		return OK;
	}
	else{
		return ERR_NOTTYPE;
	}
}

int apertura_from_line(symbol_table * table,char * key, int num){

	symbol simbolo;

	initialize_simbolo(&simbolo);
	strcpy(simbolo.key,key);
	simbolo.data_type = FUNCTION;
	simbolo.local_identifier = num;

	if (search_symbol(table, key, GLOBAL) != NULL)
		return ERR_GLOBALLY;
		

	add_symbol(table, &simbolo, GLOBAL);	

	table->scope = LOCAL;

	return OK;
}


int main(int argc, char const *argv[])
{
	FILE * fin = NULL,*fout = NULL;
	if (argc >= 1)
	{
		fin = fopen(argv[1], "r");
		if (fin == NULL)
			printf("Error al abrir el fichero de entrada: %s\n", argv[1]);
		return 1;
	}
	if (argc >=2)
	{
		fout = fopen(argv[2], "w");
		if (fin == NULL)
			printf("Error al abrir el fichero de salida: %s\n", argv[2]);
	}else
		fout = stdout;

	char line[MAX],key[MAX];
	int num,retscan;
	symbol_table * table = create_symbol_table();

	while(fgets(line, MAX + 10, fin) != NULL)
	{
		retscan = sscanf(line, "%s %d",key,&num);
		if (retscan == 2)
		{ // Hemos leido 2 cosas.
			if (num >= 0)
			{	// Estamos con un símbolo
				printf(MSG_GLOBAL_INTENTO_INSERCION, key,num);
				if (insert_from_line(table,key,num) == OK)
					printf(MSG_EXITO_INSERCION);
				else
					printf(MSG_FALLO_INSERCION);
			}else if (num < -1)
			{
				// Estamos con un ámbito.
				printf(MSG_APERTURA_AMBITO,key);
				if (apertura_from_line(table, key, num) == OK)
				{
					printf(MSG_EXITO_AMBITO_1);
					if (insert_from_line(table,key,num) == OK)
						printf(MSG_EXITO_AMBITO_2);
					else
						printf(MSG_ERROR);
				}else
					printf(MSG_ERROR);

			}else if (strcmp(key,"cierre") == 0 && num == -999)
			{
				// Estamos en un cierre.
				if (close_local_ambit(table) == OK)
					printf("%s%s%s",MSG_CIERRE_1,MSG_CIERRE_2,MSG_CIERRE_3);
				else
					printf(MSG_ERROR);
			}

			else{
				printf(MSG_ERROR);
			}
		}else if (retscan == 1)
		{
			printf(MSG_INTENTO_BUSQUEDA,key);
			if (search_from_line(table, key, LOCAL) == OK && search_from_line(table, key, GLOBAL) == OK)
				printf(MSG_EXITO_BUSQUEDA);
			else
				printf(MSG_FALLO_BUSQUEDA);
		}else
			printf(MSG_ERROR);
	}

	delete_symbol_table(table);
	fclose(fin);
	if (fout != NULL)
	{
		fclose(fout);
	}
	return 0;
}

