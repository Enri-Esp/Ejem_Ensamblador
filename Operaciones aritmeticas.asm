;Programa que realiza las cuatro operaciones basicas con dos numeros del 0 al 9
.model small    ;modelo con un solo segmento de datos
.stack 64       ;tamano de la pila
.data
    ;seccion de data
    n1 db 0 ;variable para almacenar numero a operar
    n2 db 0 ;variable para almacenar numero a operar
    r  db ? ;variable para almacenar el residuo
    
    
    ;declaracion de mensajes con retorno de carro
    mensaje1 db 10,13, "Ingresa el primer valor: ",'$'
    mensaje2 db 10,13, "Ingresa el segundo valor: ",'$'
    mensaje3 db 10,13, "Suma= ",'$'
    mensaje4 db 10,13, "Resta= ",'$'
    mensaje5 db 10,13, "Multipicacion= ",'$'
    mensaje6 db 10,13, "Division: ",'$'  
    mensaje7 db 10,13, "    Cociente= ",'$'
    mensaje8 db 10,13, "    Residuo= ",'$' 
    signo    db 10,13, "-", '$'
    
    .code
    inicio proc far
    mov ax,@data            ;Cargamos la data en el acumulador
    mov ds,ax               ;Movemos acumulador al registro de segmento de datos
    
    ;imprimir mensaje 1
    mov ah,09               ;Servicio 9 para imprimir cadenas
    lea dx,mensaje1         ;Selecionamos mensaje 1 cargandolo al registro de datos
    int 21h                 ;Imprimimos
    mov ah,01               ;Servicio 1 para la captura de numero
    int 21h                 ;Regresamos el control a SO
    sub al,30h              ;Le restamos 30h para convertirlo a numero
    mov n1,al               ;Movemos n1 a al  
    
    ;imprime mensaje 2
    mov ah,09               ;Servicio 9 para imprimir cadenas
    lea dx,mensaje2         ;Seleccionamos mensaje 2 cargandolo al registro de datos
    int 21h                 ;Imprimimos
    mov ah,01               ;Servicio 1 para la captura de numero
    int 21h                 ;Regresamos el control a SO
    sub al,30h              ;Le restamos 30h para convertirlo a numero
    mov n2,al               ;Movemos n2 a al  
        
        
    ;SUMA
    mov ah,09               ;Servicio 9 para imprimir cadenas
    lea dx,mensaje3         ;Seleccionamos mensaje 3 cargandolo al registro de datos
    int 21h                 ;Imprimimos
    and ah,00h              ;Le aplicamos una mascara a la parte superior de AX para que quede con ceros 0000
    and bh,00h              ;Le aplicamos una mascara a la parte superior de BX para que quede con ceros 0000
    mov al,n1               ;movemos el numero n1 a al
    add al,n2               ;sumamos el numero n2 a al y el resultado se almacena en al
    aaa                     ;Ajuste ascii para la suma
    or  ax,3030h
    mov bx,ax               ;Movemos ax a bx
    mov ah,02h              ;Servicio 2 imprime un caracter almacenado en dl
    mov dl,bh               ;Movemos bh a dl
    int 21h                 ;Imprimimos las decenas
    mov dl,bl               ;Movemos bl a dl
    int 21h                 ;Imprimimos las unidades
       
       
    
    ;RESTA
    mov ah,09               ;Servicio 9 para imprimir cadenas
    lea dx,mensaje4         ;Seleccionamos mensaje 4 cargandolo al registro de datos
    int 21h                 ;Imprimimos
    
    and ah,00h              ; AX = 00??
    and bh,00h              ; BX = 00??

    mov al,n1               ;Movemos n1 a al
    sub al,30h              ;Le restamos 30h para convertirlo a numero
    mov bl,n2               ;Movemos n2 a bl
    sub bl,30h              ;Le restamos 30h para convertirlo a numero
       
    cmp ax,bx               ;Comparamos la variable n1 y n2
    jl negativo             ;Si n1 es menor que n2 entonces saltara hasta negativo
    jge  positivo           ;Si n1 es mayor o igual que n2 entonces saltara a positico
    
negativo:                   
    
    mov ah,09               ;Servicio 9 para imprimir cadenas
    lea dx,signo            ;Seleccionamos signo cargandolo al registro de datos
    int 21h                 ;Imprimimos '-'
    and ah,00h              ;AX = 00??
    and bh,00h              ;BX = 00??

    mov bl,n1               ;Movemosn1 a bl 
    sub bl,30h              ;Le restamos 30h para convertirlo a numero
    mov al,n2               ;Movemos n2 a al
    sub al,30h              ;Le restamos 30h para convertirlo a numero   
    
positivo:
    
    sub al,bl               ;Restamos bl - al

    mov ah,2                ;Servicio 2 imprime un caracter almacenado en dl
    mov dl,al               ;Pasamos a dl el resultado
    add dl,30h              ;Sumamos 30h a dl para convertirlo a caracter
    int 21h                 ;Imprimimos el resultado 
    
    
    ;MULTIPLICACION 
    mov ah,09               ;Servicio 9 para imprimir cadenas
    lea dx,mensaje5         ;Seleccionamos mensaje 5 cargandolo al registro de datos
    int 21h
    and ah,00h              ;AX = 00??
    and bh,00h              ;BX = 00??
    mov al,n1               ;Movemos el numero n1 a al
    mul n2                  ;Multiplicamos AX*n2 el resultado lo almacena en AX
    aam                     ;Ajuste ASCII para la multiplicacion
    or  ax,3030h
    mov bx,ax
    mov ah,02h              ;impresion de decenas
    mov dl,bh
    int 21h
    mov dl,bl               ;impresion de unidades 
    int 21h
    
    ;DIVISION
    mov ah,09               ;Servicio 9 para imprimir cadenas
    lea dx,mensaje6         ;Seleccionamos mensaje 6 cargandolo al registro de datos
    int 21h
    lea dx,mensaje7         ;Seleccionamos mensaje 7 cargandolo al registro de datos
    int 21h
        
        
    and ah,00h              ;AX = 00??
    and bh,00h              ;BX = 00?? 
    
    mov al,n1               ;Pasamos n1 a al
    
    div n2                  ;Dividimos AX/n2 el cociente lo almacena en al, el residuo queda en ah
    mov bx,ax               ;Pasamos el cociente a bx
    mov r,ah                ;Pasamos el residuo a r

                    
    mov ah,2                ;Servicio 2 para imprimir un caracter contenido en dl
    mov dx,bx               ;Pasamos a dx el cociente
    add dl,30h              ;Sumamos 30h a dl para convertirlo a caracter
    int 21h                 ;Imprimimos el resultado

        
    mov ah,9                ;Servicio 9 para imprimir cadenas
    lea dx,mensaje8         ;Seleccionamos mensaje 8 cargandolo al registro de datos
    int 21h                 ;Imprimimos

    mov ah,2                ;Servicio 2 para imprimir un caracter contenido en dl
    mov dl,r                ;Pasamos a dl el valor del residuo
    add dl,30h              ;Sumamos 30h a dl para convertirlo a caracter
    int 21h
    
    
    
    mov ah,4ch  ;Terminamos el programa
    int 21h         
 