# 7.9 Review Questions and Exercises

## 7.9.1 Short Answer

**1.** In the following code sequence, show the value of AL after each shift or rotate instruction has executed:

```asm
mov al,0D4h                              ; 1101 0100
shr al,1                                 ; a. 0110 1010 = 6Ah
mov al,0D4h
sar al,1                                 ; b. 1110 1010 = EAh
mov al,0D4h
sar al,4                                 ; c. 1111 1101 = FDh
mov al,0D4h
rol al,1                                 ; d. 1010 1001 = A9h
```

| | 명령어 | 결과 (AL) | 설명 |
|---|---|---|---|
| a | `shr al,1` | **6Ah** | 논리 시프트: 왼쪽에 0 삽입 |
| b | `sar al,1` | **EAh** | 산술 시프트: 부호 비트(1) 유지 |
| c | `sar al,4` | **FDh** | 부호 비트(1)가 4번 채워짐 |
| d | `rol al,1` | **A9h** | 최상위 비트(1)가 최하위로 이동 |

**2.** In the following code sequence, show the value of AL after each shift or rotate instruction has executed:

```asm
mov al,0D4h
ror al,3                                 ; a. 9Ah
mov al,0D4h
rol al,7                                 ; b. 6Ah
stc
mov al,0D4h
rcl al,1                                 ; c. A9h  (CF = 1)
stc
mov al,0D4h
rcr al,3                                 ; d. 3Ah  (CF = 1)
```

| | 명령어 | 계산 과정 | 결과 (AL) |
|---|---|---|---|
| a | `ror al,3` | `1101 0100` → 하위 3비트 `100`이 상위로 → `1001 1010` | **9Ah** |
| b | `rol al,7` | 왼쪽 7회 회전 = 오른쪽 1회 회전 → `0110 1010` | **6Ah** |
| c | `rcl al,1` | CF:AL = `1:1101 0100` → 왼쪽 1회 → CF=1, AL=`1010 1001` | **A9h** |
| d | `rcr al,3` | CF:AL = `1:1101 0100` (9비트) → 오른쪽 3회 → CF=1, AL=`0011 1010` | **3Ah** |

**3.** What will be the contents of AX and DX after the following operation?

```asm
mov dx,0
mov ax,222h
mov cx,100h
mul cx
```

`222h × 100h = 22200h` 이고, 16비트 `MUL`의 결과는 DX:AX에 저장된다.

```
DX = 0002h
AX = 2200h
```

**4.** What will be the contents of AX after the following operation?

```asm
mov ax,63h
mov bl,10h
div bl
```

`63h = 99`, `99 ÷ 16 = 6` 나머지 `3`. 8비트 `DIV`는 몫을 AL, 나머지를 AH에 저장한다.

```
AX = 0306h      ; AH(나머지) = 03h, AL(몫) = 06h
```

**5.** What will be the contents of EAX and EDX after the following operation?

```asm
mov eax,123400h
mov edx,0
mov ebx,10h
div ebx
```

`123400h ÷ 10h = 12340h`, 나머지 `0`.

```
EAX = 00012340h     ; 몫
EDX = 00000000h     ; 나머지
```

**6.** What will be the contents of AX and DX after the following operation?

```asm
mov ax,4000h
mov dx,500h
mov bx,10h
div bx
```

피제수 `DX:AX = 0500 4000h` 를 `10h`로 나누면 몫이 `00500400h`로 16비트(AX)에 들어가지 않는다.
따라서 **Divide Overflow 예외가 발생**하며 AX, DX에는 유효한 결과가 저장되지 않는다.

**7.** What will be the contents of BX after the following instructions execute?

```asm
mov bx,5
stc
mov ax,60h
adc bx,ax
```

`BX = 5 + 60h + CF(1) = 66h`

```
BX = 0066h
```

**8.** Describe the output when the following code executes in 64-bit mode:

```asm
.data
dividend_hi QWORD 00000108h
dividend_lo QWORD 33300020h
divisor QWORD 00000100h
.code
mov rdx,dividend_hi
mov rax,dividend_lo
div divisor
```

피제수는 `RDX:RAX`(128비트)이고, 몫은 RAX(64비트)에 들어가야 한다. 그런데 상위 부분 `RDX = 108h` 가 제수 `100h` 이상이므로 몫이 64비트를 초과한다.
따라서 **Divide Overflow 예외가 발생**한다. (출력 없이 프로그램이 비정상 종료됨)

