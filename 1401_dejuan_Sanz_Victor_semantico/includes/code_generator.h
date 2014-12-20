#ifndef CODE_GENERATOR
#define CODE_GENERATOR 

#include "function_generator.h"


#define TRUE_ASM 1
#define FALSE_ASM 0

#define CMP_IGUAL 1
#define CMP_DISTINTO 2
#define CMP_MENORIGUAL 3
#define CMP_MAYORIGUAL 4
#define CMP_MENOR 5
#define CMP_MAYOR 6


extern int tag_num;
#define EXE_ERROR_RANGE "error_1"
#define EXE_ERROR_ZERO "error_2"

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
void push_operator(FILE * nasm_file, char * name);
void push_2_operators(FILE * nasm_file, char * name1, char * name2, int direccion);

/**
 * Writes nasm code for operations	
 * @param nasm_file File to write into.
 * @param operation Character indicating operation to generate code for . +,-,*,/,& (and),| (or).
 * @param direccion Whether is a direction or not the operators. 1 if first is memory direction, 2 if second and 3 if both.
 */
void write_expression(FILE * nasm_file, char operation,int direccion);

/**
 * Writes nasm code for operations
 * @param nasm_file  File to write into.
 * @param operation Boolean. True if  is logic, false if aritmetic
 * @param direccion Whether the operand is memory direcction or not.
 */
void write_neg_expression(FILE * nasm_file,int direccion,int logic);

/**
 * Writes nasm code for loading vector element.
 * @param nasm_file File to write into.
 * @param name      Vector's name.	
 */
void write_load_vector_element(FILE * nasm_file, char * name, int direccion,int is_arg,int scope,int size);

/**
 * Writes nasm code for assignments.
 * @param nasm_file File to write into.
 * @param name      Name.	
 * @param direccion Whether the operand is memory direcction or not.
 * @param name      Whether is a vector or not.	
 */
void write_assign(FILE * nasm_file,char * name,int direccion,int vector);

/**
 * 
 * @param nasm_file 
 * @param name      
 * @param integer   true if it's an integer, false if bool
 */
void write_scanf(FILE * nasm_file, char * name, int integer);

/**
 * 
 * @param nasm_file 
 * @param name      
 * @param integer   true if it's an integer, false if bool
 */
void write_printf(FILE * nasm_file, int es_direccion,int integer);



void write_if_exp__begin(FILE * nasm_file,int direccion,int tag);
void write_else_exp__mid(FILE * nasm_file, int tag);
void write_else_exp__end(FILE * nasm_file, int tag);

#endif

