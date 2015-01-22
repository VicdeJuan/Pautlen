#!/bin/zsh

make
./alfa pruebas.alf a.asm
nasm -g -o alfa.o  -f elf32 a.asm
gcc -Wall -m32 -o alfa.exe alfa.o alfalib.o
./alfa.exe < in > out
