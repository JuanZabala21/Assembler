;EMU8086       

org 100h
include 'emu8086.inc' ;Incluye funciones de la libreria emu8086 
DEFINE_SCAN_NUM
DEFINE_PRINT_STRING
DEFINE_PRINT_NUM
DEFINE_PRINT_NUM_UNS
.stack 64

.DATA
    Struct0A EQU $                  ; Buffer para INT 21h/0Ah 
        max db 100                  ; Caracteres maximos que el buffer soporta, incluyendo salto de linea
        got db 0                    ; Numero de caracteres realmente leidos, excluyendo salto de linea
        buf db 100 dup (0)          ; Caracteres actualmente leidos, incluyendo salto de linea
    Linefeed db 13, 10, '$'
    Cadena   db 13, 10, 'Introduzca una palabra: $'

.data
cabecera db 13,10,'Bienvenido/a',13,10,13,10,'----- MENU PRINCIPAL -----',13,10,13,10,'$'

;MENSAJES
opciones db '1- Banderas',13,10,
db '2- Movimiento de una imagen en pantalla',13,10,
db '3- Operaciones Matematicas',13,10,
db '4- Ordenador Alfabetico',13,10,
db 'Pulse cualquier otra tecla para salir',13,10,
db 13,10,'Elija una opcion: $'

mensaje1 db 'Pulse cualquier tecla para volver al menu principal',13,10,'$'
mensaje2 db 'Presione cualquier tecla para iniciar',13,10,'$'
mensaje3 db 'Pantalla en color gris con letras negras',13,10,'$'
mensaje4 db '    Desplacese con las flechas de direccion' ,13,10,'$'
mensaje5 db 13,10,'Escriba el Primer Numero: $' 
mensaje6 db 13,10,'Escriba el Segundo Numero: $'
mensaje7 db 13,10,'La Suma Es: $' 
mensaje8 db 13,10,'La Resta Es: $' 
mensaje9 db 13,10,'La Multiplicacion Es: $' 
mensaje10 db 13,10,'La Divison es: $' 
mensaje11 db 13,10,'Escoja una bandera: $'
mensaje12 db 13,10,'1. Venezuela$'
mensaje13 db 13,10,'2. Paraguay$' 
mensaje14 db 13,10,'3. Italia$'
espacio db 13,10, '$'

.code   


  
;variables 
num1 dw ? ;defino variables de 2 bytes
num2 dw ? ; en un futuro almacenaran 2 numeros para realizar las operaciones aritmeticas



          
inicio:    

 mov ax,@data     ;llamada a data para poder trabajar con los datos anteriormente creados
 mov ds,ax        
 
 lea dx,cabecera    ;imprimir cabecera 
 mov ah,9h
 int 21h
 
 lea dx,opciones   ;imprimir menu
 mov ah,9h
 int 21h
 ;---------------------------------------------------
 mov ah,08              ;Espera que el usuario presione una tecla
 int 21h                ;Interrupcion para obtener lo tecleado por el usuario
 cmp al,49              ;Se compara lo obtenido desde el tecleado con el valor ascii del numero 1
 je Banderas            ;Si son iguales se ejecuta la funcion banderas
 cmp al,50              ;Se compara lo obtenido desde el tecleado con el valor ascii del numero 2
 je MoverImagen    ;Si son iguales se ejecuta la funcion MoverImagen 
 cmp al,51              ;Se compara lo obtenido desde el tecleado con el valor ascii del numero 3
 je Operaciones         ;Si son iguales se ejecuta la funcion operaciones
 cmp al,52              ;Se compara lo obtenido desde el tecleado con el valor ascii del numero 4
 je Alfabeto            ;Si son iguales se ejecuta la funcion alfabeto
 jmp fin                ;Si ninguna de las comparaciones es correcta se ejecuta el fin

fin:
 mov ax,4c00h       ;Funcion que termina el programa
 int 21h 
 
limpiar:            ;Funcion que limpia completamente la pantalla y ejecuta el inicio 
    mov ax,0600H
    mov bh,07h
    mov dx,184fh 
    mov cx,0000H
    Int 10H
    mov ah,02h
    mov bh,00
    mov dh,00
    mov dl,00
    int 10h
    call inicio   
                
 
