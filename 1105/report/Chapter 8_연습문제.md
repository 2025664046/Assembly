# 8.10 Review Questions and Exercises

## 8.10.1 Short Answer

**1.** Which statements belong in a procedure’s epilogue when the procedure has stack parameters and local variables?

> 답: 저장한 레지스터를 pop으로 복원하고, mov esp,ebp로 지역 변수 공간을 해제한 뒤, pop ebp로 EBP를 복원하고, ret n으로 반환하면서 매개변수를 정리한다. mov esp,ebp와 pop ebp는 LEAVE 한 줄로 대체할 수 있다.

**2.** When a C function returns a 32-bit integer, where is the return value stored?

> 답: EAX 레지스터에 저장된다.

**3.** How does a program using the STDCALL calling convention clean up the stack after a procedure call?

> 답: 호출된 프로시저가 ret n 명령어로 정리한다. n은 매개변수가 차지한 바이트 수이며, RET이 반환한 뒤 ESP에 n을 더해 매개변수를 스택에서 제거한다.

**4.** How is the LEA instruction more powerful than the OFFSET operator?

> 답: OFFSET은 어셈블 시점에 주소가 결정되므로 .data의 전역 변수에만 쓸 수 있다. 반면 LEA는 실행 시점에 간접 피연산자(`[ebp-30]`, `[esi+ecx*4]` 등)의 주소를 계산하므로, 스택에 만들어지는 지역 변수의 주소도 얻을 수 있다.

```asm
lea esi,[ebp-30]        ; 스택 위 지역 배열의 주소 (OFFSET으로는 불가능)
```

**5.** In the C++ example shown in Section 8.2.3, how much stack space is used by a variable of type int?

> 답: 4바이트이다. 32비트 모드에서 int는 doubleword(32비트)이므로 인수 하나가 스택에서 4바이트를 차지한다.

**6.** What advantages might the C calling convention have over the STDCALL calling convention?

> 답: C 규약은 호출한 쪽이 스택을 정리하므로 호출된 프로시저는 인수가 몇 개 push되었는지 알 필요가 없다. 따라서 인수 개수가 가변인 함수(printf 등)를 만들 수 있다. STDCALL은 `ret n`의 n이 프로시저마다 고정되어야 해서 이것이 불가능하다.

**7.** (True/False): When using the PROC directive, all parameters must be listed on the same line.

> 답: False. 매개변수는 쉼표로 구분하기만 하면 되고, 한 줄에 모두 쓰거나 여러 줄에 나누어 쓸 수 있다.

**8.** (True/False): If you pass a variable containing the offset of an array of bytes to a procedure that expects a pointer to an array of words, the assembler will flag this as an error.

> 답: False. 어셈블러에게 OFFSET 값은 그냥 32비트 값일 뿐이라 포인터가 가리키는 대상의 타입 불일치를 오류로 잡지 않는다. 실행 중에 잘못된 크기로 접근하는 버그가 되기 쉽다.

**9.** (True/False): If you pass an immediate value to a procedure that expects a reference parameter, you can generate a general-protection fault.

> 답: True. 예를 들어 `INVOKE Sub2, 1000h`처럼 즉시값을 넘기면 프로시저가 그 값을 주소로 보고 역참조하므로 접근 권한이 없는 메모리를 읽거나 써서 general-protection fault(런타임 오류)가 발생할 수 있다.

---

## 8.10.2 Algorithm Workbench

**1.** Here is a calling sequence for a procedure named AddThree that adds three doublewords (assume that the STDCALL calling convention is used):

```asm
push 10h
push 20h
push 30h
call AddThree
```

Draw a picture of the procedure’s stack frame immediately after EBP has been pushed on the runtime stack.

> 답: 인수는 역순으로 push되므로 마지막에 push한 30h가 가장 낮은 주소에 있다. 아래 오프셋은 mov ebp,esp 이후의 EBP 기준이다.

