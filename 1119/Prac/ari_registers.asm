.386
.model flat, stdcall
option casemap :none

includelib kernel32.lib

GetStdHandle  PROTO :DWORD
ReadConsoleW  PROTO :DWORD, :PTR WORD, :DWORD, :PTR DWORD, :DWORD
WriteConsoleW PROTO :DWORD, :PTR WORD, :DWORD, :PTR DWORD, :DWORD
ExitProcess   PROTO :DWORD

STD_INPUT_HANDLE  EQU -10
STD_OUTPUT_HANDLE EQU -11

.data
    ; "첫 번째 숫자 입력: "
    prompt1     WORD 0CCABh, ' ', 0BC88h, 0C9F8h, ' ', 0C22Bh, 0C790h, ' ', 0C785h, 0B825h, ':', ' ', 0
    prompt1_len DWORD ($ - prompt1) / 2 - 1

    ; "두 번째 숫자 입력: "
    prompt2     WORD 0B450h, ' ', 0BC88h, 0C9F8h, ' ', 0C22Bh, 0C790h, ' ', 0C785h, 0B825h, ':', ' ', 0
    prompt2_len DWORD ($ - prompt2) / 2 - 1

    ; 연산별 제목 (UTF-16)
    msg_add     WORD 13, 10, '[', '1', '.', ' ', 0B367h, 0C148h, ' ', '(', 'A', 'D', 'D', ')', ' ', 0ACB0h, 0ACFCh, ']', 13, 10, 0
    msg_add_len DWORD ($ - msg_add) / 2 - 1

    msg_sub     WORD 13, 10, '[', '2', '.', ' ', 0BE84h, 0C148h, ' ', '(', 'S', 'U', 'B', ')', ' ', 0ACB0h, 0ACFCh, ']', 13, 10, 0
    msg_sub_len DWORD ($ - msg_sub) / 2 - 1

    msg_mul     WORD 13, 10, '[', '3', '.', ' ', 0ACF1h, 0C148h, ' ', '(', 'I', 'M', 'U', 'L', ')', ' ', 0ACB0h, 0ACFCh, ']', 13, 10, 0
    msg_mul_len DWORD ($ - msg_mul) / 2 - 1

    msg_div     WORD 13, 10, '[', '4', '.', ' ', 0B098h, 0B217h, 0C148h, ' ', '(', 'I', 'D', 'I', 'V', ')', ' ', 0ACB0h, 0ACFCh, ']', 13, 10, 0
    msg_div_len DWORD ($ - msg_div) / 2 - 1

    ; 레지스터 라벨
    lbl_eax     WORD 'E', 'A', 'X', ' ', '=', ' ', 0
    lbl_ebx     WORD ' ', ' ', ' ', 'E', 'B', 'X', ' ', '=', ' ', 0
    lbl_ecx     WORD ' ', ' ', ' ', 'E', 'C', 'X', ' ', '=', ' ', 0
    lbl_edx     WORD ' ', ' ', ' ', 'E', 'D', 'X', ' ', '=', ' ', 0
    crlf        WORD 13, 10, 0

    num1        SDWORD 0
    num2        SDWORD 0

.data?
    hStdIn      DWORD ?
    hStdOut     DWORD ?
    charsRead   DWORD ?
    charsWrit   DWORD ?
    inBuf       WORD 64 DUP(?)
    outBuf      WORD 64 DUP(?)

.code

; ---------------------------------------------------------
; WStrToInt: inBuf의 UTF-16 문자열을 32비트 부호 있는 정수로 변환
; 반환값: EAX = 변환된 정수
; ---------------------------------------------------------
WStrToInt PROC
    lea esi, inBuf
    xor eax, eax            ; 누적 결과값 초기화
    xor ebx, ebx            ; 부호 플래그 (0: 양수, 1: 음수)

SkipSpace:
    movzx edx, word ptr [esi]
    cmp dx, ' '
    jne CheckSign
    add esi, 2
    jmp SkipSpace

CheckSign:
    cmp dx, '-'
    jne CheckPlus
    mov ebx, 1
    add esi, 2
    jmp ParseLoop

CheckPlus:
    cmp dx, '+'
    jne ParseLoop
    add esi, 2

ParseLoop:
    movzx edx, word ptr [esi]
    cmp dx, '0'
    jb DoneParse
    cmp dx, '9'
    ja DoneParse

    sub edx, '0'
    imul eax, eax, 10
    add eax, edx
    add esi, 2
    jmp ParseLoop

DoneParse:
    cmp ebx, 1
    jne ReturnVal
    neg eax

ReturnVal:
    ret
WStrToInt ENDP

; ---------------------------------------------------------
; PrintHex32: EAX의 32비트 값을 8자리 16진수(UTF-16)로 출력
; ---------------------------------------------------------
PrintHex32 PROC
    pushad                  ; 모든 범용 레지스터 백업

    lea edi, outBuf
    mov ecx, 8              ; 32비트 = 16진수 8자리
    mov ebx, eax            ; 출력할 값 복사

