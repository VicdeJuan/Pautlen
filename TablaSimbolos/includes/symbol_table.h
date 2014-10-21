#ifndef SYMBOL_H
#define SYMBOL_H

#include "dictionary.h"
#include "simbolo.h"


typedef struct 
{
	dictionary * global_table;
	dictionary * local_table;

}symbol_table;



/**
 * Create empty symbol table.
 * @return       the symbol table if success, null if error.
 */
symbol_table *  create_symbol_table();

/**
 * Deletes all the symbol table.
 * @param  table the table to be deleted.
 * @return       Error code.
 */
void delete_symbol_table(symbol_table * table);

/**
 * Cleans the local table of our symbol table.
 * @param  table the symbol table.
 * @return       Error code.
 */
int delete_local_table(symbol_table * table);

int add_symbol(symbol_table * table, simbolo * src_sym);

#endif