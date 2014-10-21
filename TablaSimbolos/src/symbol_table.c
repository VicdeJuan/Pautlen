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

int add_symbol(symbol_table * table, simbolo * src_sym, int global){
	
	if (global)
	{
		if (dic_lookup(table->global_table, src_sym->key) == NULL)
			return dic_add(table->global_table, src_sym->key, src_sym);
		else
			return ERR_REPEAT;
	}else{
		if (dic_lookup(table->local_table,  src_sym->key) == NULL)
			return dic_add(table->local_table, src_sym->key, src_sym);
		else
			return ERR_REPEAT;
	}

}

