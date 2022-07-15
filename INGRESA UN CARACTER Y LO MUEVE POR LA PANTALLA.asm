.model small
         ;DESCRIPCION:
         ;El programa permite ingresar un carácter 
         ;desde el teclado que se moverá por 
         ;la pantalla según el usuario pulse las 
         ;flechas de dirección en el teclado y lograra salir 
         ;del programa pulsando la tecla esc. 
         ;Para que este programa tenga un correcto funcionamiento se hace 
         ;uso de las interrupciones sobre todo relacionadas con el modo de vídeo, 
         ;el teclado y el sistema .
     
.data 
     mensaje db 10, 13, "INGRESE CARACTER $"
     car     DB 0 ;variable para almacenar el caracter que se va a mover
     posx    DB 0 ;variable que almacena la posicion de columna del cursor
     posy    DB 0 ;variable que almacena la fila donde se encuentra el cursor
     xa      DB 0 ;variable auxiliar de columna
     ya      DB 0 ;variable auxiliar de fila 
.code 
    mov ax,data
    mov ds,ax
    
    
   ;Llamada a la funcion 02h de la interrupcion 10h
   ;Funcion que nos permite posicionar el cursor 
   mov  ah,02h      ;colocamos el valor de la funcion a llamar en  el registro ah
   mov  bh,00h      ;colocamos el valor de la pagina de video en donde deseamos colocar el cursor
   mov  dh,5        ;Almacenamos en dh la fila  en donde se colocara el cursor
   mov  dl,5        ;Almacenamos en dl la columna en donde se colocara el cursor
   int  10h         ;Ejecuamos la interrupcion
   
   ;Llamada a la funcion 09h de la interrupcion 21,que nos permite impirmir una cadena de caracteres
   mov  ah,09h      ;Colocamos en ah el valor de la funcion a llamar
   lea  dx,mensaje  ;Seleccionamos el mensaje "msg" cargandolo al registro de datos
   int  21h         ;Ejecutamos la interupcion 21
   
   ;Llamada a la funcion 01h de la interrupcion 21
   ;Funcion que lee un caracter del dispositivo de entrada y lo envia al dispositivo de salida
   mov  ah,01h      ;Colocamos en ah el valor de la funcion a llamar
   int  21h         ;Ejecutamos la interrupcion
   
   mov  car,al      ;Almacenamos en "car" el codigo ASCII convertido a hexadecimal del caracter leido
   
   ;Llamada a la funcion 03h de la interrupcion 10h
   ;Funcion que lee la posicion del cursor y su taman~o
   mov  ah,03h      ;Colocamos en ah el valor de la funcion a llamar
   mov  bh,00h      ;Colocamos el valor de la pagina de video de la que queremos los valores del cursor
   int  10h         ;Ejecutamos la interrupcion 
   
   mov  posx,ch     ;Almacenamos el valor de donde esta la linea inicial del cursor en "posx"
   mov  posy,dh     ;Almacenamos la fila donde esta el cursor en "posy"
   dec  posx        ;Disminuimos en 1 el valor de "posx" y lo almacenamos en "posx"
   
   ;Llamada a la funcion 05h de la interrupcion 10h
   ;Funcion que establece una nueva pagina de video
   mov  ah,05h      ;Colocamos en ah el valor de la funcion a llamar
   mov  al,01h      ;Colocamos en al el valor de la pagina de inicio que queremos establecer
   int  10h         ;Ejecutamos la interrupcion 
   
bucle: 

   ;Llamada a la funcion 02h de la interrupcion 10h
   ;Funcion que nos permite  posicionar el cursor
   mov  ah,02h      ;Colocamos en ah el valor de la funcion a llamar
   mov  bh,01h      ;Colocamos la pagina de video en donde posicionara el cursor
   mov  dh,ya       ;Almacenamos en dh el valor de la fila donde estara el cursor, dado por "ya"
   mov  dl,xa       ;Almacenamos en dl el valor de la columna donde estara el cursor, dado ppr "xa"
   int  10h         ;Ejecutamos la interrupcion
   
   mov  ah,02h      ;Servicio para imprimir el caracter 
   mov  dl,32       ;almacenado en dl
   int  21h         ;Imprime un espacio en la pos xa,ya 

   mov  ah,02h      ;Servicio que asigna una posicion al cursor
   mov  bh,01h      ;en la pos x,y
   mov  dh,posy     
   mov  dl,posx     
   int  10h         ;Asigna la posicion
   
   mov  ah,02h      ;Imprimir el caracter almacenado en la pos (x,y)
   mov  dl,car
   int  21h
   
   mov  ah,02h      ;Servicio que asigna una posicion al cursor
   mov  bh,01h      ;en la pos x,y
   mov  dh,posy
   mov  dl,posx
   int  10h  
   
   mov  xa,dl       ;Actualiza los valores de 
   mov  ya,dh       ;xa y ya
   
   mov  ah,00h      ;Servicio 00h para
   int  16h         ;leer pulsacion de tecla
   cmp  ah,75       ;Compara ah y 75(pulsacion de la tecla de flecha apuntando a la izquierda)
   jne  noizquierda ;Si la flecha no apunta a la izquierda salta a noizquierda
   dec  posx        ;Si la flecha apunta a la izquierda decrementa posx 
   jmp  bucle       ;Regresa al bucle
   
noizquierda:
   cmp  ah,72       ;Compara ah y 72(pulsacion de la tecla de flecha apuntando hacia arriba)
   jne  noarriba    ;Si la flecha no apunta hacia arriba salta a noarriba
   dec  posy        ;Si la flecha apunta arriba decrementa posy
   jmp  bucle       ;Regresa al bucle
noarriba:
   cmp  ah,77       ;Compara ah y 72(pulsacion de la tecla de flecha apuntando a la derecha)
   jne  noderecha   ;Si la flecha no apunta a la derecha salta a noderecha
   inc  posx        ;Si la flecha apunta a la derecha incrementa posx
   jmp  bucle       ;Regresa al bucle
noderecha:
   cmp  ah,80       ;Compara ah y 72(pulsacion de la tecla de flecha apuntando hacia abajo)
   jne  noabajo     ;Si la flecha no apunta hacia abajo salta a noabajo
   inc  posy        ;Si la flecha apunta abajo incrementa posy   
   jmp  bucle
noabajo:
   cmp  al,27       ;Compara ah y 27(pulsacion de la tecla esc )
   je   fin         ;Si la tecla presionada es esc salta a fin
   jmp  bucle       ;Regresa al bucle
fin:
   mov  ax,4c00h      ;Finaliza el programa
   int  21h


end