> `DIV`가 정상 동작하려면 `RDX < divisor` 여야 한다.

**9.** The following program is supposed to subtract `val2` from `val1`. Find and correct all logic errors (CLC clears the Carry flag):

```asm
.data
val1 QWORD 20403004362047A1h
val2 QWORD 055210304A2630B2h
result QWORD 0
.code
mov cx,8 ; loop counter
mov esi,val1 ; set index to start
mov edi,val2
clc ; clear Carry flag
top:
mov al,BYTE PTR[esi] ; get first number
sbb al,BYTE PTR[edi] ; subtract second
mov BYTE PTR[esi],al ; store the result
dec esi
dec edi
loop top
```

**오류 목록**

1. `mov cx,8` → 32비트 모드에서 `LOOP`는 **ECX**를 사용하므로 `mov ecx,8` 이어야 한다.
2. `mov esi,val1`, `mov edi,val2` → 값이 아니라 **주소(OFFSET)** 를 넣어야 한다.
3. 결과를 `[esi]`(val1)에 덮어쓰고 있다 → `result` 변수에 저장해야 한다.
4. `dec esi`, `dec edi` → x86은 리틀 엔디언이므로 하위 바이트부터 처리하려면 주소를 **증가(inc)** 시켜야 한다. (`INC`/`DEC`는 Carry 플래그를 바꾸지 않으므로 `SBB`와 함께 써도 안전하다.)

**수정된 코드**

```asm
.data
val1   QWORD 20403004362047A1h
val2   QWORD 055210304A2630B2h
result QWORD 0
.code
mov  ecx,8                  ; loop counter
mov  esi,OFFSET val1        ; first operand
mov  edi,OFFSET val2        ; second operand
mov  ebx,OFFSET result      ; destination
clc                         ; clear Carry flag
top:
mov  al,BYTE PTR [esi]      ; get first number
sbb  al,BYTE PTR [edi]      ; subtract second (with borrow)
mov  BYTE PTR [ebx],al      ; store the result
inc  esi
inc  edi
inc  ebx
loop top
```

**10.** What will be the hexadecimal contents of RAX after the following instructions execute in 64-bit mode?

```asm
.data
multiplicand QWORD 0001020304050000h
.code
imul rax,multiplicand, 4
```

`×4`는 왼쪽으로 2비트 시프트하는 것과 같다. 바이트별로 `00 01 02 03 04 05 00 00` 에 4를 곱하면:

```
RAX = 0004080C10140000h
```

---

## 7.9.2 Algorithm Workbench

**1.** Write a sequence of shift instructions that cause AX to be sign-extended into EAX. In other words, the sign bit of AX is copied into the upper 16 bits of EAX. Do not use the CWD instruction.

```asm
shl  eax,16         ; AX를 상위 16비트로 이동
sar  eax,16         ; 부호 비트를 복사하며 다시 내림
```

**2.** Suppose the instruction set contained no rotate instructions. Show how you would use SHR and a conditional jump instruction to rotate the contents of the AL register 1 bit to the right.

```asm
shr  al,1           ; 최하위 비트가 CF로 이동
jnc  done           ; CF = 0 이면 그대로 종료
or   al,10000000b   ; CF = 1 이면 최상위 비트를 1로 설정
done:
```

**3.** Write a logical shift instruction that multiplies the contents of EAX by 16.

```asm
shl  eax,4          ; 2^4 = 16
```

**4.** Write a logical shift instruction that divides EBX by 4.

```asm
shr  ebx,2          ; 2^2 = 4
```

**5.** Write a single rotate instruction that exchanges the high and low halves of the DL register.

```asm
rol  dl,4           ; 상위 니블 ↔ 하위 니블
```

**6.** Write a single SHLD instruction that shifts the highest bit of the AX register into the lowest bit position of DX and shifts DX one bit to the left.

```asm
shld dx,ax,1
```

**7.** Write a sequence of instructions that shift three memory bytes to the right by 1 bit position. Use the following test data:

```asm
byteArray BYTE 81h,20h,33h
```

첫 번째 바이트를 가장 상위 바이트로 보고, 밀려난 비트를 `RCR`로 다음 바이트에 전달한다.

