;Autor:
;       -Espinoza Champi Israel Enrique
;----------------------------------------------------------------------
;DESCRIPCIÓN DEL PROBLEMA:
;En este ejemplo usaremos bifurcaciones para poder contar la cantidad
;de caracteres en una cadena pedida al usuario; haremos uso de condicionales
;y bucles
;---------------------------------------------------------------------
cambiarColor macro color,ESup,EInf ;Macro para cambiar el color por areás en pantalla
    mov ah,06h         ;Petición de recorrido de la pantalla
    mov al,00h         ;Indica la pantalla completa
    mov bh,color       ;Atributos de color y fondo     
    mov cx,ESup        ;Esquina superior izquierda renglón columna
    mov dx,EInf        ;Esquina inferior derecha renglón columna
    int 10h            ;Llamada a la interrupción de video BIOS   
endm

imprimirCadena macro cadena,x,y ;Macro para imprimir una cadena en una posición (x,y)
    mov ah,02     ;Función 02h de int 10h posicionar el cursor
    mov dl,x      
    mov dh,y      ;Establecemos la posición(dl,dh)
    mov bh,00     ;Pagina de video principal
    int 10h       ;Interrupción para ejecutar la función 02h

    mov ah,09       ;Funcion 09 de int 21h para la visualización de cadenas
    mov dx,offset cadena ;Desplegar mensaje msj1
    int 21h
endm

contar macro CN,CLe     ;Macro para contar total de números y letras, y almacenar
    mov si,0            ;Reiniciamos si
    cmp al,40h          ;Comparamos al con 40h para saber si tenemos número o letra
    jb numero           ;Si al<40h (al es un número) salta a número
    jmp letra           ;Sino salta a letra 
    
    numero:             ;Guarda el número en la pos bx=contador de números
        mov si,bx
        mov CN[si],al
        inc bx
        jmp fin
    
    letra:              ;Guarda la letra en la pos dh=contador de números
        mov bh,bl       ;Intercambiamos bl por dh
        mov bl,dh
        mov dh,bh
        mov bh,00
        mov si, bx
        mov CLe[si],al
        inc bx
        mov bh,bl       ;Intercambiamos dh por bl
        mov bl,dh
        mov dh,bh
        mov bh,00
     
     fin:
        mov si,0         ;Reiniciamos si
endm  

.stack 64h
.data
  msj1 db 'El numero de caracteres es:$'
  msj2 db 'Ingrese una cadena: $'
  msj3 db 'Total numeros: $'
  msj4 db 'Total letras: $'
  msj5 db 'Cadena numeros: $'
  msj6 db 'Cadena letras: $'
  cLetras db 50 dup(?)
  cNumeros db 50 dup(?)
  tLetras db ?
  tNumeros db ?
  
.code
.startup
cambiarColor 02h,0000h,0415h
mov ah,02           ;Función 02h de int 10h posicionar el cursor
mov dx,0402h        ;Posiciona el cursor (dl,dh)
mov bh,00           ;Página de video principal
int 10h

mov ah,09           ;Función 09 de int 21h para la visualización de cadenas
mov dx,offset msj2  ;Desplegar mensaje msj2
int 21h

;Establecemos las áreas de colores
cambiarColor 03h,0015h,044fh
cambiarColor 05h,0500h,074fh
cambiarColor 00001010b,0800h,1824h
cambiarColor 00001110b,0825h,184fh

mov bx,0000h   ;Reinicia el registro bx
mov cx,50      ;Inicio el registro del contador en 50
mov dh,00h     ;Reinicia dh
 
LeerCont:      ;Función regresa que realiza la lectura de carácteres
    mov ah,07h ;Recoje por teclado un cárater y lo coloca en AL sin eco
    int 21h    ;Ejecuta la función del DOS    
    cmp al,13  ;Compara al con enter
    je asignar ;Salta solo si la tecla oprimida es enter
    inc ch     ;Contador de carácteres
    mov dl,al  ;Asigna el contenido de al en dl
    mov ah,02h ;Función de mostrar por pantalla el contenido de dl
    int 21h    ;Ejecuta la funcion del DOS
    contar cNumeros,cLetras  ;Llama al macro contar que almacena los numeros y letras en sus cadenas
    loop LeerCont ;En contenido de CX disminuye en 1 y salta a regresa

asignar:
     mov tNumeros,bl   ;Guardamos el total de números
     mov tLetras,dh    ;Guardamos el total de números
     mov bx,0          ;Reiniciamos registros
     mov dh,0

