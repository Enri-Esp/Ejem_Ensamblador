;Autor
;Espinoza Champi Israel Enrique

;**********************************************************************
;Descripción:
;El siguiente programa permite el ingreso de dos palabras, para luego realizar el proceso
;de repetir cada una de las palabras cuando se ingresa el número de veces donde cada palabra
;se repetira esa cantidad de veces, luego ingresamos el nro de veces que todo ese
;bloque de palabras se va repetir,luego de que finalice este proceso, el programa preguntara
;si se desea volvera a repetir e ingresar otras palabras, si  la respuesta es no
;el programa termina 
;********************************************************************** 


.model small
.stack 64
.data 
    titulo   db '-----REPETIR PALABRA-----',10,13,'$'
    msj1 db 10,13,'Ingresar Palabra1 :$' 
    msj2 db 10,13,'Ingresar Palabra2 :$' 
    
    msj3 db 10,13,'Repetición ','$' 
    msj4 db 10,13,'Quiere repetir s/n?',10,13,'$'
    
    msj_rep1 db 10,13, 'Nro de repetir palabras    :','$'  
    msj_rep2 db 10,13, 'Nro de repetir por bloque  :','$'  
    endl     db 10,13,'','$'     

    rep1   db ?
    rep2   db ?       
    cont   db 0
    ;*********************************************
    palabra1    db 100 dup('$')
    palabra2    db 100 dup('$') 
    ;*********************************************   
