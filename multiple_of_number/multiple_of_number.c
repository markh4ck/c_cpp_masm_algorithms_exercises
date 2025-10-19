// Marc Aliaga


// algoritmo que cuante enteros positivos inferiores a 1000 que sean multiples de 11.

//pseudocodigo

/*

var

n,contador: entero;
centenas,decenas,unidades: entero;
digitos : booleanos;

fvar

contador := 0;
n := 1;

mientras n< 1000 hacer
  
 si n < 10 
 digitos := falso;

 sino
   si n < 100 entonces
   digitos := (n mod 11) = 0

   sino 
   si n < 1000
    
   centenas = n DIV 100
   decenas = (n DIV 10) mod 10
   unidades = n MOD 10
   digitos := (centenas - decenas + unidades) mod 11) = 0;

   fsi
 fsi

 n:= n + 1

finmientras

Escribir "cantidad de multiplos de 11:" , contador

fi
*/



#include <stdio.h>
#include <stdbool.h>

int main()
{
    int n, contador;
    int centenas, decenas, unidades;
    bool digitos;

    contador = 0;
    n = 1;

    while (n < 1000) {

        if (n < 10) {
            digitos = false;
        } 
        else {
            if (n < 100) {
                digitos = (n % 11) == 0;
            } 
            else if (n < 1000) {
                centenas = n / 100;
                decenas = (n / 10) % 10;
                unidades = n % 10;
                digitos = ((centenas - decenas + unidades) % 11) == 0;
            }
        }

        if (digitos) {
            contador++;
        }

        n = n + 1;
    }

    printf("Cantidad de multiplos de 11: %d\n", contador);

    return 0;
}