Banderas: 
    mov ah,09
    lea dx, mensaje11
    int 21h
    
    mov ah,09
    lea dx, mensaje12
    int 21h
    
    mov ah,09
    lea dx, mensaje13
    int 21h
    
    mov ah,09
    lea dx, mensaje14
    int 21h
    
    
    mov ah,08              ;pausa y espera a que el usuario presione una tecla
    int 21h                ;interrupcion para capturar
    cmp al,49
    je VZLA
    cmp al,50       
    je PARA        
    cmp al,51
    je ITA        
    cmp al,1bh    
    jmp limpiar
    

MoverImagen: 

    mov ax,0600H
    mov bh,07h
    mov dx,184fh 
    mov cx,0000H
    Int 10H
    mov ah,02h
    mov bh,00
    mov dh,00
    mov dl,00
    int 10h    
    
tamano_s equ 7 
serpiente dw tamano_s dup(0) 

cola dw ? 

; Constantes de direcciones 
 
izquierda equ 4bh 
derecha equ 4dh 
arriba equ 48h 
abajo equ 50h 

; Direccion actual de la serpiente 
dir_actual db derecha 

tiempo_espera dw 0  
jmp empezar



VZLA PROC NEAR 
       MOV AX,@DATA 
       MOV DS,AX
        
	  ;Coloca la franja amarilla
	   MOV AH,06H
	   MOV AL,00H
	   MOV BH,100D  ;Amarillo
	   MOV CX,0000H ;Inicio
	   MOV DX,114fH ;Final
	   INT 10H
	   
	   ;Coloca la franja azul
	   MOV AH,06H  
	   MOV AL,00H
	   MOV BH,11H ;Azul
	   MOV CX,0800H ;Inicio
	   MOV DX,114fH ;Final
	   INT 10H
	  
	   ;Coloca la franja roja
	   MOV AH,06H 
	   MOV AL,00H
	   MOV BH,40H ;Rojo
	   MOV CX,1100H ;Inicio
	   MOV DX,244fH ;Final
	   INT 10H  
	   ;---------------------------------
	   ;Estrellas
	   
	    MOV AH,06H 
	   MOV AL,00H
	   MOV BH,240D ;Blanco
	   MOV CX,0f14H ;Inicio
	   MOV DX,0f14H ;Final
	   INT 10H
	   
	   MOV AH,06H  
	   MOV AL,00H
	   MOV BH,240D ;Blanco
	   MOV CX,0d1aH ;Inicio
	   MOV DX,0d1aH ;Final
	   INT 10H
	   
	   
	   MOV AH,06H  
	   MOV AL,00H
	   MOV BH,240D ;Blanco
	   MOV CX,0b20H ;Inicio
	   MOV DX,0b20H ;Final
	   INT 10H
	   
	    MOV AH,06H 
	   MOV AL,00H
	   MOV BH,240D ;Blanco
	   MOV CX,0a26H ;Inicio
	   MOV DX,0a26H ;Final
	   INT 10H
	   
	   MOV AH,06H  
	   MOV AL,00H
	   MOV BH,240D ;Blanco
	   MOV CX,0a2aH ;Inicio
	   MOV DX,0a2aH ;Final
	   INT 10H 
	   
	   MOV AH,06H  
	   MOV AL,00H
	   MOV BH,240D ;Blanco
	   MOV CX,0b30H ;Inicio
	   MOV DX,0b30H ;Final
	   INT 10H
	   
	   MOV AH,06H  
	   MOV AL,00H
	   MOV BH,240D ;Blanco
	   MOV CX,0d36H ;Inicio
	   MOV DX,0d36H ;Final
	   INT 10H
	   
	   MOV AH,06H  
	   MOV AL,00H
	   MOV BH,240D ;Blanco
	   MOV CX,0f3aH ;Inicio
	   MOV DX,0f3aH ;Final
	   INT 10H
	   
	     
	   ;PAUSA
	   MOV AH, 07H
	   INT 21H
       cmp al,1bh   
       jmp limpiar 
VZLA   ENDP

PARA PROC NEAR 
    
    ;Proceso que dibuja la bandera de forma vertical
    MOV AX,@DATA
    MOV DS,AX
 
    ;Franja Roja 
    mov bh,40h   ;Color Rojo
	mov cx,0000h ;Punto de Inicio   
    mov dx,074fh ;Punto de Final
    int 10h     
    
    ;Franja Blanca
    mov bh,0ffh  ;Color Blanco
    mov cx,0700h ;Punto de Inicio
	mov dx,114fh ;Punto del Final
	int 10h
	
	;Franja Azul
	mov bh,10h   ;Color Azul
	mov cx,1100h ;Punto de Inicio
	mov dx,244fh ;Punto del Final
	int 10h
    
    ;PAUSA
    MOV AH, 07H
	INT 21H
    cmp al,1bh   
    jmp limpiar  
    
