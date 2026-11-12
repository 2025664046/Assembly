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
    ; "정수 입력 (1/5): " (UTF-16 유니코드)
    prompt      WORD 0C815h, 0C218h, ' ', 0C785h, 0B825h, ' ', '(', '1', '/', '5', ')', ':', ' ', 0
    prompt_len  DWORD ($ - prompt) / 2 - 1

    ; "평균값: " (UTF-16 유니코드)
    msg_avg     WORD 0D3C9h, 0ADE0h, 0AC12h, ':', ' ', 0
    msg_avg_len DWORD ($ - msg_avg) / 2 - 1

    sum         SDWORD 0

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
; IntToWStr: EAX의 부호 있는 정수를 outBuf에 UTF-16 문자열로 변환
; 반환값: EAX = 출력할 문자 개수 (CR, LF 포함)
; ---------------------------------------------------------
IntToWStr PROC
    lea edi, outBuf
    xor ecx, ecx            ; 자릿수 카운터

    test eax, eax
    jnz CheckNegative
    mov word ptr [edi], '0'
    add edi, 2
    jmp AppendCRLF

CheckNegative:
    jns ConvertPositive
    mov word ptr [edi], '-'
    add edi, 2
    neg eax

ConvertPositive:
    mov ebx, 10

DivLoop:
    xor edx, edx
    div ebx                 ; EAX = 몫, EDX = 나머지
    add dl, '0'
    push edx
    inc ecx
    test eax, eax
    jnz DivLoop

PopLoop:
    pop edx
    mov word ptr [edi], dx
    add edi, 2
    loop PopLoop

AppendCRLF:
    mov word ptr [edi], 13  ; CR (\r)
    add edi, 2
    mov word ptr [edi], 10  ; LF (\n)
    add edi, 2
    mov word ptr [edi], 0   ; NULL 종료

    lea eax, outBuf
    sub edi, eax
    shr edi, 1              ; 바이트 길이를 WORD(2바이트) 개수로 변환
    mov eax, edi
    ret
IntToWStr ENDP

; ---------------------------------------------------------
; main 프로시저
; ---------------------------------------------------------
main PROC
    INVOKE GetStdHandle, STD_INPUT_HANDLE
    mov hStdIn, eax

    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov hStdOut, eax

    mov ecx, 5              ; 5회 반복

InputLoop:
    push ecx                ; Win32 API 호출 시 ECX가 변경되므로 스택에 백업

    ; 프롬프트의 순번('1'~'5') 갱신 (인덱스 7 -> 바이트 오프셋 14)
    mov eax, 6
    sub eax, ecx
    add ax, '0'
    mov word ptr [prompt + 14], ax

    ; 입력 안내 메시지 출력
    INVOKE WriteConsoleW, hStdOut, ADDR prompt, prompt_len, ADDR charsWrit, 0

    ; 콘솔에서 문자열 입력
    INVOKE ReadConsoleW, hStdIn, ADDR inBuf, 64, ADDR charsRead, 0

    ; 문자열을 정수로 변환 후 sum에 누적
    call WStrToInt
    add sum, eax

    pop ecx                 ; 반복 카운터 복원
    loop InputLoop

    ; 평균 계산 (sum / 5)
    mov eax, sum
    cdq                     ; 부호 있는 나눗셈을 위해 EAX를 EDX:EAX로 부호 확장
    mov ebx, 5
    idiv ebx                ; EAX = 평균값(몫)

    push eax                ; 평균값 임시 저장

    ; "평균값: " 출력
    INVOKE WriteConsoleW, hStdOut, ADDR msg_avg, msg_avg_len, ADDR charsWrit, 0

    ; 평균값을 문자열로 변환하여 출력
    pop eax
    call IntToWStr
    INVOKE WriteConsoleW, hStdOut, ADDR outBuf, eax, ADDR charsWrit, 0

    INVOKE ExitProcess, 0
main ENDP

END main