```asm
shr  byteArray,1            ; 81h → 40h, CF = 1
rcr  [byteArray+1],1        ; 20h → 90h, CF = 0
rcr  [byteArray+2],1        ; 33h → 19h, CF = 1
; 결과: 40h, 90h, 19h
```

**8.** Write a sequence of instructions that shift three memory words to the left by 1 bit position. Use the following test data:

```asm
wordArray WORD 810Dh, 0C064h,93ABh
```

첫 번째 워드를 가장 상위 워드로 보고, 가장 하위 워드(마지막)부터 시프트하며 `RCL`로 올림을 전달한다.

```asm
shl  [wordArray+4],1        ; 93ABh → 2756h, CF = 1
rcl  [wordArray+2],1        ; C064h → 80C9h, CF = 1
rcl  [wordArray],1          ; 810Dh → 021Bh, CF = 1
; 결과: 021Bh, 80C9h, 2756h
```

**9.** Write instructions that multiply 5 by 3 and store the result in a 16-bit variable `val1`.

```asm
.data
val1 WORD ?
.code
mov  al,5
mov  bl,3
mul  bl             ; AX = 000Fh
mov  val1,ax
```

**10.** Write instructions that divide 276 by 10 and store the result in a 16-bit variable `val1`.

```asm
.data
val1 WORD ?
.code
mov  ax,276
mov  bl,10
div  bl             ; AL = 27 (몫), AH = 6 (나머지)
mov  ah,0           ; 나머지 제거
mov  val1,ax        ; val1 = 27
```

**11.** Implement the following C++ expression in assembly language, using 32-bit unsigned operands:

```cpp
val1 = (val2 * val3) / (val4 - 3)
```

```asm
mov  eax,val2
mul  val3           ; EDX:EAX = val2 * val3
mov  ebx,val4
sub  ebx,3          ; EBX = val4 - 3
div  ebx            ; EAX = 몫
mov  val1,eax
```

**12.** Implement the following C++ expression in assembly language, using 32-bit signed operands:

```cpp
val1 = (val2 / val3) * (val1 + val2)
```

```asm
mov  eax,val2
cdq                 ; EAX를 EDX:EAX로 부호 확장
idiv val3           ; EAX = val2 / val3
mov  ebx,val1
add  ebx,val2       ; EBX = val1 + val2
imul eax,ebx        ; EAX = (val2 / val3) * (val1 + val2)
mov  val1,eax
```

**13.** Write a procedure that displays an unsigned 8-bit binary value in decimal format. Pass the binary value in AL. The input range is limited to 0 to 99, decimal. The only procedure you can call from the book's link library is `WriteChar`. The procedure should contain approximately eight instructions.

```asm
mov al,65           ; range limit: 0 to 99
call showDecimal8
```

```asm
showDecimal8 PROC
    push eax
    aam                 ; AH = 십의 자리, AL = 일의 자리
    or   ax,3030h       ; 두 자리 모두 ASCII로 변환
    xchg al,ah          ; AL = 십의 자리
    call WriteChar
    xchg al,ah          ; AL = 일의 자리
    call WriteChar
    pop  eax
    ret
showDecimal8 ENDP
```

> `WriteChar`가 레지스터를 보존한다고 가정한다. 십의 자리가 0이면 `05`처럼 앞에 0이 출력된다.

**14.** Challenge: Suppose AX contains 0072h and the Auxiliary Carry flag is set as a result of adding two unknown ASCII decimal digits. Use the Intel 64 and IA-32 Instruction Set Reference to determine what output the AAA instruction would produce. Explain your answer.

`AAA`는 `(AL & 0Fh) > 9` 이거나 **AF = 1** 이면 다음을 수행한다.

1. `AL = AL + 6`
2. `AH = AH + 1`
3. `AF = CF = 1`
4. `AL = AL & 0Fh`

여기서는 AL의 하위 니블(2)이 9 이하지만 AF가 1이므로 조정이 일어난다.

```
AL = 72h + 6 = 78h  →  78h & 0Fh = 08h
AH = 00h + 1 = 01h

결과: AX = 0108h,  AF = 1,  CF = 1
```

**15.** Challenge: Using only SUB, MOV, and AND instructions, show how to calculate `x = n mod y`, assuming that you are given the values of n and y. You can assume that n is any 32-bit unsigned integer, and y is a power of 2.

