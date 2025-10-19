.386
.model flat, stdcall
.stack 4096


includelib kernel32.lib

ExitProcess PROTO :DWORD
GetStdHandle PROTO :DWORD
WriteConsoleA PROTO :DWORD, :DWORD, :DWORD, :DWORD, :DWORD

STD_OUTPUT_HANDLE EQU -11


.data 
bytes_written dd ?
mensaje db "Cantidad de multiplos de 11: ",0 ;db = define byte (cada char e sunbyte)
buffer db 16 dup(0) ; array de 16 bytes
contador dd 0 ;double word 4 bytes
handle dd ? ;guardamos el valor del handle

.code 
main PROC

push STD_OUTPUT_HANDLE
call GetStdHandle
mov [handle], eax


mov ecx, 1 ; hace como la variable n en C
mov ebx, 0 ; hace de conador para el "main" como en C


;PARTE 1
bucle:
;------------While(n<100){} ---------------
cmp ecx, 1000        
jge fin_bucle ; este salto, solo s eejecuta si ecx es mas grand o igual a 1000. 
;jump if is greater or equal


mov eax, ecx ; movemos el valor de ecx a eax para hacer la division.
cdq ;convertimos de 32 bits a 64 EDX:EAX
mov esi, 11 ;cargamos el divisor
div esi ; EDX:EAX / ESI



;-------- if (n % 11 == 0) {
;   contador++; } ----------------

;Una vez hecha la division, el modulo se guarda en EDX y el cociente en EAX
cmp edx, 0 ; si el modulo no es 0, entonces "n" no es un multiplo
jne no_multiplo ; jump not equal
inc ebx; +ebx


no_multiplo:
inc ecx; n++
jmp bucle; volvamos hacer el bucle con el nuevo valor en n



;PARTE 2 (suponiendo que ahora n ha llegado a 1000
;vaos a convertir los numeor sa ASCII para mostrar por std::out

fin_bucle:
mov [contador], ebx
; aqui lo qu ehacemos es pasar el valor del registor ebx que acuaba como
;contador, a la direccion de memoria reservada para ese vlaor .
; pasamos de CPU a RAM, ebx --->  [EBP-x] donde x es un numero R

mov eax, [contador]
; esta parte esta ilustrada en la imagen 2.
;pero lo qu ehacemos aqui es ir rellenando el buffer empezanod desde la ultima posicion. 
lea edi, buffer + 15 ;obtenemos la direccion base "EBP" del buffer y le sumamos el offset +15 para ir al final
mov byte ptr [edi], 0


mov ebx, edi      ; Usamos EBX para guardar la dirección de inicio del número. Lo inicializamos al final.
cmp eax, 0
je es_cero        ; Salta si el contador es 0 (no se ejecutaría el bucle)
jmp inicio_conv_bucle

es_cero:
dec edi           ; Retrocede a buffer + 14
mov byte ptr [edi], '0' ; Escribe el '0'
mov ebx, edi      ; EBX ahora apunta al primer dígito ('0')
jmp fin_conv_bucle

inicio_conv_bucle:
;inicio del bucle de conversion de numeros Reales a ascii

conv_bucle:
dec edi ; vamos a buffer +14
xor edx, edx ; limpiamos xor

;EAX = 123
;EDX = 0
;ECX = 10
; div ECX = EAX:EDX/10 = EAX=12 EDX = 3
; add dl , "0" = 3 + 48 = 51. dl es la parte baja de EDX

mov ecx, 10
div ecx
add dl, "0"
mov [edi], dl
mov ebx, edi      

test eax, eax
jnz conv_bucle

fin_conv_bucle:
; --------------------------------------------------

; mostramos el mesnaje.
;BOOL WriteConsoleA(
;   HANDLE  hConsoleOutput,
;   LPCVOID lpBuffer,
;   DWORD   nNumberOfCharsToWrite,
;   LPDWORD lpNumberOfCharsWritten,
;   LPVOID  lpReserved
;)

push 0                      ;lpReserved
push offset bytes_written   ;LPDWORD lpNumberOfCharsWritten
push 29                     ;NumberOfCharsToWrite ("Cantidad de multiplos de 11: ")
lea eax, [mensaje]          ;direccion de 'mensaje'
push eax                    ;lpBuffer
push dword ptr [handle]     ;hConsoleOutput
call WriteConsoleA

lea eax, buffer + 15
sub eax, ebx          

push 0                      ;lpReserved
push offset bytes_written   ;LPDWORD lpNumberOfCharsWritten
push eax                    ;NumberOfCharsToWrite (longitud de numeros)
push ebx                    ;lpBuffer (Address of the first digit)
push dword ptr [handle]     ;hConsoleOutput
call WriteConsoleA


push 0
call ExitProcess

main ENDP
END main