```
높은 주소
+--------------------+
| 10h                |  [EBP + 16]
+--------------------+
| 20h                |  [EBP + 12]
+--------------------+
| 30h                |  [EBP + 8]
+--------------------+
| 반환 주소           |  [EBP + 4]
+--------------------+
| 저장된 EBP          |  [EBP]  <- ESP
+--------------------+
낮은 주소
```

**2.** Create a procedure named AddThree that receives three integer parameters and calculates and returns their sum in the EAX register.

> 답: PROC의 매개변수 목록을 사용한다. STDCALL이므로 MASM이 ret 12를 생성한다.

```asm
AddThree PROC,
    val1:DWORD,
    val2:DWORD,
    val3:DWORD
    mov eax,val1
    add eax,val2
    add eax,val3
    ret
AddThree ENDP
```

**3.** Declare a local variable named pArray that is a pointer to an array of doublewords.

> 답: LOCAL은 PROC 바로 다음 줄에 와야 한다.

```asm
LOCAL pArray:PTR DWORD
```

**4.** Declare a local variable named buffer that is an array of 20 bytes.

> 답:

```asm
LOCAL buffer[20]:BYTE
```

**5.** Declare a local variable named pwArray that points to a 16-bit unsigned integer.

> 답: 16비트 부호 없는 정수는 WORD이므로 WORD를 가리키는 포인터로 선언한다.

```asm
LOCAL pwArray:PTR WORD
```

**6.** Declare a local variable named myByte that holds an 8-bit signed integer.

> 답: 8비트 부호 있는 정수 타입은 SBYTE이다.

```asm
LOCAL myByte:SBYTE
```

**7.** Declare a local variable named myArray that is an array of 20 doublewords.

> 답:

```asm
LOCAL myArray[20]:DWORD
```

**8.** Create a procedure named SetColor that receives two stack parameters: forecolor and backcolor, and calls the SetTextColor procedure from the Irvine32 library.

> 답: SetTextColor는 EAX의 하위 4비트를 전경색, 상위 4비트(비트 4~7)를 배경색으로 사용한다. 배경색을 4비트 왼쪽으로 민 뒤 전경색과 OR한다. EAX는 USES로 보존한다.

```asm
SetColor PROC USES eax,
    forecolor:DWORD,
    backcolor:DWORD
    mov eax,backcolor
    shl eax,4               ; 배경색은 상위 4비트
    or  eax,forecolor       ; 전경색은 하위 4비트
    call SetTextColor
    ret
SetColor ENDP
```

**9.** Create a procedure named WriteColorChar that receives three stack parameters: char, forecolor, and backcolor. It displays a single character, using the color attributes specified in forecolor and backcolor.

> 답: 8번의 SetColor로 색을 지정한 뒤 WriteChar로 문자를 출력한다. SetColor가 먼저 정의(또는 PROTO 선언)되어 있어야 INVOKE로 호출할 수 있다.

```asm
WriteColorChar PROC USES eax,
    char:BYTE,
    forecolor:DWORD,
    backcolor:DWORD
    INVOKE SetColor, forecolor, backcolor
    mov al,char
    call WriteChar
    ret
WriteColorChar ENDP
```

**10.** Write a procedure named DumpMemory that encapsulates the DumpMem procedure in the Irvine32 library. Use declared parameters and the USES directive. The following is an example of how it should be called: `INVOKE DumpMemory, OFFSET array, LENGTHOF array, TYPE array`.

> 답: DumpMem은 ESI = 시작 주소, ECX = 단위 개수, EBX = 단위 크기를 입력으로 받는다. 매개변수를 이 레지스터들에 옮겨 담아 호출하고, 사용한 레지스터는 USES로 보존한다.

```asm
DumpMemory PROC USES ebx ecx esi,
    ptrMem:PTR BYTE,
    units:DWORD,
    unitSize:DWORD
    mov esi,ptrMem
    mov ecx,units
    mov ebx,unitSize
    call DumpMem
    ret
DumpMemory ENDP
```