y가 2의 거듭제곱이면 `n mod y = n AND (y - 1)` 이다.

```asm
mov  eax,n
mov  ebx,y
sub  ebx,1          ; y - 1 (하위 비트 마스크)
and  eax,ebx        ; n mod y
mov  x,eax
```

**16.** Challenge: Using only SAR, ADD, and XOR instructions (but no conditional jumps), write code that calculates the absolute value of the signed integer in the EAX register.

```asm
mov  edx,eax
sar  edx,31         ; 양수: 00000000h, 음수: FFFFFFFFh
add  eax,edx        ; 음수이면 -1 (1을 빼는 효과)
xor  eax,edx        ; 음수이면 비트 반전 → 절댓값
```

예: `EAX = -5 (FFFFFFFBh)` → `add` → `FFFFFFFAh` → `xor FFFFFFFFh` → `00000005h`
양수이면 `EDX = 0` 이므로 값이 변하지 않는다.

---

## 7.10 Programming Exercises

> 모든 코드는 아래 기본 골격 안에 들어간다고 가정한다. (`.data`, `.code`, `main`은 각 문제 코드에 표시)
> `INVOKE`로 **정의보다 먼저** 프로시저를 호출하는 문제는 `PROTO` 선언을 함께 넣었다.

```asm
INCLUDE Irvine32.inc

; (PROTO 선언)
.data
; ...
.code
main PROC
    ; ...
    exit
main ENDP

; (프로시저들)
END main
```

---

**1.** ★ **Display ASCII Decimal**

Write a procedure named WriteScaled that outputs a decimal ASCII number with an implied decimal point. Suppose the following number were defined as follows, where DECIMAL_OFFSET indicates that the decimal point must be inserted five positions from the right side of the number:

```asm
DECIMAL_OFFSET = 5
.data
decimal_one BYTE "100123456789765"
```

WriteScaled would display the number like this:

```
1001234567.89765
```

When calling WriteScaled, pass the number's offset in EDX, the number length in ECX, and the decimal offset in EBX. Write a test program that passes three numbers of different sizes to the WriteScaled procedure.

> 답: 오른쪽에서 EBX번째 위치 앞에 소수점을 출력한다. ECX는 문자열 길이이며, EDX는 문자열의 시작 주소이다.

```asm
.data
decimal_one   BYTE "100123456789765"
decimal_two   BYTE "12345"
decimal_three BYTE "9876"

.code
main PROC
    mov edx,OFFSET decimal_one
    mov ecx,LENGTHOF decimal_one
    mov ebx,5
    call WriteScaled                ; 1001234567.89765
    call Crlf

    mov edx,OFFSET decimal_two
    mov ecx,LENGTHOF decimal_two
    mov ebx,2
    call WriteScaled                ; 123.45
    call Crlf

    mov edx,OFFSET decimal_three
    mov ecx,LENGTHOF decimal_three
    mov ebx,1
    call WriteScaled                ; 987.6
    call Crlf
    exit
main ENDP

WriteScaled PROC USES esi edi ebp
    mov esi,edx             ; 문자열 주소
    mov edi,ecx             ; 남은 문자 수
    mov ebp,ebx             ; 소수점 위치
L1:
    cmp edi,ebp
    jne L2
    mov al,'.'
    call WriteChar
L2:
    mov al,[esi]
    call WriteChar
    inc esi
    dec edi
    jnz L1
    ret
WriteScaled ENDP
```

---

**2.** ★★ **Extended Subtraction Procedure**

Create a procedure named Extended_Sub that subtracts two binary integers of arbitrary size. The storage size of the two integers must be the same, and their size must be a multiple of 32 bits. Write a test program that passes several pairs of integers, each at least 10 bytes long.

> 답: 낮은 주소의 DWORD부터 SBB로 빼면 CF를 통해 이전 DWORD에서 발생한 빌림값이 다음 DWORD 계산으로 전달된다. ESI는 첫 번째 수, EDI는 두 번째 수, EDX는 결과 주소, ECX는 DWORD 개수로 사용한다.