IniciarImp:            ;Función asignar que separa unidad de decena
    mov bl,ch
    mov al,ch       ;Asigna el contenido de bx en ax
    and ax,000fh    ;Deja las unidades en ax
    and bx,00f0h    ;Deja las centenas en bx
    shr bx,04       ;Recorre 4 bits a la derecha de bx
    cmp bl,0        ;Compara para sabes si el número de caracteres es mayor 15
    ja convertir    ;Si bl(decenas) > 0 salta a convertir
    daa             ;Sino corrige la suma BCD de al (al=0Ch -> al=12h)
    jmp mostrar     ;Como el número de caracteres es menor a 16 salta a mostrar

convertir:          ;La función convierte de hexadecimal a decimal
    mov cx,bx       ;Asigna bx al contador cx para el loop (16 x decenas)
    mov bx,0        ;Reinicia el registro bx
    ciclo:          ;while(cx>0)
        add bx,16h  ;Sumanos 16h cuantas decenas tenga el número de caracteres
        daa         ;Corrige la suma BCD
        loop ciclo  ;Continua ciclo
    add ax,bx       ;(16 x decenas + unidades)
    daa             ;Corrige la suma BCD
  
mostrar:    
    mov bx,ax
    and ax,000fh ;Suma 000fh al registro ax
    and bx,00f0h ;Suma 000fh al registro bx
    shr bx,04    ;Recorre 4 bits a la derecha de bx
    mov ah,bl    ;Tendremos en ah las decenas y el al las unidades
    or ax,3030h  ;Realiza una operación lógica OR entre bx y 3030h bit a bit
    mov cx,ax    ;Asigna el contenido de bx a cx
       
    mov ah,02     ;Función 02h de int 10h posicionar el cursor
    mov dx,0702h  ;Posiciona el cursor (dl,dh)
    mov bh,00     ;Pagina de video principal
    int 10h       ;Interrupción para ejecutar la función 02h

    mov ah,09       ;Funcion 09 de int 21h para la visualización de cadenas
    mov dx,offset msj1 ;Desplegar mensaje msj1
    int 21h
 
    mov ah,02     ;Función 02h de int 10h posicionar el cursor
    mov dx,071eh  ;Posiciona el cursor (dl,dh)
    mov bh,00     ;Página de video principal
    int 10h       ;Interrupción para ejecutar la función 02h
 
    mov dl,ch     ;Asigna el contenido de ch a dl
    mov dh,cl     ;Asigna el contenido de cl a dh
 
    mov ah,02     ;Función 02 de int 21h Salida de caracter
    int 21h
    mov ch,dh      ;Asigna el contenido de dh a ch
    mov dl,ch      ;Asigna el contenido de ch a dl
    int 21h

imprimirCadena msj5,02h,09h

mov cx,0
mov ah,02     ;Función 02h de int 10h posicionar el cursor
mov dx,0914h  ;Posiciona el cursor (dl,dh)
mov bh,00     ;Pagina de video principal
int 10h       ;Interrupción para ejecutar la función 02h
mov cl,tNumeros 
mov si,0
impNumeros:
    mov dl,cNumeros[si]  ;Asigna el contenido de al en dl
    mov ah,02h ;Función de mostrar por pantalla el contenido de dl
    int 21h    ;Ejecuta la funcion del DOS
    inc si
    loop impNumeros

imprimirCadena msj6,27h,09h

mov cx,0
mov ah,02     ;Función 02h de int 10h posicionar el cursor
mov dx,093ah  ;Posiciona el cursor (dl,dh)
mov bh,00     ;Pagina de video principal
int 10h       ;Interrupción para ejecutar la función 02h
mov cl,tLetras 
mov si,0
impLetras:
    mov dl,cLetras[si]  ;Asigna el contenido de al en dl
    mov ah,02h ;Función de mostrar por pantalla el contenido de dl
    int 21h    ;Ejecuta la funcion del DOS
    inc si
    loop impLetras

IniciarImp1:            ;Función asignar que separa unidad de decena
    mov ch,tNumeros
    mov bl,ch
    mov al,ch       ;Asigna el contenido de bx en ax
    and ax,000fh    ;Deja las unidades en ax
    and bx,00f0h    ;Deja las centenas en bx
    shr bx,04       ;Recorre 4 bits a la derecha de bx
    cmp bl,0        ;Compara para sabes si el número de caracteres es mayor 15
    ja convertir1    ;Si bl(decenas) > 0 salta a convertir
    daa             ;Sino corrige la suma BCD de al (al=0Ch -> al=12h)
    jmp mostrar1     ;Como el número de caracteres es menor a 16 salta a mostrar

convertir1:          ;La función convierte de hexadecimal a decimal
    mov cx,bx       ;Asigna bx al contador cx para el loop (16 x decenas)
    mov bx,0        ;Reinicia el registro bx
    ciclo1:          ;while(cx>0)
        add bx,16h  ;Sumanos 16h cuantas decenas tenga el número de caracteres
        daa         ;Corrige la suma BCD
        loop ciclo  ;Continua ciclo
    add ax,bx       ;(16 x decenas + unidades)
    daa             ;Corrige la suma BCD
  
