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
	fprintf(f, "MAX_TAMANIO_VECTOR db %d\n",MAX_TAMANIO_VECTOR);
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
	fprintf(nasm_file,"%s:\n",EXE_ERROR_RANGE);
	fprintf(nasm_file,"push dword err_msg_range\n");
	fprintf(nasm_file,"call print_string\n");
	fprintf(nasm_file,"add esp, 4\n");
	fprintf(nasm_file,"jmp near fin\n");
	fprintf(nasm_file,"%s: ",EXE_ERROR_ZERO);
	fprintf(nasm_file,"push dword err_msg_zero\n");
	fprintf(nasm_file,"call print_string\n");
	fprintf(nasm_file,"add esp, 4\n");
	fprintf(nasm_file,"jmp near fin\n");
	fprintf(nasm_file,"fin: ret\n");

}

void _write_cte(FILE * nasm_file, int val, int line){
	fprintf(nasm_file, "; numero_linea %d\n", line);
	fprintf(nasm_file, "\tpush dword %d\n", val);

}


void _load_2_operators(FILE * nasm_file, int direccion){
	fprintf(nasm_file,"; cargar el segundo operando en edx\n");
	fprintf(nasm_file,"pop dword edx\n");
	
	if ( (direccion & 1) == 1)
		fprintf(nasm_file,"mov dword edx , [edx]\n");
	
	fprintf(nasm_file,"; cargar el primer operando en eax\n");
	fprintf(nasm_file,"pop dword eax\n");

	if ( (direccion & 2) == 2)
		fprintf(nasm_file,"mov dword eax , [eax]\n");

}

void _load_1_operator(FILE * nasm_file, int direccion){
	fprintf(nasm_file,"; cargar el operando en eax\n");
	fprintf(nasm_file,"pop dword eax\n");
	
	if (direccion == 1)
		fprintf(nasm_file,"mov dword eax , [eax]\n");

}

void _push_eax(FILE * nasm_file){
	fprintf(nasm_file,"; apilar el resultado\n");
	fprintf(nasm_file,"push dword eax\n");
}


void write_expression(FILE * nasm_file, char operation,int direccion){
	
	_load_2_operators(nasm_file, direccion);

	switch (operation){
		case '+':
			fprintf(nasm_file,"; realizar la suma y dejar el resultado en eax\n");
			fprintf(nasm_file,"add eax, edx\n");

			break;
		case '-':
			fprintf(nasm_file,"; realizar la resta y dejar el resultado en eax\n");
			fprintf(nasm_file,"sub eax, edx\n");

			break;
		case '*':
			fprintf(nasm_file,"; realizar la multiplicación y dejar el resultado en eax\n");
			fprintf(nasm_file,"imul edx\n");
			break;

		case '/':
			fprintf(nasm_file,"; realizar la división y dejar el resultado en eax\n");
			/*Control división por 0.*/
			fprintf(nasm_file, "jz %s\n",EXE_ERROR_ZERO );
			fprintf(nasm_file,"idiv edx\n");
			break;
		case '&':
			fprintf(nasm_file, "and eax edx\n");
			break;
		case '|':
			fprintf(nasm_file, "or eax edx\n");
			break;

		default :
			fprintf(nasm_file, "; No definida operacion: %c\n",operation);
	}

	_push_eax(nasm_file);

}


void write_neg_expression(FILE * nasm_file,int direccion,int logic){
	_load_1_operator(nasm_file, direccion);
	
	if (!logic){
		fprintf(nasm_file,"; realizar la negación. El resultado en eax\n");
		fprintf(nasm_file,"neg eax\n");
	}
	else{
		fprintf(nasm_file,"or eax , eax\n");
		fprintf(nasm_file,"jz near negar_falso%d\n",tag_num);
		fprintf(nasm_file,"; cargar 0 en eax (negación de verdadero) y saltar al final\n");
		fprintf(nasm_file,"mov dword eax,0\n");
		fprintf(nasm_file,"jmp near fin_negacion%d\n",tag_num+1);
		fprintf(nasm_file,"; cargar 1 en eax (negación de falso)\n");
		fprintf(nasm_file,"negar_falso%d: mov dword eax,1\n",tag_num);
		fprintf(nasm_file,"; apilar eax\n");
		fprintf(nasm_file,"fin_negacion%d:\n",tag_num+1);
		tag_num+=2;
	}

	_push_eax(nasm_file);
}

