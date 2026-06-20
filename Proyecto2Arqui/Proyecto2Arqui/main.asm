includelib \Windows\System32\kernel32.dll
includelib ucrt.lib
includelib legacy_stdio_definitions.lib

EXTERN printf: PROC
EXTERN scanf: PROC

ExitProcess proto

.data
    matriz1 dq 0,0,0, 0,0,0, 0,0,0
    matriz2 dq 0,0,0, 0,0,0, 0,0,0
    labelM1  db "Matriz 1: ", 10, 0
    labelM2 db "Matriz 2: ", 10, 0
    labelFila1 db "Fila 1: ", 10, 0
    labelFila2 db "Fila 2: ", 10, 0
    labelFila3 db "Fila 3: ", 10, 0
    filaTest1 db "Fila 1: %lf, %lf, %lf",10 ,0
    filaTest2 db "Fila 2: %lf, %lf, %lf",10 ,0
    filaTest3 db "Fila 3: %lf, %lf, %lf",10 ,0
    tomaUnDouble  db "%lf", 0       ;Toma un double
    matrizDiff dq 0,0,0, 0,0,0, 0,0,0
    labelDiff db "Matriz diferencia:", 10, 0
    filaDiff1  db "Fila 1: %lf, %lf, %lf", 10, 0
    filaDiff2  db "Fila 2: %lf, %lf, %lf", 10, 0
    filaDiff3  db "Fila 3: %lf, %lf, %lf", 10, 0
 
.code
main PROC
    sub RSP, 28h  

    call leerEntradas
    xor RAX, RAX
    lea R8,  matriz1
    lea R9,  matriz2
    lea R10, matrizDiff

    ; Fila 0 
    vmovupd ymm0, [R8]          ; carga 4 doubles desde matriz1 (el 4to es de la fila 2, lo ignoramos)
    vmovupd ymm1, [R9]
    vsubpd  ymm2, ymm0, ymm1
    vmovupd [R10], ymm2 

    ; Fila 1
    vmovupd xmm0, [R8+24]
    vmovupd xmm1, [R9+24]
    vsubpd  xmm2, xmm0, xmm1
    vmovupd [R10+24], xmm2

    movsd xmm0, QWORD PTR [R8+40]
    movsd xmm1, QWORD PTR [R9+40]
    subsd xmm0, xmm1
    movsd QWORD PTR [R10+40], xmm0

    ; Fila 2
    vmovupd xmm0, [R8+48]
    vmovupd xmm1, [R9+48]
    vsubpd  xmm2, xmm0, xmm1
    vmovupd [R10+48], xmm2

    movsd xmm0, QWORD PTR [R8+64]
    movsd xmm1, QWORD PTR [R9+64]
    subsd xmm0, xmm1
    movsd QWORD PTR [R10+64], xmm0

    call printMatrix1
    call printMatrix2
    call printMatrizDiff
    mov ECX, 0          ; codigo de salida
    call ExitProcess

main ENDP

printMatrix1 PROC

    sub rsp, 28h         

    lea rcx, labelM1
    call printf

    
    lea rcx, filaTest1
    lea RAX, matriz1
    movsd xmm1, QWORD PTR [RAX]
    movq rdx, xmm1
    movsd xmm2, QWORD PTR [RAX+8]
    movq r8, xmm2
    movsd xmm3, QWORD PTR [RAX+16]
    movq r9, xmm3
    call printf

   
    lea rcx, filaTest2
    lea RAX, matriz1
    movsd xmm1, QWORD PTR [RAX+24]
    movq rdx, xmm1
    movsd xmm2, QWORD PTR [RAX+32]
    movq r8, xmm2
    movsd xmm3, QWORD PTR [RAX+40]
    movq r9, xmm3
    call printf

    
    lea rcx, filaTest3
    lea RAX, matriz1
    movsd xmm1, QWORD PTR [RAX+48]
    movq rdx, xmm1
    movsd xmm2, QWORD PTR [RAX+56]
    movq r8, xmm2
    movsd xmm3, QWORD PTR [RAX+64]
    movq r9, xmm3
    call printf

    add rsp, 28h
    ret

printMatrix1 ENDP

printMatrix2 PROC

    sub rsp, 28h         

    lea rcx, labelM1
    call printf

    
    lea rcx, filaTest1
    lea RAX, matriz2
    movsd xmm1, QWORD PTR [RAX]
    movq rdx, xmm1
    movsd xmm2, QWORD PTR [RAX+8]
    movq r8, xmm2
    movsd xmm3, QWORD PTR [RAX+16]
    movq r9, xmm3
    call printf

   
    lea rcx, filaTest2
    lea RAX, matriz2
    movsd xmm1, QWORD PTR [RAX+24]
    movq rdx, xmm1
    movsd xmm2, QWORD PTR [RAX+32]
    movq r8, xmm2
    movsd xmm3, QWORD PTR [RAX+40]
    movq r9, xmm3
    call printf

    
    lea rcx, filaTest3
    lea RAX, matriz2
    movsd xmm1, QWORD PTR [RAX+48]
    movq rdx, xmm1
    movsd xmm2, QWORD PTR [RAX+56]
    movq r8, xmm2
    movsd xmm3, QWORD PTR [RAX+64]
    movq r9, xmm3
    call printf

    add rsp, 28h
    ret

