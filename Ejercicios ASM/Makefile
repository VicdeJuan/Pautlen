all: compare

compare: compare.o 
	gcc -m32 -o compare.exe compare.o alfalib.o

compare.o: compare.asm
	nasm -g -o compare.o -f elf32 compare.asm
