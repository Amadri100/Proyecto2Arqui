includelib \Windows\System32\kernel32.dll
includelib ucrt.lib
includelib legacy_stdio_definitions.lib

EXTERN printf: PROC
EXTERN scanf: PROC

ExitProcess proto

.data
    matriz1 dq 0,0,0, 0,0,0, 0,0,0
    matriz2 dq 0,0,0, 0,0,0, 0,0,0
    matrizdif dq 0,0,0, 0,0,0, 0,0,0
    distancia dq ?
    labelM1  db "Matriz 1: ", 10, 0
    labelM2 db "Matriz 2: ", 10, 0
    labelFila1 db "Fila 1: ", 10, 0
    labelFila2 db "Fila 2: ", 10, 0
    labelFila3 db "Fila 3: ", 10, 0
    filaTest1 db "Fila 1: %lf, %lf, %lf",10 ,0
    filaTest2 db "Fila 2: %lf, %lf, %lf",10 ,0
    filaTest3 db "Fila 3: %lf, %lf, %lf",10 ,0
    tomaUnDouble  db "%lf", 0       ;Toma un double
    mostrarResultado db "La distancia de frobenius = %lf",10,0
    mask_val_absoluto dq 7FFFFFFFFFFFFFFFh, 7FFFFFFFFFFFFFFFh, 7FFFFFFFFFFFFFFFh, 7FFFFFFFFFFFFFFFh
.code
main PROC
    sub RSP, 28h  

    call leerEntradas
    xor RAX, RAX

    lea R8,  matriz1
    lea R9,  matriz2
    lea R10, matrizdif

    ; Fila 0
    vmovupd xmm0, [R8]
    vmovupd xmm1, [R9]
    vsubpd  xmm2, xmm0, xmm1
    vmovupd [R10], xmm2

    movsd xmm0, QWORD PTR [R8+16]
    movsd xmm1, QWORD PTR [R9+16]
    subsd xmm0, xmm1
    movsd QWORD PTR [R10+16], xmm0

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

    ;call printMatrix1
    ;call printMatrix2
    call normaFrobenius
    call printResultado

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

printResultado PROC
    sub rsp, 28h
    lea rcx, mostrarResultado
    lea RAX, distancia
    movsd xmm1, QWORD PTR [RAX]
    movq rdx, xmm1
    call printf
    add rsp, 28h
    ret

printResultado ENDP


normaFrobenius PROC
;Matriz:
;a, b, c
;d, e, f
;g, h, i
;Cargar Datos
vmovupd YMM0, [matrizdif] ;YMM0 <- a,b,c,d(no se usa)
vmovupd YMM1, [matrizdif+18h] ;YMM1<- d,e,f,g(no se usa)
vmovupd XMM8, [matrizdif+30h] ;XMM8 <- g, h
vxorpd XMM9,XMM9,XMM9
vmovsd  XMM9, [matrizdif+40h] ;XMM9 <- i, 0
vinsertf128 YMM2, YMM2, XMM8, 0     ;YMM2 <- g, h, ?, ?
vinsertf128 YMM2, YMM2, XMM9, 1     ;YMM2 <- g, h, i, 0
;vinsertf128, inserta segun el ultimo parametro 0: abajo 1: arriba
;Valores absolutos
vmovapd YMM8, [mask_val_absoluto] ; Mascara deja todos los bits prendidos excepto 
                                ; el de signo
                                ; YMM8 <- [valor_max_sinSigno,..,..,...]
vandpd YMM0, YMM0, YMM8 ; |YMM0| -> valor abs de todos los valores en YMM0
vandpd YMM1, YMM1, YMM8 ; |YMM1| 
vandpd YMM2, YMM2, YMM8 ; |YMM2|
;Elevarlos al cuadrado
vmulpd YMM0, YMM0, YMM0 ;YMM0^2 <- YMM0 * YMM0
vmulpd YMM1, YMM1, YMM1
vmulpd YMM2, YMM2, YMM2
;Sumarlos registros
vaddpd YMM1, YMM0, YMM1 
vaddpd YMM2, YMM1, YMM2
vxorpd YMM3, YMM3, YMM3 ;YMM3 <- 0,0,0,0
vpcmpeqq YMM3, YMM3, YMM3 ;YMM3 <- val_max, val_max,....
;La instruccion compara YMM3 == YMM3 en 2 partes de 128 bits
;Si son iguales deja  FFFFFFFFFFFFFFFFH en la parte correspondiente en el registro destino
sub RSP, 20h
vmovupd [RSP], YMM3
;RSP : val_max
;RSP +8h : val_max
;RSP +10h : val_max
;RSP +18h : val_max
xor RAX,RAX
mov [RSP+18h], RAX ; RSP+18h <- 0
vmovupd YMM3, [RSP] ;YMM3 <- todos valor maximo menos el ultimo que es 0
add RSP, 20h
vandpd YMM2, YMM2, YMM3 ;YMM2 <- valor eliminando la basura en la ultima posicion
vextractf128 XMM3, YMM2, 1
vaddpd XMM0, XMM2, XMM3
movsd XMM1, XMM0
movhlps XMM2, XMM0
vaddsd XMM3, XMM1, XMM2
vsqrtsd XMM0, XMM0, XMM3 
vmovsd [distancia], XMM0
ret

normaFrobenius ENDP

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