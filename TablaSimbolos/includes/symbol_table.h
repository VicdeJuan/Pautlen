#ifndef SYMBOL_H
#define SYMBOL_H

#include "dictionary.h"
#include "symbol.h"


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

/**
 * Inserts symbol into the symbol_table, globally or locally, depending on global.
 * @param  table   The table to added in.
 * @param  src_sym The symbol to be added.
 * @param  global  Whether the symbol is local or global.
 * @return         OK if inserted, ERR_REPEAT if already in it.
 */
int add_symbol(symbol_table * table, symbol * src_sym, int global);


/**
 * Searchs a symbol inside the symbol table depending on global (locally or globally)
 * @param  table   The symbol table with local and global tables.
 * @param  key	   The key of the symbol to be searched.
 * @param  global  Whether the symbol is local or global.
 * @return         The symbol if founded, null if not.
 */
symbol * search_symbol(symbol_table * table, char * key, int global);


/**
 * Close local ambit by cleaning local table
 * @param  table The symbol table to operate with.
 * @return       OK / ERR.
 */
int close_local_ambit(symbol_table * table);


/**
 * Look for a function with name key in the table.
 * @param  table  The symbol table to look into.
 * @param  key    The key of the function.
 * @param  global global search's just globally. LOCAL search's locally and globally.
 * @return        OK, ERR_NOTFOUND.
 */
int search_symbol__function(symbol_table * table, char * key, int global);


/**
 * Look for a variable with name key in the table.
 * @param  table  The symbol table to look into.
 * @param  key    The key of the function.
 * @param  global global search's just globally. LOCAL search's locally and globally.
 * @return        OK, ERR_NOTFOUND.
 */
int search_symbol__variale(symbol_table * table, char * key, int global);


/**
 * Look for a function with name key in the table.
 * @param  table  The symbol table to look into.
 * @param  key    The key of the function.
 * @param  global global search's just globally. LOCAL search's locally and globally.
 * @return        OK, ERR_NOTFOUND.
 */
int search_symbol__parameter(symbol_table * table, char * key, int global);
#endif