mostrar1:    
    mov bx,ax
    and ax,000fh ;Suma 000fh al registro ax
    and bx,00f0h ;Suma 000fh al registro bx
    shr bx,04    ;Recorre 4 bits a la derecha de bx
    mov ah,bl    ;Tendremos en ah las decenas y el al las unidades
    or ax,3030h  ;Realiza una operación lógica OR entre bx y 3030h bit a bit
    mov cx,ax    ;Asigna el contenido de bx a cx
       
    mov ah,02     ;Función 02h de int 10h posicionar el cursor
    mov dx,0b02h  ;Posiciona el cursor (dl,dh)
    mov bh,00     ;Pagina de video principal
    int 10h       ;Interrupción para ejecutar la función 02h

    mov ah,09       ;Funcion 09 de int 21h para la visualización de cadenas
    mov dx,offset msj3 ;Desplegar mensaje msj1
    int 21h
 
    mov ah,02     ;Función 02h de int 10h posicionar el cursor
    mov dx,0b14h  ;Posiciona el cursor (dl,dh)
    mov bh,00     ;Página de video principal
    int 10h       ;Interrupción para ejecutar la función 02h
 
    mov dl,ch     ;Asigna el contenido de ch a dl
    mov dh,cl     ;Asigna el contenido de cl a dh
 
    mov ah,02     ;Función 02 de int 21h Salida de caracter
    mov cx,01     ;Asigna 01 a cx
    int 21h
    mov ch,dh      ;Asigna el contenido de dh a ch
    mov dl,ch      ;Asigna el contenido de ch a dl
    int 21h
    
IniciarImp2:            ;Función asignar que separa unidad de decena
    mov ch,tLetras
    mov bl,ch
    mov al,ch       ;Asigna el contenido de bx en ax
    and ax,000fh    ;Deja las unidades en ax
    and bx,00f0h    ;Deja las centenas en bx
    shr bx,04       ;Recorre 4 bits a la derecha de bx
    cmp bl,0        ;Compara para sabes si el número de caracteres es mayor 15
    ja convertir2    ;Si bl(decenas) > 0 salta a convertir
    daa             ;Sino corrige la suma BCD de al (al=0Ch -> al=12h)
    jmp mostrar2     ;Como el número de caracteres es menor a 16 salta a mostrar

convertir2:          ;La función convierte de hexadecimal a decimal
    mov cx,bx       ;Asigna bx al contador cx para el loop (16 x decenas)
    mov bx,0        ;Reinicia el registro bx
    ciclo2:          ;while(cx>0)
        add bx,16h  ;Sumanos 16h cuantas decenas tenga el número de caracteres
        daa         ;Corrige la suma BCD
        loop ciclo  ;Continua ciclo
    add ax,bx       ;(16 x decenas + unidades)
    daa             ;Corrige la suma BCD
  
mostrar2:    
    mov bx,ax
    and ax,000fh ;Suma 000fh al registro ax
    and bx,00f0h ;Suma 000fh al registro bx
    shr bx,04    ;Recorre 4 bits a la derecha de bx
    mov ah,bl    ;Tendremos en ah las decenas y el al las unidades
    or ax,3030h  ;Realiza una operación lógica OR entre bx y 3030h bit a bit
    mov cx,ax    ;Asigna el contenido de bx a cx
       
    mov ah,02     ;Función 02h de int 10h posicionar el cursor
    mov dx,0b27h  ;Posiciona el cursor (dl,dh)
    mov bh,00     ;Pagina de video principal
    int 10h       ;Interrupción para ejecutar la función 02h

    mov ah,09       ;Funcion 09 de int 21h para la visualización de cadenas
    mov dx,offset msj4 ;Desplegar mensaje msj1
    int 21h
 
    mov ah,02     ;Función 02h de int 10h posicionar el cursor
    mov dx,0b3ah  ;Posiciona el cursor (dl,dh)
    mov bh,00     ;Página de video principal
    int 10h       ;Interrupción para ejecutar la función 02h
 
    mov dl,ch     ;Asigna el contenido de ch a dl
    mov dh,cl     ;Asigna el contenido de cl a dh
 
    mov ah,02     ;Función 02 de int 21h Salida de caracter
    mov cx,01     ;Asigna 01 a cx
    int 21h
    mov ch,dh      ;Asigna el contenido de dh a ch
    mov dl,ch      ;Asigna el contenido de ch a dl
    int 21h
.exit ;Fin del proceso
end