.code    
    ;____________________CAMBIO DE COLOR DE PANTALLA________________________      
    mov ah,06h         ; peticion de recorrido de la pantalla
    mov al,00h         ; indica la pantalla completa
    mov bh,30h         ; attributos de color y fondo 7 gris claro 0 negro    
    mov cx,0000h       ; esquina superior izquierda renglon columna
    mov dx,184fh       ; esquina inferior derecha renglon columna
    int 10h    
    ;_______________________________________________________________________
    
    volver: 
        mov ax, @data
        mov ds, ax  
        
        lea dx,titulo    ;Para imprimir lo que está almacenado en "inicio"
        mov ah,09        ;09h a AH para mostrar texto
        int 21h          ;Ejecutar int 21h  
        mov palabra1,'$'   ;iniciamos el vector con la cadena vacia
        mov palabra2,'$'   ;iniciamos el vector con la cadena vacia
        mov cont, 0      ;inicializamos el contador
        
        lea dx,palabra2    ;Para imprimir lo que está almacenado en "inicio"
        mov ah,09        ;09h a AH para mostrar texto
        int 21h  
                  
        ;_____________________________INGRESO DE PALABRAS_______________________________
        ;LEER PALABRA 1
        lea dx,msj1      ;Para mostrar el mensaje "Ingresar palabra1: "
        mov ah,09        ;09h a AH para mostrar texto
        int 21h          ;Ejecutar int 21h 
        mov si,00h       ;Reiniciar SI en 00h
        
        leer1:
            mov ax,0000      ;Reiniciar AX en 0000
            mov ah,01h       ;01h a AH para ingreso de caracter
            int 21h          ;Ejecucion int 21h
    
            mov palabra1[si],al ;Guardamos el valor tecleado por el usuario en la posicion si del vector.
            inc si            ;Incrementamos nuestro contador
            cmp al,0dh        ;Compara Al con "0dh" donde 0dh=tecla enter
            ja leer1          ;si no se presiono la tecla enter se ejecuta la etiqueta Leer                 
            jb leer1          ;si se presiono la tecla enter se pasa a la siguiente instruccion
        
        ;LEER PALABRA 2
        lea dx,msj2           ;Para mostrar el mensaje "Ingresar palabra2: "
        mov ah,09             ;09h a AH para mostrar texto
        int 21h               ;Ejecutar int 21h 
        mov si,00h            ;Reiniciando SI
    
        leer2:
            mov ax,0000       ;Reiniciar AX en 0000
            mov ah,01h        ;01h a AH para ingreso de caracter
            int 21h           ;Ejecucion int 21h
    
            mov palabra2[si],al ;Guardamos el valor tecleado por el usuario en la posicion si del vector.
            inc si            ;Incrementamos nuestro contador
            cmp al,0dh        ;Compara Al con "0dh" donde 0dh=tecla enter
            ja leer2          ;si no se presiono la tecla enter se ejecuta la etiqueta Leer                 
            jb leer2          ;si se presiono la tecla enter se pasa a la siguiente instruccion
    
        ;________________________________INGRESO DE CANTIDAD A REPETIR_______________________________   
        
        ;LEER 1ER NRO A REPETIR
        lea dx, msj_rep1   ;Mostrar mensaje rep1
        mov ah, 09h        ;Para mostrar mensaje en pantalla
        int 21h            ;Ejecución interrupción 21h
    
        mov ah,01h         ;Para ingreso de caracter (valor ingresado se almacena en AL en hexadecimal)
        int 21h            ;Ejecución interrupción 21h
    
        sub al, 30h        ;Restando 30h a AL para obtener nro ingresado (porque está en hexadecimal)
        mov rep1, al       ;Guardando en rep1 el nro ingresado
        
        ;LEER 2DO NRO A REPETIR
        lea dx, msj_rep2   ;Mostrar mensaje rep2
        mov ah, 09h        ;Para mostrar mensaje en pantalla
        int 21h            ;Ejecución interrupción 21h            
    
        mov ah,01h         ;Para ingreso de caracter (valor ingresado se almacena en AL en hexadecimal)
        int 21h            ;Ejecución interrupción 21h
    
        sub al,30h         ;Restando 30h a AL para obtener nro ingresado (porque está en hexadecimal)
        mov rep2, al       ;Guardando en rep2 el nro ingresado
        
        ;_____________________________IMPRESIÓN DE LAS PALABRAS INGRESADAS_____________________________
        
        lea dx, endl       ;Para hacer un salto de linea
        mov ah, 09h        ;Mostrar en pantalla
        int 21h            ;Ejecución de la interrupción 21h
        
        MostrarMensajes:
    
            lea dx, msj3   ;Para mostrar mensaje "Repetición "
            mov ah, 09h    ;Mostrar mensaje en pantalla
            int 21h        ;Ejecución de la interrupción 21h
        
            inc cont       ;Incrementar cont en 1
            mov ah, 02h    ;Para impresión de caracter del registro DL (debe estar el caracter en hexadecimal)
            mov dx, 00     ;Reiniciando DX en 00h
            mov dl, cont   ;Copiando a DL el valor de cont
            add dx, 30h    ;Agregando 30h a DX para convertirlo en hexadecimal
            int 21h        ;Ejecución de la interrupción 21h
    
            lea dx, endl   ;Para hacer un salto de linea
            mov ah, 09     ;Mostrar en pantalla
            int 21h        ;Ejecución de la interrupción 21h
         
        ;INICIO DE LA IMPRESIÓN DE LA 1ERA PALABRA INGRESADA 
        mov cx, 00h    ;Reiniciar CX en 00h
        mov cl,rep1    ;Almacenar en CL lo que está guardado en rep1(para usarlo en loop)
           
        ciclo1:    
            mov dx,offset palabra1  ;Para mostrar el valor almacenado en palabra1
            mov ah,09             ;Mostrar en pantalla             
            int 21h               ;Ejecución de la interrupción 21h
        
            lea dx, endl          ;Para mostrar salto de linea
            mov ah, 09            ;Mostrar en pantalla
            int 21h               ;Ejecución interrupción 21h
        loop ciclo1               ;Decrementar CX en 1 y volver a Ciclo1
        
        ;INICIO DE LA IMPRESIÓN DE LA 2da PALABRA INGRESADA  
        mov cx, 00h               ;Reiniciar CX en 00h
        mov cl, rep1              ;Almacenar en CL lo que está guardado en rep1
    
        ciclo2:    
            mov dx,offset palabra2  ;Para mostrar el valor almacenado en palabra2
            mov ah,09             ;Mostrar en pantalla
            int 21h               ;Ejecución de la interrupción 21h
        
            lea dx, endl          ;Para mostrar salto de linea
            mov ah, 09            ;Mostrar en pantalla
            int 21h               ;Ejecución interrupción 21h           
        loop ciclo2               ;Decrementar CX en 1 y volver a Ciclo1
        
        ;PARA REPETIR LA IMPRESIÓN DE MENSAJES DE NUEVO                               
        sub rep2,1                ;Restar en 1 al valor almacenado en rep2
        cmp rep2,0                ;Comparar rep2 con cero
        jne MostrarMensajes       ;Si rep2 no es igual a 0, saltar a MostrarMensajes
    
        ;_____________MENSAJE SI DESEA REPETIR EL PROGRAMA DE NUEVO______________
        
        lea dx,msj4       ;Imprime si quiere ver de nuevo el texto escrito.
        mov ah,09         ;09h a AH para mostrar texto
        int 21h           ;Ejecutar int 21h
    
        mov ah,0h         ;Habilita el teclado para ingresar un caracter
        int 16h           ;Interrupcion para controlar el teclado
           
        cmp al,"s"        ;Comparar AL con "s"
        je  volver        ;Si es igual, ejecuta la etiqueta "mostrar" 
        cmp al,"n"        ;Compara el valor del registro Al con "n"    
    .exit
end  