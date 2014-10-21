#include "symbol_table.h"

#include <stdio.h>
#include <stdlib.h>


symbol_table *  create_symbol_table(){

symbol_table * ret_table = (symbol_table *) calloc (sizeof(symbol_table),1);

	if (ret_table == NULL)
	{
		return NULL;
	}

	ret_table->global_table = dic_new_withstr();
	if (ret_table->global_table == NULL)
	{
		free(ret_table);
		return NULL;
	}

	ret_table->local_table = dic_new_withstr();
	if (ret_table->local_table == NULL)
	{
		free(ret_table->global_table);
		free(ret_table);
		return NULL;
	}

	return ret_table;
}


void delete_symbol_table(symbol_table *table){
	dic_destroy(table->global_table, NULL);
	dic_destroy(table->local_table, NULL);
	free(table);
}


int delete_local_table(symbol_table * table){
	dic_destroy(table->local_table, NULL);
	table->local_table = dic_new_withstr();
	
	if (table->local_table == NULL)
		return 0;

	return 1;	
}