```asm
.data
num1    BYTE 01h,02h,03h,04h,05h,06h,07h,08h,09h,0Ah,0Bh,0Ch
num2    BYTE 01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h,01h
result1 BYTE 12 DUP(?)          ; 결과: 00,01,02,03,04,05,06,07,08,09,0A,0B
num3    BYTE 10h,20h,30h,40h,50h,60h,70h,80h,90h,0A0h,0B0h,0C0h
num4    BYTE 01h,02h,03h,04h,05h,06h,07h,08h,09h,0Ah,0Bh,0Ch
result2 BYTE 12 DUP(?)          ; DWORD 결과: 3C2D1E0Fh, 78695A4Bh, B4A59687h

.code
main PROC
    mov esi,OFFSET num1
    mov edi,OFFSET num2
    mov edx,OFFSET result1
    mov ecx,3               ; 12바이트 = DWORD 3개
    call Extended_Sub

    mov esi,OFFSET num3
    mov edi,OFFSET num4
    mov edx,OFFSET result2
    mov ecx,3
    call Extended_Sub
    exit
main ENDP

Extended_Sub PROC
    clc
L1:
    mov eax,[esi]
    sbb eax,[edi]
    mov [edx],eax
    lea esi,[esi+4]         ; LEA, LOOP는 CF를 변경하지 않음
    lea edi,[edi+4]
    lea edx,[edx+4]
    loop L1
    ret
Extended_Sub ENDP
```

---

**3.** ★★ **Packed Decimal Conversion**

Write a procedure named PackedToAsc that converts a 4-byte packed decimal integer to a string of ASCII decimal digits. Pass the packed integer and the address of a buffer holding the ASCII digits to the procedure. Write a short test program that passes at least 5 packed decimal integers to your procedure.

> 답: 4바이트 packed decimal은 8자리 십진수이다(예: `12345678h` → `"12345678"`). EAX를 `ROL EAX,4`로 한 니블씩 돌려 가장 높은 자릿수부터 하위 4비트를 꺼내고, `30h`를 OR해 ASCII로 변환한 뒤 버퍼에 저장한다. 8번 반복하면 EAX는 원래 값으로 돌아오며, 마지막에 널 문자를 붙인다.

```asm
PackedToAsc PROTO,
    packedVal:DWORD,
    bufferPtr:PTR BYTE

.data
packedArray DWORD 12345678h, 00000042h, 99999999h, 10203040h, 00000000h
buffer      BYTE 9 DUP(?)               ; 8자리 + 널 문자

.code
main PROC
    mov esi,OFFSET packedArray
    mov ecx,LENGTHOF packedArray
L1:
    INVOKE PackedToAsc, DWORD PTR [esi], ADDR buffer
    mov edx,OFFSET buffer
    call WriteString                    ; 12345678, 00000042, 99999999, ...
    call Crlf
    add esi,TYPE packedArray
    loop L1
    exit
main ENDP

PackedToAsc PROC USES eax ebx ecx edx,
    packedVal:DWORD,
    bufferPtr:PTR BYTE

    mov eax,packedVal
    mov edx,bufferPtr
    mov ecx,8                   ; 8자리
L1:
    rol eax,4                   ; 가장 높은 니블이 AL 하위 4비트로 이동
    mov bl,al
    and bl,0Fh                  ; 한 자리 추출
    or  bl,30h                  ; ASCII 변환
    mov [edx],bl
    inc edx
    loop L1
    mov BYTE PTR [edx],0        ; 널 종료 문자
    ret
PackedToAsc ENDP
```

---

**4.** ★★ **Encryption Using Rotate Operations**

Write a procedure that performs simple encryption by rotating each plaintext byte a varying number of positions in different directions. For example, in the following array that represents the encryption key, a negative value indicates a rotation to the left and a positive value indicates a rotation to the right. The integer in each position indicates the magnitude of the rotation:

```asm
key BYTE -2, 4, 1, 0, -3, 5, 2, -4, -4, 6
```

Your procedure should loop through a plaintext message and align the key to the first 10 bytes of the message. Rotate each plaintext byte by the amount indicated by its matching key array value. Then, align the key to the next 10 bytes of the message and repeat the process. Write a program that tests your encryption procedure by calling it twice, with different data sets.

> 답: 메시지의 i번째 바이트는 `key[i mod 10]`만큼 회전한다. 키 값이 음수이면 `NEG`로 크기를 구해 `ROL`, 양수(0 포함)이면 `ROR`을 사용한다. 회전 횟수는 CL에 넣는다. 복호화는 `ROL`과 `ROR`을 서로 바꾸면 된다.