**11.** Declare a procedure named MultArray that receives two pointers to arrays of doublewords, and a third parameter indicating the number of array elements. Also, create a PROTO declaration for this procedure.

> 답: PROTO와 PROC의 매개변수 목록은 같아야 한다.

```asm
MultArray PROTO,
    ptrArray1:PTR DWORD,
    ptrArray2:PTR DWORD,
    count:DWORD

MultArray PROC,
    ptrArray1:PTR DWORD,
    ptrArray2:PTR DWORD,
    count:DWORD
    . . .
MultArray ENDP
```

---

# 8.11 Programming Exercises

**1.** ★ **FindLargest Procedure**

Create a procedure named FindLargest that receives two parameters: a pointer to a signed doubleword array, and a count of the array’s length. The procedure must return the value of the largest array member in EAX. Use the PROC directive with a parameter list when declaring the procedure. Preserve all registers (except EAX) that are modified by the procedure. Write a test program that calls FindLargest and passes three different arrays of different lengths. Be sure to include negative values in your arrays. Create a PROTO declaration for FindLargest.

> 답: 첫 원소를 최댓값으로 두고 부호 있는 비교(JGE)로 갱신한다. 출력 결과는 -1, +45, -2이다. (WriteInt는 양수에도 `+` 부호를 붙여 출력한다.)

```asm
INCLUDE Irvine32.inc

FindLargest PROTO,
    ptrArray:PTR SDWORD,
    szArray:DWORD

.data
array1 SDWORD -5,-20,-1,-9
array2 SDWORD 10,-3,45,0,22,-100
array3 SDWORD -7,-8,-2

.code
main PROC
    INVOKE FindLargest, ADDR array1, LENGTHOF array1
    call WriteInt
    call Crlf
    INVOKE FindLargest, ADDR array2, LENGTHOF array2
    call WriteInt
    call Crlf
    INVOKE FindLargest, ADDR array3, LENGTHOF array3
    call WriteInt
    call Crlf
    exit
main ENDP

FindLargest PROC USES ecx esi,
    ptrArray:PTR SDWORD,
    szArray:DWORD
    mov esi,ptrArray
    mov ecx,szArray
    mov eax,[esi]           ; 첫 원소를 최댓값으로 가정
L1:
    cmp eax,[esi]
    jge L2                  ; 부호 있는 비교
    mov eax,[esi]
L2:
    add esi,4
    loop L1
    ret
FindLargest ENDP
END main
```

**2.** ★ **Chess Board**

Write a program that draws an 8 × 8 chess board, with alternating gray and white squares. You can use the SetTextColor and Gotoxy procedures from the Irvine32 library. Avoid the use of global variables, and use declared parameters in all procedures. Use short procedures that are focused on a single task.

> 답: DrawSquare(한 칸), DrawRow(한 줄), DrawBoard(전체)로 나누어 모두 매개변수만 사용한다. 한 칸은 공백 문자를 배경색으로 칠하여 가로 4, 세로 2로 그린다.

