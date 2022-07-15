;Autor
;Espinoza Champi Israel Enrique

;********************CAMBIO COLOR DE PANTALLA**********************
;Descripción:   El siguiente programa permite ingresar una palabra, luego
;               el programa te preguntará si deseas repetir la palabra. 
;               Si se presiona la tecla "s", muestra en pantalla la palabra
;               ;y si se presiona "n",el programa termina, pero si por error
;               presionamos otra letra, el programa te preguntará de nuevo
;               si deseas repetir la palabra. 

.model small
.stack 64 

.data   
inicio   db '-----REPETIR PALABRA-----',10,13,'$'
ingresar db 10,13,'Ingrese una palabra', 10,13,'$'
nombre   db 'La palabra es: $'
repetir  db 10,13,'Quiere repetir s/n?',10,13,'$' 
intento  db 10,13,'Ingrese de nuevo s/n: ',10, 13,'$'
vtext    db 100 dup('$')     ;Declaracion del vector vacio

.code   

;*********************************************************************
 mov ah,06h         ; peticion de recorrido de la pantalla
 mov al,00h         ; indica la pantalla completa
 mov bh,70h         ; attributos de color y fondo 7 gris claro 0 negro    
 mov cx,0000h       ; esquina superior izquierda renglon columna
 mov dx,184fh       ; esquina inferior derecha renglon columna
 int 10h    
;*********************************************************************

    mov ax,@data     ;Mover a AX lo que está contenido en .data
    MOV DS,AX        ;Mover lo de .data a DS 
    lea dx,inicio    ;Para imprimir lo que está almacenado en "inicio"
    mov ah,09        ;09h a AH para mostrar texto
    int 21h          ;Ejecutar int 21h

    lea dx,ingresar  ;Para imprimir lo que está almacenado en "ingresar"
    mov ah,09        ;09h a AH para mostrar texto
    int 21h          ;Ejecutar int 21h

    mov si,00h       ;Reiniciar contador SI en 00h  
    
leer:
    mov ax,0000      ;Reiniciar AX en 0000
    mov ah,01h       ;01h a AH para ingreso de caracter
    int 21h          ;Ejecucion int 21h
    
    mov vtext[si],al ;Guardamos el valor tecleado por el usuario en la posicion si del vector.
    inc si           ;Incrementamos nuestro contador
    cmp al,0dh       ;Compara Al con "0dh" donde 0dh=tecla enter
    ja leer          ;si no se presiono la tecla enter se ejecuta la etiqueta Leer                 
    jb leer          ;si se presiono la tecla enter se pasa a la siguiente instruccion
    
    lea dx,nombre    ;para imprimir lo que esta almacenado en "nombre"
    mov ah,09        ;09h a AH para mostrar texto
    int 21h          ;Ejecutar int 21h
     
mostrar:
    mov dx,offset vtext  ;Imprime el contenido del vector con la misma instruccion de una cadena
    mov ah,09h           ;09h a AH para mostrar texto
    int 21h              ;Ejecutar int 21h
        
    lea dx,repetir       ;Imprime si quiere ver de nuevo el texto escrito.
    mov ah,09            ;09h a AH para mostrar texto
    int 21h              ;Ejecutar int 21h
    
    mov ah,0h            ;Habilita el teclado para ingresar un caracter
    int 16h              ;Interrupcion para controlar el teclado
        
    
    cmp al,"s"           ;Comparar AL con "s"
    je mostrar           ;Si es igual, ejecuta la etiqueta "mostrar" 
    cmp al,"n"           ;Compara el valor del registro Al con "n"
    je salir             ;se ejecuta la etiqueta "salir"
    jne reintentar       ;Si lo que está en AL no es igual a "n", saltar a reintentar
    
salir:
    mov ah,4ch      ;Se finaliza la ejecucion del programa en curso
    int 21h         ;Se ejecuta la instruccion 21h 

reintentar:  
    lea dx, intento ;Almacenando en DX lo que está contenido en intento
    mov ah, 09h     ;09h a AH para mostrar texto
    int 21h         ;Ejecución int 21h    
    
    mov ah,0        ;Habilita el teclado para ingresar un caracter
    int 16h         ;Interrupción para controlar el teclado
                      
    cmp al,"s"           ;Comparar AL con "s"
    je mostrar           ;Si es igual, ejecuta la etiqueta "mostrar" 
    cmp al,"n"           ;Compara el valor del registro Al con "n"
    je salir             ;se ejecuta la etiqueta "salir"
    jne reintentar       ;Si lo que está en AL no es igual a "n", saltar a reintentar
               
end
              
 