HexLoop:
    rol ebx, 4              ; 상위 4비트를 최하위로 회전
    mov edx, ebx
    and edx, 0Fh            ; 하위 4비트만 추출

    cmp dl, 9
    jbe IsDigit
    add dl, 7               ; 10~15 -> 'A'~'F' 보정
IsDigit:
    add dl, '0'
    mov word ptr [edi], dx
    add edi, 2
    loop HexLoop

    mov word ptr [edi], 0
    INVOKE WriteConsoleW, hStdOut, ADDR outBuf, 8, ADDR charsWrit, 0

    popad                   ; 레지스터 복원
    ret
PrintHex32 ENDP

; ---------------------------------------------------------
; PrintRegs: 호출 시점의 EAX, EBX, ECX, EDX 값을 화면에 출력
; ---------------------------------------------------------
PrintRegs PROC
    ; Win32 API 호출 시 EAX, ECX, EDX가 변경되므로 먼저 스택에 보관
    push edx
    push ecx
    push ebx
    push eax

    ; EAX 출력
    INVOKE WriteConsoleW, hStdOut, ADDR lbl_eax, 6, ADDR charsWrit, 0
    mov eax, [esp]          ; 스택에 백업된 EAX
    call PrintHex32

    ; EBX 출력
    INVOKE WriteConsoleW, hStdOut, ADDR lbl_ebx, 9, ADDR charsWrit, 0
    mov eax, [esp + 4]      ; 스택에 백업된 EBX
    call PrintHex32

    ; ECX 출력
    INVOKE WriteConsoleW, hStdOut, ADDR lbl_ecx, 9, ADDR charsWrit, 0
    mov eax, [esp + 8]      ; 스택에 백업된 ECX
    call PrintHex32

    ; EDX 출력
    INVOKE WriteConsoleW, hStdOut, ADDR lbl_edx, 9, ADDR charsWrit, 0
    mov eax, [esp + 12]     ; 스택에 백업된 EDX
    call PrintHex32

    ; 줄바꿈
    INVOKE WriteConsoleW, hStdOut, ADDR crlf, 2, ADDR charsWrit, 0

    pop eax
    pop ebx
    pop ecx
    pop edx
    ret
PrintRegs ENDP

; ---------------------------------------------------------
; main 프로시저
; ---------------------------------------------------------
main PROC
    INVOKE GetStdHandle, STD_INPUT_HANDLE
    mov hStdIn, eax

    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax

    ; 1. 첫 번째 숫자 입력
    INVOKE WriteConsoleW, hStdOut, ADDR prompt1, prompt1_len, ADDR charsWrit, 0
    INVOKE ReadConsoleW, hStdIn, ADDR inBuf, 64, ADDR charsRead, 0
    call WStrToInt
    mov num1, eax

    ; 2. 두 번째 숫자 입력
    INVOKE WriteConsoleW, hStdOut, ADDR prompt2, prompt2_len, ADDR charsWrit, 0
    INVOKE ReadConsoleW, hStdIn, ADDR inBuf, 64, ADDR charsRead, 0
    call WStrToInt
    mov num2, eax

    ; -----------------------------------------
    ; [1] 덧셈: EAX = num1 + num2
    ; -----------------------------------------
    INVOKE WriteConsoleW, hStdOut, ADDR msg_add, msg_add_len, ADDR charsWrit, 0
    mov eax, num1
    mov ebx, num2
    xor ecx, ecx
    xor edx, edx
    add eax, ebx            ; 결과를 EAX에 저장
    call PrintRegs

    ; -----------------------------------------
    ; [2] 뺄셈: EAX = num1 - num2
    ; -----------------------------------------
    INVOKE WriteConsoleW, hStdOut, ADDR msg_sub, msg_sub_len, ADDR charsWrit, 0
    mov eax, num1
    mov ebx, num2
    xor ecx, ecx
    xor edx, edx
    sub eax, ebx            ; 결과를 EAX에 저장
    call PrintRegs

    ; -----------------------------------------
    ; [3] 곱셈: EDX:EAX = num1 * num2
    ; -----------------------------------------
    INVOKE WriteConsoleW, hStdOut, ADDR msg_mul, msg_mul_len, ADDR charsWrit, 0
    mov eax, num1
    mov ebx, num2
    xor ecx, ecx
    xor edx, edx
    imul ebx                ; 부호 있는 32비트 곱셈 (상위 32비트 EDX, 하위 32비트 EAX)
    call PrintRegs

    ; -----------------------------------------
    ; [4] 나눗셈: EAX = 몫, EDX = 나머지
    ; -----------------------------------------
    INVOKE WriteConsoleW, hStdOut, ADDR msg_div, msg_div_len, ADDR charsWrit, 0
    mov eax, num1
    mov ebx, num2
    xor ecx, ecx
    cdq                     ; EAX의 부호 비트를 EDX 전체로 확장
    idiv ebx                ; 부호 있는 32비트 나눗셈 (몫은 EAX, 나머지는 EDX)
    call PrintRegs

    INVOKE ExitProcess, 0
main ENDP

END main