```asm
INCLUDE Irvine32.inc

SQ_W = 4                    ; 한 칸의 가로 길이
SQ_H = 2                    ; 한 칸의 세로 길이
BOARD_SIZE = 8

DrawSquare PROTO, x:DWORD, y:DWORD, color:DWORD
DrawRow    PROTO, y:DWORD, colorA:DWORD, colorB:DWORD
DrawBoard  PROTO, colorA:DWORD, colorB:DWORD

.code
main PROC
    INVOKE DrawBoard, gray, white
    mov dl,0
    mov dh,BOARD_SIZE * SQ_H
    call Gotoxy             ; 커서를 보드 아래로 이동
    mov eax,lightGray
    call SetTextColor       ; 기본 색 복원
    exit
main ENDP

; 한 칸을 그린다
DrawSquare PROC USES eax ebx ecx edx,
    x:DWORD,
    y:DWORD,
    color:DWORD
    mov eax,color
    shl eax,4               ; 배경색 설정
    call SetTextColor
    mov ebx,0               ; 줄 번호
L1:
    mov dl,BYTE PTR x
    mov dh,BYTE PTR y
    add dh,bl
    call Gotoxy
    mov ecx,SQ_W
L2:
    mov al,' '
    call WriteChar
    loop L2
    inc ebx
    cmp ebx,SQ_H
    jb L1
    ret
DrawSquare ENDP

; 한 줄(8칸)을 그린다
DrawRow PROC USES eax ebx ecx,
    y:DWORD,
    colorA:DWORD,
    colorB:DWORD
    mov ebx,0               ; 열 번호
L1:
    mov eax,colorA
    test ebx,1
    jz L2
    mov eax,colorB          ; 홀수 열은 다른 색
L2:
    imul ecx,ebx,SQ_W       ; x 좌표
    INVOKE DrawSquare, ecx, y, eax
    inc ebx
    cmp ebx,BOARD_SIZE
    jb L1
    ret
DrawRow ENDP

; 보드 전체(8줄)를 그린다
DrawBoard PROC USES ebx ecx,
    colorA:DWORD,
    colorB:DWORD
    mov ebx,0               ; 행 번호
L1:
    imul ecx,ebx,SQ_H       ; y 좌표
    test ebx,1
    jnz L2
    INVOKE DrawRow, ecx, colorA, colorB
    jmp L3
L2:
    INVOKE DrawRow, ecx, colorB, colorA   ; 홀수 행은 색 순서를 바꿈
L3:
    inc ebx
    cmp ebx,BOARD_SIZE
    jb L1
    ret
DrawBoard ENDP
END main
```

**3.** ★★★ **Chess Board with Alternating Colors**

This exercise extends Exercise 2. Every 500 milliseconds, change the color of the colored squares and redisplay the board. Continue until you have shown the board 16 times, using all possible 4-bit background colors. (The white squares remain white throughout.)

> 답: 2번의 프로시저를 그대로 사용하고 main만 바꾼다. 색 번호 0~15를 DrawBoard의 첫 번째 색으로 넘기고 두 번째 색은 white로 고정한다. 매번 Delay로 500ms 대기한다.

```asm
; DrawSquare, DrawRow, DrawBoard, 상수와 PROTO는 2번과 동일
main PROC
    mov ebx,0               ; 배경색 0~15
L1:
    INVOKE DrawBoard, ebx, white
    mov eax,500
    call Delay
    inc ebx
    cmp ebx,16
    jb L1
    mov dl,0
    mov dh,BOARD_SIZE * SQ_H
    call Gotoxy
    mov eax,lightGray
    call SetTextColor
    exit
main ENDP
```

**4.** ★★ **FindThrees Procedure**

Create a procedure named FindThrees that returns 1 if an array has three consecutive values of 3 somewhere in the array. Otherwise, return 0. The procedure’s input parameter list contains a pointer to the array and the array’s size. Use the PROC directive with a parameter list when declaring the procedure. Preserve all registers (except EAX) that are modified by the procedure. Write a test program that calls FindThrees several times with different arrays.

> 답: 배열을 앞에서부터 훑으면서 3이 연속으로 나온 횟수를 EBX에 센다. 3이 아닌 값이 나오면 0으로 리셋하고, 횟수가 3이 되면 바로 1을 반환한다. 원소가 3개 미만이면 `loop`가 ECX=0에서 거의 무한 반복되는 것을 막기 위해 먼저 0을 반환한다.