PARA ENDP 

ITA PROC NEAR 
    
    ;Proceso que dibuja la bandera de forma vertical
    MOV AX,@DATA
    MOV DS,AX
    
    ;Franja Roja
    MOV AH,06H 
	MOV AL,00H   
	MOV BH,40H   ;Rojo                  
	MOV CX,0000H ;Inicio
    MOV DX,4f18H ;Final
    INT 10H     
    
    ;Franja Blanca
    MOV AH,06H  
	MOV AL,00H
	MOV BH,240D  ;Blanco
	MOV CX,0019H ;Inicio
	MOV DX,4f37H ;Final
	INT 10H          
	
	;Franja Verde
	MOV AH,06H  
	MOV AL,00H
	MOV BH,2FH   ;Verde
	MOV CX,0038H ;Inicio
	MOV DX,4f4fH ;Final
	INT 10H
    
    ;PAUSA
    MOV AH, 07H
	INT 21H
    cmp al,1bh   
    jmp limpiar  
    
ITA ENDP


 
Operaciones:  
    
mov ah,09
lea dx, mensaje5
int 21h
 
call SCAN_NUM ;Llamado a funcion SCAN_NUM para leer numero proveniente del teclado
mov num1,cx ;mueve numero a variable num1 
 
mov ah,09 ;interrupcion para imprimir en pantalla
lea dx,mensaje6 ;carga mensaje6 en dx 
int 21h 
 
call SCAN_NUM ;Llamado a funcion SCAN_NUM para leer numero proveniente del teclado 
mov num2,cx ;mueve numero a variable num2 
 
mov ah,09 
lea dx,mensaje7
int 21h 
 
mov ax,num1 ;mueve primer numero digitado a ax
add ax,num2 ;suma los numeros digitado, queda almacenaddo en ax 
call PRINT_NUM 
 
mov ah,09 
lea dx,mensaje8
int 21h 
mov ax,num1 ;mueve primer numero digitado a ax
sub ax,num2 ;resta el 2do del 1er numero, queda almacenaddo en ax 
call PRINT_NUM 
 
 
 
mov ah,09 
lea dx,mensaje9
int 21h 
mov ax,num1 ;mueve primer numero digitado a ax 
mov bx,num2 ;mueve segundo numero digitado a bx
mul bx ;ax = ax*bx
call PRINT_NUM 
 
mov ah,09 
lea dx,mensaje10
int 21h 
xor dx,dx ;deja en cero dx; si no lo hago se desborda la division
;DX ALMACENA EL modulo de la division, por eso hay q dejarlo en cero
mov ax,num1 ;mueve primer numero digitado a ax 
mov bx,num2 ;mueve segundo numero digitado a bx
div bx ;ax = ax*bx
call PRINT_NUM

mov ah,09
lea dx,espacio
int 21h 
mov ah,09
lea dx,mensaje1
int 21h  

mov ah,08
int 21h 
jmp limpiar   


empezar: 

; Esperar a que se pulse una tecla 
mov ah,09
lea dx,mensaje2
int 21h
mov ah, 00h
int 16h
    mov ax,0600H
    mov bh,07h
    mov dx,184fh 
    mov cx,0000H
    Int 10H
    mov ah,02h
    mov bh,00
    mov dh,00
    mov dl,00
    int 10h 

; Esconder el cursor de texto 
mov ah, 1 
mov ch, 2bh 
mov cl, 0bh 
int 10h 

mov ah,09
lea dx,mensaje4
int 21h

ciclo_de_juego: 
; Seleccionar pagina del juego 
mov al, 0 ; Numero de pagina 
mov ah, 05h 
int 10h 

; Mostrar nueva cabeza: 
mov dx, serpiente[0] 

; Poner cursor en dl,dh 
mov ah, 02h 
int 10h 

; Imprimir '#' 
mov al, 5h,'#' 
mov ah, 09h 
mov bl, 0eh  
mov cx, 1  
int 10h 

; Mantener cola: 
mov ax, serpiente[tamano_s * 2 - 2] 
mov cola, ax 

call mover_serpiente 

;  Esconder antigua cola: 
mov dx, cola 

; Poner cursor en dl,dh 
mov ah, 02h 
int 10h 

; Imprimir ' ' 
mov al, ' ' 
mov ah, 09h 
mov bl, 0eh ; attribute. 
mov cx, 1 ; single char. 
int 10h 


