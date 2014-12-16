#!/bin/zsh

make
./alfa pruebas.alf
nasm -g -o alfa.o  -f elf32 alfa.asm
gcc -ggdb -m32 -o alfa.exe alfa.o Tests/alfalib.o
./alfa.exe 