```asm
INCLUDE Irvine32.inc

FindThrees PROTO,
    pArray:PTR DWORD,
    arraySize:DWORD

.data
arr1 DWORD 1,3,3,3,5            ; 1
arr2 DWORD 3,3,1,3,3            ; 0 (연속이 아님)
arr3 DWORD 3,3,3                ; 1
arr4 DWORD 3,3                  ; 0 (길이 부족)
arr5 DWORD 1,2,3,3,4,3,3,3      ; 1

.code
main PROC
    INVOKE FindThrees, ADDR arr1, LENGTHOF arr1
    call WriteDec
    call Crlf
    INVOKE FindThrees, ADDR arr2, LENGTHOF arr2
    call WriteDec
    call Crlf
    INVOKE FindThrees, ADDR arr3, LENGTHOF arr3
    call WriteDec
    call Crlf
    INVOKE FindThrees, ADDR arr4, LENGTHOF arr4
    call WriteDec
    call Crlf
    INVOKE FindThrees, ADDR arr5, LENGTHOF arr5
    call WriteDec
    call Crlf
    exit
main ENDP

FindThrees PROC USES ebx ecx esi,
    pArray:PTR DWORD,
    arraySize:DWORD
    mov esi,pArray
    mov ecx,arraySize
    mov ebx,0                   ; 연속된 3의 개수
    mov eax,0                   ; 기본 반환값 0
    cmp ecx,3
    jb done                     ; 3개 미만이면 불가능
L1:
    cmp DWORD PTR [esi],3
    jne reset
    inc ebx
    cmp ebx,3
    je found                    ; 3이 3번 연속
    jmp next
reset:
    mov ebx,0
next:
    add esi,4
    loop L1
    jmp done
found:
    mov eax,1
done:
    ret
FindThrees ENDP
END main
```

**5.** ★★ **DifferentInputs Procedure**

Write a procedure named DifferentInputs that returns EAX = 1 if the values of its three input parameters are all different; otherwise, return with EAX = 0. Use the PROC directive with a parameter list when declaring the procedure. Create a PROTO declaration for your procedure, and call it five times from a test program that passes different inputs.

> 답: 세 쌍(1-2, 1-3, 2-3)을 모두 비교해서 하나라도 같으면 0, 모두 다르면 1을 반환한다. 출력 결과는 1, 0, 0, 0, 1이다.

```asm
INCLUDE Irvine32.inc

DifferentInputs PROTO,
    val1:DWORD,
    val2:DWORD,
    val3:DWORD

.code
main PROC
    INVOKE DifferentInputs, 1, 2, 3     ; 1
    call WriteDec
    call Crlf
    INVOKE DifferentInputs, 5, 5, 7     ; 0
    call WriteDec
    call Crlf
    INVOKE DifferentInputs, 4, 9, 4     ; 0
    call WriteDec
    call Crlf
    INVOKE DifferentInputs, 6, 7, 7     ; 0
    call WriteDec
    call Crlf
    INVOKE DifferentInputs, -1, 0, 1    ; 1
    call WriteDec
    call Crlf
    exit
main ENDP

DifferentInputs PROC USES ebx,
    val1:DWORD,
    val2:DWORD,
    val3:DWORD
    mov ebx,val1
    cmp ebx,val2
    je notDifferent             ; val1 == val2
    cmp ebx,val3
    je notDifferent             ; val1 == val3
    mov ebx,val2
    cmp ebx,val3
    je notDifferent             ; val2 == val3
    mov eax,1                   ; 모두 다름
    jmp done
notDifferent:
    mov eax,0
done:
    ret
DifferentInputs ENDP
END main
```

**6.** ★★ **Exchanging Integers**

Create an array of randomly ordered integers. Using the Swap procedure from Section 8.4.6 as a tool, write a loop that exchanges each consecutive pair of integers in the array.

> 답: 반복 횟수는 `LENGTHOF array / 2`(쌍의 개수)이다. 매 반복마다 ESI가 가리키는 원소와 그 다음 원소(`[esi+4]`)의 주소를 Swap에 넘기고, ESI를 8바이트씩 이동한다. `ADDR`은 상수 주소에만 쓸 수 있어서 레지스터에 담긴 주소는 그냥 레지스터로 넘긴다. 결과는 `5,12,3,9,1,8,20,7` → `12,5,9,3,8,1,7,20`이다.

