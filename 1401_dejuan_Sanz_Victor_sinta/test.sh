#!/bin/bash
./pruebaSintactico pruebas/entrada_sin_1.txt .result1 &&  diff -bB .result1 pruebas/salida_sin_1.txt > .finres
./pruebaSintactico pruebas/entrada_sin_2.txt .result2 && diff -bB .result2 pruebas/salida_sin_2.txt >> .finres
./pruebaSintactico pruebas/entrada_sin_3.txt .result3 && diff -bB .result3 pruebas/salida_sin_3.txt >> .finres

cat .finres
