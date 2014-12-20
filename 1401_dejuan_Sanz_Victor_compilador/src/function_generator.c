#include "function_generator.h"

void _push_eax(FILE * nasm_file){
	fprintf(nasm_file,"; apilar el resultado\n");
	fprintf(nasm_file,"push dword eax\n");
}


void write_fn__begin(FILE * nasm_file, char * name, int variables, int parametros){
	fprintf(nasm_file,"_%s:\n",name);
	fprintf(nasm_file,"push dword ebp\n");
	fprintf(nasm_file,"mov ebp, esp\n");
	fprintf(nasm_file,"sub esp, %d\n",4*variables);
}


void write_fn__ret(FILE * nasm_file, int direccion){
	fprintf(nasm_file, "pop dword eax\n");
	if (direccion)
		fprintf(nasm_file, "mov eax,[eax]\n");
	__write_fn__ret(nasm_file);
}

void __write_fn__ret(FILE * nasm_file){
	fprintf(nasm_file,"mov esp, ebp\n");
	fprintf(nasm_file,"pop ebp\n");
	fprintf(nasm_file,"ret\n");
}

void push_argument(FILE * nasm_file, char * name, int arg){
	if (!name){
		fprintf(nasm_file, "push dword %d\n", arg);
	}else{
		fprintf(nasm_file, "push dword [_%s]\n", name);
	}
}

void write_fn__load_argument(FILE * nasm_file,int total,int pos,int dir){
	if(dir){
		fprintf(nasm_file, "lea eax, [ebp + 4 + 4 * (%d - %d)]\n",total,pos);
		fprintf(nasm_file, "push dword eax\n");		
	}else{
		fprintf(nasm_file, "push dword [ebp + 4 + 4 * (%d - %d)]\n",total,pos);
	}

}

void write_fn__local_var(FILE * nasm_file,int pos,int dir){
	if (dir){
		fprintf(nasm_file, "lea eax, [ebp - 4 * %d]\n",pos);
		fprintf(nasm_file, "push dword eax\n");
	}else{
		fprintf(nasm_file, "push dword [ebp - 4*%d]\n", pos);
	}
}


void write_fn__call(FILE * nasm_file, char * name,int args){
	fprintf(nasm_file, "call _%s\n", name);
	fprintf(nasm_file, "add esp, %d\n",args*4);
	_push_eax(nasm_file);
}



