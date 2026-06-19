includelib \Windows\System32\kernel32.dll
includelib ucrt.lib
includelib legacy_stdio_definitions.lib

EXTERN printf: PROC
EXTERN scanf: PROC

ExitProcess proto

.data
    labelM1  db "Matriz 1: ", 10, 0
    labelM2 db "Matriz 2: ", 10, 0
    labelFila1 db "Fila 1: ", 10, 0
    labelFila2 db "Fila 2: ", 10, 0
    labelFila3 db "Fila 3: ", 10, 0
    tomaUnDouble  db "%lf", 0       ;Toma un double
    matriz1 dq 0,0,0, 0,0,0, 0,0,0
    matriz2 dq 0,0,0, 0,0,0, 0,0,0

.code
main PROC
    sub RSP, 28h ; reservar espacio en la 
    sub RSP, 10h ; reservar espacio para alinear la pila a 16 bytes

    call leerEntradas

    mov ECX, 0          ; codigo de salida
    call ExitProcess

main ENDP

output PROC

output ENDP

leerEntradas PROC
    ;push RBX            ; preservar RBX, RSP-8
    ;sub RSP, 20h       

    ;R14 -> Filas
    ;R15 -> Contador columnas
    ;R13 -> temp

    mov R14, 0; 
    mov R15, 0;
    mov R13, 0;

    lea RCX, labelM1
    call printf

    tomarDatosMatriz1:
        mov R15, 0
        cmp R14, 0
        je fila1m1
        cmp R14, 1
        je fila2m1
        cmp R14, 2
        je fila3m1
        jmp terminarDatosMatriz1
        fila1m1:
            lea RCX, labelFila1
            call printf
            jmp ciclos_columnas
        fila2m1:
            lea RCX, labelFila2
            call printf
            jmp ciclos_columnas
        fila3m1:
            lea RCX, labelFila3
            call printf
            jmp ciclos_columnas
        ciclos_columnas:
            ;8*3 *fila + columna*8
            ;8*(3*fila+columna)
            mov RAX, R14 ;RAX <- fila
            mov R13, 3   ;
            xor RDX, RDX ; Limpiar RDX
            mul R13      ;fila * 3
            add RAX, R15 ; fila + columna
            mov R13, 8   ;R13 = 8
            xor RDX, RDX ; Limpiar RDX
            mul R13      ;8*(3*fila+columna)
            add RAX, matriz1;Dirreccion especifica
            lea RCX, tomaUnDouble ;
            mov RDX, RAX       
            call scanf
            inc R15
            cmp R15, 3
            jmp ciclos_columnas
            if_r15_LE_3:
                inc R14
                jmp tomarDatosMatriz1
    terminarDatosMatriz1:
        mov R14, 0; 
        mov R15, 0;
        lea RCX, labelM1
        call printf
        tomarDatosMatriz2:
            mov R15, 0
            cmp R14, 0
            je fila1m2
            cmp R14, 1
            je fila2m2
            cmp R14, 2
            je fila3m2
            jmp terminarDatosMatriz1
            fila1m2:
                lea RCX, labelFila1
                call printf
                jmp ciclos_columnas_m2
            fila2m2:
                lea RCX, labelFila2
                call printf
                jmp ciclos_columnas_m2
            fila3m2:
                lea RCX, labelFila3
                call printf
                jmp ciclos_columnas_m2
            ciclos_columnas_m2:
                ;8*3 *fila + columna*8
                ;8*(3*fila+columna)
                mov RAX, R14          ; RAX <- fila
                mov R13, 3            ;
                xor RDX, RDX
                mul R13               ; fila * 3
                add RAX, R15          ; fila + columna
                mov R13, 8            ; R13 = 8
                xor RDX, RDX
                mul R13               ; 8*(3*fila+columna)
                add RAX, matriz2      ; Dirreccion especifica
                lea RCX, tomaUnDouble ; 
                mov RDX, RAX
                call scanf
                inc R15
                cmp R15, 3
                jmp ciclos_columnas_m2
                if_r15_LE_3_m2:
                    inc R14
                    jmp tomarDatosMatriz2
    terminarDatosMatriz2:
    
    ;add RSP, 20h
    ret
leerEntradas ENDP
END