```asm
Encrypt PROTO,
    ptrMsg:PTR BYTE,
    msgLen:DWORD

KEYSIZE = 10

.data
key  BYTE -2, 4, 1, 0, -3, 5, 2, -4, -4, 6
msg1 BYTE "Assembly is fun!"
msg1Len = ($ - msg1)
msg2 BYTE "Rotate every byte using the key"
msg2Len = ($ - msg2)

.code
main PROC
    ; 첫 번째 데이터
    INVOKE Encrypt, ADDR msg1, msg1Len
    mov esi,OFFSET msg1
    mov ecx,msg1Len
    mov ebx,TYPE msg1
    call DumpMem                ; 암호화된 바이트를 16진수로 출력
    call Crlf

    ; 두 번째 데이터
    INVOKE Encrypt, ADDR msg2, msg2Len
    mov esi,OFFSET msg2
    mov ecx,msg2Len
    mov ebx,TYPE msg2
    call DumpMem
    exit
main ENDP

Encrypt PROC USES ecx edx esi edi,
    ptrMsg:PTR BYTE,
    msgLen:DWORD

    mov esi,ptrMsg
    mov edx,msgLen              ; 남은 바이트 수
    mov edi,0                   ; 키 인덱스
L1:
    mov cl,key[edi]             ; 회전 크기와 방향
    cmp cl,0
    jl  rotLeft
    ror BYTE PTR [esi],cl       ; 양수/0: 오른쪽 회전
    jmp nextByte
rotLeft:
    neg cl                      ; 음수: 크기를 구해 왼쪽 회전
    rol BYTE PTR [esi],cl
nextByte:
    inc esi
    inc edi
    cmp edi,KEYSIZE
    jb  keyOK
    mov edi,0                   ; 키를 다음 10바이트에 다시 정렬
keyOK:
    dec edx
    jnz L1
    ret
Encrypt ENDP
```

---

**5.** ★★★ **Prime Numbers**

Write a program that generates all prime numbers between 2 and 1000, using the Sieve of Eratosthenes method. You can find many articles that describe the method for finding primes in this manner on the Internet. Display all the prime values.

> 답: 0~1000 크기의 바이트 배열을 모두 1(소수 후보)로 초기화한다. i = 2부터 `i × i ≤ 1000`인 동안, `sieve[i]`가 1이면 `i × i`부터 i씩 증가하며 배수를 0(합성수)으로 지운다. 끝난 뒤 값이 1로 남은 인덱스가 소수이다.

```asm
LIMIT = 1000

.data
sieve BYTE LIMIT+1 DUP(1)       ; 1 = 소수 후보, 0 = 합성수

.code
main PROC
    ; ---- 1단계: 체 거르기 ----
    mov  ebx,2                  ; i = 2
outer:
    mov  eax,ebx
    mul  ebx                    ; EAX = i * i
    cmp  eax,LIMIT
    ja   display                ; i*i > 1000 이면 종료
    cmp  sieve[ebx],0
    je   nextI                  ; 이미 합성수이면 건너뜀
    mov  ecx,eax                ; j = i * i
inner:
    mov  sieve[ecx],0           ; i의 배수 제거
    add  ecx,ebx                ; j += i
    cmp  ecx,LIMIT
    jbe  inner
nextI:
    inc  ebx
    jmp  outer

    ; ---- 2단계: 소수 출력 (한 줄에 10개) ----
display:
    mov  ebx,2
    mov  edi,0                  ; 현재 줄에 출력한 개수
show:
    cmp  sieve[ebx],0
    je   skip
    mov  eax,ebx
    call WriteDec
    mov  al,' '
    call WriteChar
    inc  edi
    cmp  edi,10
    jb   skip
    call Crlf
    mov  edi,0
skip:
    inc  ebx
    cmp  ebx,LIMIT
    jbe  show
    call Crlf
    exit
main ENDP
```

---

**6.** ★★★ **Greatest Common Divisor (GCD)**

The greatest common divisor (GCD) of two integers is the largest integer that will evenly divide both integers. The GCD algorithm involves integer division in a loop, described by the following pseudocode:

```c
int GCD(int x, int y)
{
    x = abs(x)      // absolute value
    y = abs(y)
    do {
        int n = x % y
        x = y
        y = n
    } while (y > 0)
    return x
}
```

Implement this function in assembly language and write a test program that calls the function several times, passing it different values. Display all results on the screen.

> 답: 절댓값은 `CDQ`로 부호(0 또는 -1)를 구한 뒤 `XOR`과 `SUB`로 계산한다. `DIV`로 나머지를 구해(`EDX`) `x = y`, `y = n`으로 갱신하고, `y`가 0이 되면 `x`(EAX)가 GCD이다. 입력 y가 0일 때 0으로 나누는 오류를 막기 위해 루프 앞에서 y = 0을 검사한다.

```asm
GCD PROTO,
    x:SDWORD,
    y:SDWORD

.data
msgGCD BYTE "GCD = ",0

.code
main PROC
    INVOKE GCD, 48, 18          ; 6
    call ShowGCD
    INVOKE GCD, -24, 36         ; 12
    call ShowGCD
    INVOKE GCD, 17, 5           ; 1
    call ShowGCD
    INVOKE GCD, 1071, -462      ; 21
    call ShowGCD
    INVOKE GCD, 100, 75         ; 25
    call ShowGCD
    exit
main ENDP

ShowGCD PROC USES edx
    mov  edx,OFFSET msgGCD
    call WriteString
    call WriteDec               ; EAX = GCD
    call Crlf
    ret
ShowGCD ENDP

GCD PROC USES ebx edx,
    x:SDWORD,
    y:SDWORD

    mov  eax,x                  ; x = abs(x)
    cdq
    xor  eax,edx
    sub  eax,edx

    mov  ebx,y                  ; y = abs(y)
    mov  edx,ebx
    sar  edx,31
    xor  ebx,edx
    sub  ebx,edx
L1:
    cmp  ebx,0                  ; y = 0 이면 x가 GCD
    je   done
    xor  edx,edx
    div  ebx                    ; EDX = x % y
    mov  eax,ebx                ; x = y
    mov  ebx,edx                ; y = n
    jmp  L1
done:
    ret                         ; EAX = GCD
GCD ENDP
```

---

**7.** ★★★ **Bitwise Multiplication**

Write a procedure named BitwiseMultiply that multiplies any unsigned 32-bit integer by EAX, using only shifting and addition. Pass the integer to the procedure in the EBX register, and return the product in the EAX register. Write a short test program that calls the procedure and displays the product. (We will assume that the product is never larger than 32 bits.) This is a fairly challenging program to write. One possible approach is to use a loop to shift the multiplier to the right, keeping track of the number of shifts that occur before the Carry flag is set. The resulting shift count can then be applied to the SHL instruction, using the multiplicand as the destination operand. Then, the same process must be repeated until you find the last 1 bit in the multiplier.

> 답: 곱셈을 "시프트 + 덧셈"으로 구현한다. 승수(EBX)를 `SHR`로 한 비트씩 밀어 CF를 확인하고, 그 비트가 1이면 현재 피승수(EAX)를 누적 합에 더한다. 매 반복마다 피승수는 `SHL`로 2배씩 키운다. 승수가 0이 되면 종료하므로 최대 32번 반복한다.

```asm
.code
main PROC
    mov  eax,123
    mov  ebx,456
    call BitwiseMultiply
    call WriteDec               ; 56088
    call Crlf

    mov  eax,5
    mov  ebx,7
    call BitwiseMultiply
    call WriteDec               ; 35
    call Crlf

    mov  eax,1000
    mov  ebx,1000
    call BitwiseMultiply
    call WriteDec               ; 1000000
    call Crlf
    exit
main ENDP

BitwiseMultiply PROC USES ebx edx
    mov  edx,0                  ; 곱(누적 합)
L1:
    shr  ebx,1                  ; 승수의 최하위 비트 → CF
    jnc  skipAdd                ; 0이면 더하지 않음
    add  edx,eax                ; 1이면 현재 피승수를 더함
skipAdd:
    shl  eax,1                  ; 피승수 × 2
    cmp  ebx,0
    jne  L1                     ; 남은 승수 비트가 있으면 반복
    mov  eax,edx                ; 결과를 EAX에 반환
    ret
BitwiseMultiply ENDP
```