```asm
INCLUDE Irvine32.inc

Swap PROTO, pValX:PTR DWORD, pValY:PTR DWORD

.data
array DWORD 5,12,3,9,1,8,20,7

.code
main PROC
    ; 교환 전 출력
    mov esi,OFFSET array
    mov ecx,LENGTHOF array
    mov ebx,TYPE array
    call DumpMem

    ; 인접한 두 원소씩 교환
    mov esi,OFFSET array
    mov ecx,LENGTHOF array
    shr ecx,1                   ; 쌍의 개수 (홀수 길이면 마지막 원소는 그대로)
L1:
    lea edx,[esi+4]             ; 두 번째 원소의 주소
    INVOKE Swap, esi, edx
    add esi,8                   ; 다음 쌍으로
    loop L1

    ; 교환 후 출력
    mov esi,OFFSET array
    mov ecx,LENGTHOF array
    mov ebx,TYPE array
    call DumpMem
    exit
main ENDP

Swap PROC USES eax esi edi,
    pValX:PTR DWORD,
    pValY:PTR DWORD
    mov esi,pValX
    mov edi,pValY
    mov eax,[esi]               ; 첫 번째 값
    xchg eax,[edi]              ; 두 번째와 교환
    mov [esi],eax               ; 첫 번째 위치에 저장
    ret
Swap ENDP
END main
```

**7.** ★★ **Greatest Common Divisor**

Write a recursive implementation of Euclid’s algorithm for finding the greatest common divisor (GCD) of two integers. Descriptions of this algorithm are available in algebra books and on the Web. Write a test program that calls your GCD procedure five times, using the following pairs of integers: (5,20), (24,18), (11,7), (432,226), (26,13). After each procedure call, display the GCD.

> 답: 유클리드 호제법은 `gcd(x, y) = y == 0 ? x : gcd(y, x mod y)`이다. 종료 조건은 y = 0이고, 이때 x가 최대공약수이다. 재귀 호출 뒤에는 EAX에 결과가 그대로 남아 있으므로 `ret`만 하면 된다. 결과는 5, 6, 1, 2, 13이다.

```asm
INCLUDE Irvine32.inc

GCD PROTO, x:DWORD, y:DWORD

.data
pairs DWORD 5,20, 24,18, 11,7, 432,226, 26,13
msg1  BYTE "GCD(",0
msgC  BYTE ",",0
msg2  BYTE ") = ",0

.code
main PROC
    mov esi,OFFSET pairs
    mov ecx,5                   ; 5쌍
L1:
    mov edx,OFFSET msg1
    call WriteString
    mov eax,[esi]
    call WriteDec               ; x
    mov edx,OFFSET msgC
    call WriteString
    mov eax,[esi+4]
    call WriteDec               ; y
    mov edx,OFFSET msg2
    call WriteString
    INVOKE GCD, DWORD PTR [esi], DWORD PTR [esi+4]
    call WriteDec               ; 최대공약수
    call Crlf
    add esi,8
    loop L1
    exit
main ENDP

;----------------------------------------------------
GCD PROC USES ebx edx,
    x:DWORD,
    y:DWORD
; Euclid's algorithm (recursive)
; Returns: EAX = gcd(x, y)
;----------------------------------------------------
    mov eax,x
    mov ebx,y
    cmp ebx,0
    je done                     ; 종료 조건: y == 0 이면 x가 답
    mov edx,0
    div ebx                     ; EDX = x mod y
    INVOKE GCD, y, edx          ; 재귀 호출: gcd(y, x mod y)
done:
    ret
GCD ENDP
END main
```

실행 결과:

```
GCD(5,20) = 5
GCD(24,18) = 6
GCD(11,7) = 1
GCD(432,226) = 2
GCD(26,13) = 13
```

