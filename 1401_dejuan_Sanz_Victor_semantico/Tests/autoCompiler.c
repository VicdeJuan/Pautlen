/**
 * 
 * Proyecto de Autómatas y Lenguajes
 * Práctica 4. Analizador sintáctico. Lenguaje de Programación ALFA
 *
 * Grupo 1401
 * @author Juan Sidrach de Cardona Mora <juan.sidrach@estudiante.uam.es>
 *
 * @file autoCompiler.c
 * @brief AutoCompiler. Genera un ejecutable a partir de un .nasm
 *
 * @date 26/11/2013
 *
 */
#include <stdio.h>
#include <stdlib.h>

/*
 * @brief Genera un ejecutable a partir de un nasm
 *
 * @param[in] argc
 *    Número de argumentos
 * @param[in] argv[]
 *    Argumentos<ul>
 *    <li>_fichero_entrada_</li>
 *    <li>  Fichero de entrada (archivo alfa)</li>
 *    <li>_nombre_ejecutable_</li>
 *    <li>  Salida del programa (nombre del ejecutable)</li></ul>
 * @retval 0 Ejecución correcta
 * @retval -1 Error en la ejecución (parámetros o al abrir/compilar el fichero)
 */
int main(int argc, char* argv[]) {
  char str[1024];
  int ctrl;
  if(argc != 3){
    printf("\nError, argumentos erroneos\n");
    printf("%s <fichero_entrada> <nombre_ejecutable>\n", argv[0]);
    return -1;
  }

  printf("\n%s\n", argv[1]);
  snprintf(str, 1024, "./alfa %s salidaTemp.nasm", argv[1]);
  ctrl = system(str);
  if(ctrl != 0){
    system("rm -f objetoTemp.o salidaTemp.nasm");
    printf("\nError al ejecutar alfa\n");
    return -1;
  }
  ctrl = system("nasm -g -o objetoTemp.o -f elf32 salidaTemp.nasm");
  if(ctrl == -1){
    system("rm -f objetoTemp.o salidaTemp.nasm");
    printf("\nError al ejecutar nasm\n");
    return -1; 
  }
  snprintf(str, 1024, "gcc -o %s objetoTemp.o test/alfalib.o", argv[2]);
  ctrl = system(str);
  if(ctrl == -1){
    system("rm -f objetoTemp.o salidaTemp.nasm");
    printf("\nError al ejecutar gcc\n");
    return -1;
  }
  system("rm -f objetoTemp.o salidaTemp.nasm");
  return 0;
}