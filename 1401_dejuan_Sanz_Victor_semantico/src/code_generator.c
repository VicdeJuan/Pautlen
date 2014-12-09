#include "code_generator.h"

int _write_variable(const void * key,void * value, void * pass_through){
	FILE * nasm_file = (FILE *) pass_through;
	symbol * sim = (symbol *) value;
	char * lexema = (char *) key;
	int size = 1;
	if (sim->variable_type == VECTOR)
		size = sim->size;
	fprintf(nasm_file, "\t_%s resd %d\n",lexema,size);

	return OK;
}

void _write_text_segment(FILE * f){
	fprintf(f, "segment .text\nglobal main\nextern scan_int, scan_boolean\nextern print_int, print_boolean, print_string, print_blank, print_endofline\n;\n; código correspondiente a la compilación del no terminal “funciones\"\n;\nmain:\n");
}

void _write_bss_segment(FILE * f,symbol_table * tabla){	
	fprintf(f, "segment .bss\n");
	dic_iterate(tabla->global_table, _write_variable, f);
}

void _write_data_segment(FILE * f){
	fprintf(f, "segment .data\n");
	fprintf(f,"err_msg_range db \"Indice fuera de rango\" , 0\n");
	fprintf(f,"err_msg_zero db \"División por cero\" , 0\n");
}

int declare_global_variables(FILE * nasm_file,symbol_table * tabla){

	if (nasm_file == NULL)
		return ERR;

	_write_bss_segment(nasm_file,tabla);
	fprintf(nasm_file, "\n");
	
	_write_data_segment(nasm_file);
	fprintf(nasm_file, "\n");

	_write_text_segment(nasm_file);
	fprintf(nasm_file, "\n");


	return 1;
}


void write_execute_errors(FILE * nasm_file){
	fprintf(nasm_file,"error_1:");
	fprintf(nasm_file,"push dword err_msg_range");
	fprintf(nasm_file,"call print_string");
	fprintf(nasm_file,"add esp, 4");
	fprintf(nasm_file,"jmp near fin");
	fprintf(nasm_file,"error_2: ");
	fprintf(nasm_file,"push dword err_msg_zero");
	fprintf(nasm_file,"call print_string");
	fprintf(nasm_file,"add esp, 4");
	fprintf(nasm_file,"jmp near fin");
	fprintf(nasm_file,"fin: ret");

}