예: `5 × 7` 추적

| 반복 | EBX(승수) | CF | EAX(피승수) | EDX(누적) |
|---|---|---|---|---|
| 1 | 7 → 3 | 1 | 5 | 5 |
| 2 | 3 → 1 | 1 | 10 | 15 |
| 3 | 1 → 0 | 1 | 20 | 35 |

---

**8.** ★★★ **Add Packed Integers**

Extend the AddPacked procedure from Section 7.6.1 so that it adds two packed decimal integers of arbitrary size (both lengths must be the same). Write a test program that passes AddPacked several pairs of integers: 4-byte, 8-byte, and 16-byte. We suggest that you use the following registers to pass information to the procedure:

```
ESI - pointer to the first number
EDI - pointer to the second number
EDX - pointer to the sum
ECX - number of bytes to add
```

> 답: 리틀 엔디언이므로 가장 낮은 주소의 바이트(하위 두 자리)부터 `ADC`로 더하고 `DAA`로 십진 보정한다. `INC`, `MOV`, `LOOP`는 CF를 바꾸지 않으므로 올림이 다음 바이트로 전달된다. 마지막 올림은 합계 버퍼의 추가 1바이트에 저장하므로, 합계 버퍼는 **피연산자보다 1바이트 커야 한다.**

```asm
.data
; 4바이트: 12345678 + 87654321
a4     BYTE 78h,56h,34h,12h
b4     BYTE 21h,43h,65h,87h
sum4   BYTE 5 DUP(0)            ; 결과: 0 | 99999999

; 8바이트: 9999999999999999 + 1
a8     BYTE 8 DUP(99h)
b8     BYTE 01h,7 DUP(00h)
sum8   BYTE 9 DUP(0)            ; 결과: 1 | 0000000000000000

; 16바이트
a16    BYTE 16 DUP(55h)
b16    BYTE 16 DUP(45h)
sum16  BYTE 17 DUP(0)

.code
main PROC
    ; 4-byte
    mov  esi,OFFSET a4
    mov  edi,OFFSET b4
    mov  edx,OFFSET sum4
    mov  ecx,LENGTHOF a4
    call AddPacked
    call ShowPacked

    ; 8-byte
    mov  esi,OFFSET a8
    mov  edi,OFFSET b8
    mov  edx,OFFSET sum8
    mov  ecx,LENGTHOF a8
    call AddPacked
    call ShowPacked

    ; 16-byte
    mov  esi,OFFSET a16
    mov  edi,OFFSET b16
    mov  edx,OFFSET sum16
    mov  ecx,LENGTHOF a16
    call AddPacked
    call ShowPacked
    exit
main ENDP

;---------------------------------------------------------
; AddPacked
; Receives: ESI = 첫 번째 수, EDI = 두 번째 수,
;           EDX = 합계(길이 + 1 바이트), ECX = 바이트 수
;---------------------------------------------------------
AddPacked PROC USES ecx esi edi edx
    clc
L1:
    mov  al,[esi]
    adc  al,[edi]               ; 이전 바이트의 올림 포함
    daa                         ; 패킹된 십진수로 보정
    mov  [edx],al
    inc  esi                    ; INC는 CF를 바꾸지 않음
    inc  edi
    inc  edx
    loop L1
    mov  BYTE PTR [edx],0
    adc  BYTE PTR [edx],0       ; 마지막 올림(CF)을 추가 바이트에 저장
    ret
AddPacked ENDP

;---------------------------------------------------------
; ShowPacked
; Receives: EDX = 합계 주소, ECX = 피연산자 바이트 수
; 가장 높은 주소(올림 바이트)부터 16진수로 출력 = 십진수 출력
;---------------------------------------------------------
ShowPacked PROC USES eax ebx ecx
    mov  ebx,1                  ; WriteHexB: 1바이트 출력
L1:
    movzx eax,BYTE PTR [edx+ecx]
    call WriteHexB
    dec  ecx
    jns  L1                     ; ECX가 0까지 출력한 뒤 종료
    call Crlf
    ret
ShowPacked ENDP
```

> `AddPacked`가 `USES`로 ECX, ESI, EDI, EDX를 보존하므로, 호출 직후 `ShowPacked`에 같은 ECX, EDX를 그대로 사용할 수 있다.