**8.** ★★ **Counting Matching Elements**

Write a procedure named CountMatches that receives points to two arrays of signed doublewords, and a third parameter that indicates the length of the two arrays. For each element xᵢ in the first array, if the corresponding yᵢ in the second array is equal, increment a count. At the end, return a count of the number of matching array elements in EAX. Write a test program that calls your procedure and passes pointers to two different pairs of arrays. Use the INVOKE statement to call your procedure and pass stack parameters. Create a PROTO declaration for CountMatches. Save and restore any registers (other than EAX) changed by your procedure.

> 답: 두 배열을 같은 인덱스끼리 비교하면서 같으면 EAX를 증가시킨다. 길이가 0이면 `loop`가 오동작하므로 먼저 검사한다. 결과는 3, 4이다.

```asm
INCLUDE Irvine32.inc

CountMatches PROTO,
    ptrX:PTR SDWORD,
    ptrY:PTR SDWORD,
    len:DWORD

.data
x1 SDWORD 1,2,3,4,5
y1 SDWORD 1,0,3,0,5                     ; 일치: 1, 3, 5 → 3
x2 SDWORD -10,20,-30,40,-50,60
y2 SDWORD -10,20,30,40,-50,0            ; 일치: -10, 20, 40, -50 → 4

.code
main PROC
    INVOKE CountMatches, ADDR x1, ADDR y1, LENGTHOF x1
    call WriteDec
    call Crlf
    INVOKE CountMatches, ADDR x2, ADDR y2, LENGTHOF x2
    call WriteDec
    call Crlf
    exit
main ENDP

CountMatches PROC USES ebx ecx esi edi,
    ptrX:PTR SDWORD,
    ptrY:PTR SDWORD,
    len:DWORD
    mov esi,ptrX
    mov edi,ptrY
    mov ecx,len
    mov eax,0                   ; 일치 개수
    cmp ecx,0
    je done
L1:
    mov ebx,[esi]
    cmp ebx,[edi]
    jne next
    inc eax                     ; 같으면 카운트 증가
next:
    add esi,4
    add edi,4
    loop L1
done:
    ret
CountMatches ENDP
END main
```

**9.** ★★★ **Counting Nearly Matching Elements**

Write a procedure named CountNearMatches that receives pointers to two arrays of signed doublewords, a parameter that indicates the length of the two arrays, and a parameter that indicates the maximum allowed difference (called diff) between any two matching elements. For each element xᵢ in the first array, if the difference between it and the corresponding yᵢ in the second array is less than or equal to diff, increment a count. At the end, return a count of the number of nearly matching array elements in EAX. Write a test program that calls CountNearMatches and passes pointers to two different pairs of arrays. Use the INVOKE statement to call your procedure and pass stack parameters. Create a PROTO declaration for CountMatches. Save and restore any registers (other than EAX) changed by your procedure.

> 답: 8번과 같은 구조에서 `x - y`의 절댓값(음수면 NEG)을 구해 `diff`와 부호 있는 비교(JG)를 한다. 절댓값이 diff보다 크지 않으면 카운트를 증가시킨다. 결과는 3, 2이다. (문제의 "PROTO for CountMatches"는 오타로 보고 CountNearMatches의 PROTO를 선언했다.)

