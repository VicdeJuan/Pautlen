#ifndef CODE_GENERATOR
#define CODE_GENERATOR 

#include <stdio.h>
#include "symbol_table.h"
#include <stdlib.h>

#define TRUE_ASM 1
#define FALSE_ASM 0

/**
 * Write one symbol
 * @param  key          Symbol's lexem
 * @param  value        Symbol struct stored in symbol_table
 * @param  pass_through File to write into
 * @return              OK
 */
int _write_variable(const void * key,void * value, void * pass_through);

void _write_bss_segment(FILE * f,symbol_table * tabla);	
void _write_text_segment(FILE * f);
void _write_data_segment(FILE * f);
/**
 * Write bss,data and text segments into file
 * @param  nasm_file File .asm to write into.
 * @param  tabla     The symbol table in which search the symbols defined.
 * @return           (if file != NULL) ? OK : ERR;
 */

int declare_global_variables(FILE * nasm_file,symbol_table * tabla);

/**
 * Write nasm code for execute errors.
 * @param nasm_file File to write into.
 */
void write_execute_errors(FILE * nasm_file);
#endif