verificar_tecla: 

; Verificar si el usuario ha presionado alguna tecla 
mov ah, 01h 
int 16h 
jz ninguna_tecla_presionada 

mov ah, 00h 
int 16h 

cmp al, 1bh ; Verifica si la tecla presionada no es la de escape 
je limpiar ; 

mov dir_actual, ah 

ninguna_tecla_presionada: 


 
mov ah, 00h 
int 1ah 
cmp dx, tiempo_espera 
jb verificar_tecla 
add dx, 4 
mov tiempo_espera, dx 


; Llama de nuevo a la funcion ciclo_de_juego 
jmp ciclo_de_juego 

detener_juego: 

; Volver a mostrar el cursor 
mov ah, 1 
mov ch, 0bh 
mov cl, 0bh 
int 10h 

ret 

mover_serpiente proc near 

; Asignar informacion del segmento a es 
mov ax, 40h 
mov es, ax 

; Apuntar di a cola 
mov di, tamano_s * 2 - 2 
;Mover cuerpo 
mov cx, tamano_s-1 
move_array: 
mov ax, serpiente[di-2] 
mov serpiente[di], ax 
sub di, 2 
loop move_array 

cmp dir_actual, izquierda 
je mover_izquierda 
cmp dir_actual, derecha 
je mover_derecha 
cmp dir_actual, arriba 
je mover_arriba 
cmp dir_actual, abajo 
je mover_abajo 

jmp detener_movimiento  

mover_izquierda: 
mov al, b.serpiente[0] 
dec al 
mov b.serpiente[0], al 
cmp al, -1 
jne detener_movimiento 
mov al, es:[4ah]  
dec al 
mov b.serpiente[0], al  
jmp detener_movimiento 

mover_derecha: 
mov al, b.serpiente[0] 
inc al 
mov b.serpiente[0], al 
cmp al, es:[4ah]  
jb detener_movimiento 
mov b.serpiente[0], 0  
jmp detener_movimiento 

mover_arriba: 
mov al, b.serpiente[1] 
dec al 
mov b.serpiente[1], al 
cmp al, -1 
jne detener_movimiento 
mov al, es:[84h]  
mov b.serpiente[1], al  
jmp detener_movimiento 

mover_abajo: 
mov al, b.serpiente[1] 
inc al 
mov b.serpiente[1], al 
cmp al, es:[84h]  
jbe detener_movimiento 
mov b.serpiente[1], 0  
jmp detener_movimiento 

detener_movimiento: 
ret
mover_serpiente endp  

Alfabeto:

mov ax, @DATA                           
    mov ds, ax

    ; Input String
    mov ah, 09h
    mov dx, OFFSET Cadena
    int 21h
    mov dx, OFFSET Struct0A
    mov ah, 0Ah
    INT 21h

    mov si, OFFSET buf                      ; Base para [si + bx] 
    xor bx, bx                              ; Prepara bx para la proxima carga de bytes
    mov bl, got                             ; Carga el tamaño de la cadena a bl
    mov BYTE PTR [si + bx], '$'             ; Delimitador para interrupcion 21h / 09h

    outer:
    dec bx                                  ; El ultimo caracter ya esta a la derecha
    jz done                                 ; Si no hay caracteres a la izquierda se termina
    mov cx, bx                              ; Cx es la variable del ciclo
    mov si, OFFSET buf
    xor dl, dl                              ; Se coloca dl como falso

    inner:
    mov ax, [si]                            ; Carga 2 caracteres
    cmp al, ah                              ; AL: 1. char, AH: 2. char
    jbe S1                                  ; AL <= AH - sin cambios
    mov dl, 1                               ; HaIntercambiado = verdadero
    xchg al, ah                             ; Intercambiar caracteres
    mov [si], ax                            ; Almacenar caracter
    S1:
    inc si                                  ; Siguiente par de caracteres
    loop inner

    test dl, dl                             ; Se verifica si HaIntercambiado = verdadero
    jnz outer                               ; Si: se repite el ciclo
    done:

    ; Imprimir resultado
    mov dx, OFFSET Linefeed
    mov ah, 09h
    int 21h
    mov dx, OFFSET buf
    mov ah, 09h
    int 21h
    
    mov ah,9h
    lea dx,espacio
    int 21h
    mov ah,9h
    lea dx,mensaje1
    int 21h
    mov ah,08 
    int 21h
    je limpiar

end inicio  