```asm
INCLUDE Irvine32.inc

CountNearMatches PROTO,
    ptrX:PTR SDWORD,
    ptrY:PTR SDWORD,
    len:DWORD,
    diff:DWORD

.data
x1 SDWORD 10,20,30,40,50
y1 SDWORD 12,18,35,40,45                ; 차이: 2,2,5,0,5  (diff=2) → 3
x2 SDWORD -5,0,5,10
y2 SDWORD -7,3,4,20                     ; 차이: 2,3,1,10   (diff=2) → 2

.code
main PROC
    INVOKE CountNearMatches, ADDR x1, ADDR y1, LENGTHOF x1, 2
    call WriteDec
    call Crlf
    INVOKE CountNearMatches, ADDR x2, ADDR y2, LENGTHOF x2, 2
    call WriteDec
    call Crlf
    exit
main ENDP

CountNearMatches PROC USES ebx ecx esi edi,
    ptrX:PTR SDWORD,
    ptrY:PTR SDWORD,
    len:DWORD,
    diff:DWORD
    mov esi,ptrX
    mov edi,ptrY
    mov ecx,len
    mov eax,0                   ; 근접 일치 개수
    cmp ecx,0
    je done
L1:
    mov ebx,[esi]
    sub ebx,[edi]               ; x - y
    jns L2
    neg ebx                     ; 절댓값
L2:
    cmp ebx,diff
    jg next                     ; |x - y| > diff 이면 건너뜀
    inc eax
next:
    add esi,4
    add edi,4
    loop L1
done:
    ret
CountNearMatches ENDP
END main
```

**10.** ★★★★ **Show Procedure Parameters**

Write a procedure named ShowParams that displays the address and hexadecimal value of the 32-bit parameters on the runtime stack of the procedure that called it. The parameters are to be displayed in order from the lowest address to the highest. Input to the procedure will be a single integer that indicates the number of parameters to display. For example, suppose the following statement in main calls MySample, passing three arguments:

```asm
INVOKE MySample, 1234h, 5000h, 6543h
```

> 답: ShowParams 안에서 `[ebp]`에는 **호출한 프로시저(MySample)의 EBP**가 저장되어 있다. 그 값에 8을 더하면 MySample의 첫 번째 매개변수 주소(`[EBP+8]`)가 되고, 거기서부터 4바이트씩 올라가며 `count`개를 출력하면 낮은 주소에서 높은 주소 순서가 된다. 이 방법은 MySample이 `push ebp / mov ebp,esp`로 시작하는 표준 스택 프레임을 가질 때(매개변수 목록이 있는 PROC) 동작한다. (제공된 PDF 페이지가 문제 중간에서 끊겨 있어서, 보이는 설명을 기준으로 풀었다.)

```asm
INCLUDE Irvine32.inc

ShowParams PROTO, count:DWORD
MySample   PROTO, p1:DWORD, p2:DWORD, p3:DWORD

.data
msgHeader BYTE "Stack parameters:",0dh,0ah
          BYTE "---------------------------",0
msgAddr   BYTE "Address ",0
msgEq     BYTE " = ",0

.code
main PROC
    INVOKE MySample, 1234h, 5000h, 6543h
    exit
main ENDP

MySample PROC,
    p1:DWORD,
    p2:DWORD,
    p3:DWORD
    INVOKE ShowParams, 3        ; 매개변수 3개를 출력
    ret
MySample ENDP

;----------------------------------------------------
ShowParams PROC USES eax ecx edx esi,
    count:DWORD
; 호출한 프로시저의 스택 매개변수를 낮은 주소부터 출력한다.
;----------------------------------------------------
    mov edx,OFFSET msgHeader
    call WriteString
    call Crlf

    mov esi,[ebp]               ; 호출한 프로시저의 EBP
    add esi,8                   ; 첫 번째 매개변수의 주소
    mov ecx,count
    cmp ecx,0
    je done
L1:
    mov edx,OFFSET msgAddr
    call WriteString
    mov eax,esi
    call WriteHex               ; 주소
    mov edx,OFFSET msgEq
    call WriteString
    mov eax,[esi]
    call WriteHex               ; 값
    call Crlf
    add esi,4                   ; 다음(더 높은 주소) 매개변수
    loop L1
done:
    ret
ShowParams ENDP
END main
```

실행 결과 예 (주소는 실행할 때마다 다를 수 있다):

```
Stack parameters:
---------------------------
Address 0012FF80 = 00001234
Address 0012FF84 = 00005000
Address 0012FF88 = 00006543
```