void write_comparation(FILE * nasm_file,int operation, int direccion){
	_load_2_operators(nasm_file, direccion);

	fprintf(nasm_file,"; comparar y apilar el resultado\n");
	fprintf(nasm_file,"cmp eax, edx\n");
	switch (operation){
		case CMP_IGUAL:
			fprintf(nasm_file,"je near cmp%d\n",tag_num);
			break;
		case CMP_DISTINTO:
			fprintf(nasm_file,"jne near cmp%d\n",tag_num);
			break;
		case CMP_MENORIGUAL:
			fprintf(nasm_file,"jle near cmp%d\n",tag_num);
			break;
		case CMP_MAYORIGUAL:
			fprintf(nasm_file,"jge near cmp%d\n",tag_num);
			break;
		case CMP_MENOR:
			fprintf(nasm_file,"jl near cmp%d\n",tag_num);
			break;
		case CMP_MAYOR:
			fprintf(nasm_file,"jg near cmp%d\n",tag_num);
			break;
		default:
			break;
	}
	fprintf(nasm_file,"push dword 0\n");
	fprintf(nasm_file,"jmp near fin_cmp%d\n",tag_num+1);
	fprintf(nasm_file,"cmp%d:\n",tag_num);
 	fprintf(nasm_file,"push dword 1\n");
	fprintf(nasm_file,"fin_cmp%d:\n",tag_num+1);

	tag_num += 2;
	
	_push_eax(nasm_file);
}


void _load_vector_element(FILE * nasm_file,char * name){
	_load_1_operator(nasm_file, 0);

	fprintf(nasm_file,"cmp eax,0\n");
	fprintf(nasm_file,"jl near %s\n",EXE_ERROR_RANGE);
	fprintf(nasm_file,"; Si el índice es mayor de lo permitido , error en tiempo de ejecución\n");
	fprintf(nasm_file,"cmp eax, MAX_TAMANIO_VECTOR\n");
	/* El pdf dice jl. */
	fprintf(nasm_file,"jg near %s\n",EXE_ERROR_RANGE);

	fprintf(nasm_file,"; Cargar 4 en edx (no de bytes de cada elemento del vector)\n");
	fprintf(nasm_file,"mov dword edx, 4\n");
	fprintf(nasm_file,"; eax = eax*edx, es decir, eax = eax*4\n");
	fprintf(nasm_file,"imul edx\n");
	fprintf(nasm_file,"; Cargar en edx la dirección de inicio del vector\n");
	fprintf(nasm_file,"mov dword edx _%s\n",name);
	fprintf(nasm_file,"; Cargar en eax la dirección del elemento indexado\n");
	fprintf(nasm_file,"add eax, edx\n");
	fprintf(nasm_file,"; Apilar la dirección del elemento indexado\n");
	fprintf(nasm_file,"push dword eax\n");

}

void write_load_vector_element(FILE * nasm_file, char * name){
	_load_vector_element(nasm_file, name);
}

void write_assign(FILE * nasm_file, char * name,int direccion,int vector){
	_load_1_operator(nasm_file, direccion);

	if (!vector)
		fprintf(nasm_file, "mov dword [_%s] , eax\n",name);
	else
	{
		fprintf(nasm_file,"pop dword edx\n");
		fprintf(nasm_file,"; Hacer la asignación efectiva\n");
		fprintf(nasm_file,"mov dword [edx] , eax\n");
	}

	

}