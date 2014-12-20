#ifndef FUNCTION_GENERATOR_H
#define FUNCTION_GENERATOR_H 

#include <stdio.h>
#include "symbol_table.h"
#include <stdlib.h>

void __write_fn__ret(FILE * nasm_file);
void write_fn__ret(FILE * nasm_file,int direccion);
void write_fn__begin(FILE * nasm_file, char * name, int variables, int parametros);

void write_fn__call(FILE * nasm_file, char * name,int args);

/**
 * 
 * @param nasm_file [description]
 * @param name      NULL if int is to push
 * @param arg       [description]
 */
void push_argument(FILE * nasm_file, char * name, int arg);

void _push_eax(FILE * nasm_file);


void write_fn__local_var(FILE * nasm_file,int pos,int dir);

void write_fn__load_argument(FILE * nasm_file,int total,int pos,int dir);

/*

[ebp-4*i] : i variable local (empezando en 1).
[ebp+8] : último argumento.
[ebp+4*(numero - i)] : iesimo.
[ebp+4*num] : primero.
*/

#endif