printMatrix2 ENDP

printMatrizDiff PROC
    sub RSP, 28h

    lea RCX, labelDiff
    call printf

    lea RCX, filaDiff1
    lea RAX, matrizDiff
    movsd xmm1, QWORD PTR [RAX]
    movq rdx, xmm1
    movsd xmm2, QWORD PTR [RAX+8]
    movq r8, xmm2
    movsd xmm3, QWORD PTR [RAX+16]
    movq r9, xmm3
    call printf

    lea RCX, filaDiff2
    lea RAX, matrizDiff
    movsd xmm1, QWORD PTR [RAX+24]
    movq rdx, xmm1
    movsd xmm2, QWORD PTR [RAX+32]
    movq r8, xmm2
    movsd xmm3, QWORD PTR [RAX+40]
    movq r9, xmm3
    call printf

    lea RCX, filaDiff3
    lea RAX, matrizDiff
    movsd xmm1, QWORD PTR [RAX+48]
    movq rdx, xmm1
    movsd xmm2, QWORD PTR [RAX+56]
    movq r8, xmm2
    movsd xmm3, QWORD PTR [RAX+64]
    movq r9, xmm3
    call printf

    add RSP, 28h
    ret
printMatrizDiff ENDP


output PROC

output ENDP

leerEntradas PROC
    
    sub RSP, 38h ;32 bytes Shadow space + 8bytes de alineamiento + 16bits de variables locales
                 ;Al llamar leerEntradas queda alineado 16bytes pero 
                 ;Si se llama otra funcion se agregan 8 bytes el alineamiento

    ;[RSP +28h] -> Filas
    ;[RSP +30h] -> Contador columnas
    ;R13 -> temp

    mov R13, 0
    mov [RSP +28h], R13; 
    mov [RSP +30h], R13;

    lea RCX, labelM1
    call printf

    tomarDatosMatriz1:
        mov R13, 0
        mov [RSP +30h], R13
        mov R14, [RSP + 28h]
        cmp R14, 0 ;IF Fila == 0
        je fila1m1
        cmp R14, 1 ;IF Fila == 1
        je fila2m1
        cmp R14, 2 ;IF Fila == 2
        je fila3m1
        jmp terminarDatosMatriz1 ; ELSE
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
            mov RAX, [RSP + 28h] ;RAX <- fila
            mov R13, 3   ;
            xor RDX, RDX ; Limpiar RDX
            mul R13      ;fila * 3
            add RAX, [RSP +30h] ; fila + columna
            mov R13, 8   ;R13 = 8
            xor RDX, RDX ; Limpiar RDX
            mul R13      ;8*(3*fila+columna)
            lea R13, matriz1
            add RAX, R13 ;Dirreccion especifica
            xor R15,R15
            lea RCX, tomaUnDouble ;
            mov RDX, RAX       
            call scanf
            inc QWORD PTR [RSP +30h]
            mov R15, [RSP +30h]
            cmp R15, 3
            jl ciclos_columnas
            if_r15_GE_3:
                inc QWORD PTR [RSP + 28h]
                jmp tomarDatosMatriz1
    terminarDatosMatriz1:
        mov R13, 0
        mov [RSP + 28h], R13; 
        mov [RSP +30h], R13;
        lea RCX, labelM2
        call printf
        tomarDatosMatriz2:
            mov R13, 0
            mov [RSP +30h], R13
            mov R14, [RSP + 28h]
            cmp R14, 0
            je fila1m2
            cmp R14, 1
            je fila2m2
            cmp R14, 2
            je fila3m2
            jmp terminarDatosMatriz2
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
                mov RAX, [RSP + 28h]     ; RAX <- fila
                mov R13, 3            ;
                xor RDX, RDX
                mul R13               ; fila * 3
                add RAX, [RSP +30h]     ; fila + columna
                mov R13, 8            ; R13 = 8
                xor RDX, RDX
                mul R13               ; 8*(3*fila+columna)
                lea R13, matriz2
                add RAX, R13      ; Dirreccion especifica
                lea RCX, tomaUnDouble ; 
                mov RDX, RAX
                call scanf
                inc QWORD PTR [RSP +30h]
                mov R15, [RSP +30h]
                cmp R15, 3
                jl ciclos_columnas_m2
                if_r15_GE_3_m2:
                    inc QWORD PTR [RSP + 28h]
                    jmp tomarDatosMatriz2
    terminarDatosMatriz2:
    
    add RSP, 38h
    ret
leerEntradas ENDP
END