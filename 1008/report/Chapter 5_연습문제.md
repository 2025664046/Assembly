# 1008 과제 - 5.8 Review Questions and Exercises

## 5.8.1 Short Answer

**1.** Which instruction pushes all of the 32-bit general-purpose registers on the stack?
→ **PUSHAD**

**2.** Which instruction pushes the 32-bit EFLAGS register on the stack?
→ **PUSHFD**

**3.** Which instruction pops the stack into the EFLAGS register?
→ **POPFD**

**4.** *Challenge:* Another assembler (called NASM) permits the PUSH instruction to list multiple specific registers. Why might this approach be better than the PUSHAD instruction in MASM? Here is a NASM example: `PUSH EAX EBX ECX`
PUSHAD는 8개 레지스터를 무조건 다 넣음(32바이트).
→ **필요한 레지스터만 골라 넣으니 스택 공간·시간 절약. 반환값 담을 EAX 같은 레지스터를 덮어쓰지 않게 뺄 수도 있음.**

**5.** *Challenge:* Suppose there were no PUSH instruction. Write a sequence of two other instructions that would accomplish the same as push eax.
```asm
sub esp,4          ; 스택 포인터를 4바이트 내림
mov [esp],eax      ; 그 자리에 EAX 저장
```

**6.** *(True/False):* The RET instruction pops the top of the stack into the instruction pointer.
→ **True**

**7.** *(True/False):* Nested procedure calls are not permitted by the Microsoft assembler unless the NESTED operator is used in the procedure definition.
→ **False** (NESTED 연산자 없음. 중첩 호출은 그냥 됨)

**8.** *(True/False):* In protected mode, each procedure call uses a minimum of 4 bytes of stack space.
→ **True** (CALL이 32비트 반환 주소를 push)

**9.** *(True/False):* The ESI and EDI registers cannot be used when passing 32-bit parameters to procedures.
→ **False** (ArraySum도 ESI로 전달함)

**10.** *(True/False):* The ArraySum procedure (Section 5.2.5) receives a pointer to any array of doublewords.
→ **True** (ESI = 배열 주소, ECX = 개수)

**11.** *(True/False):* The USES operator lets you name all registers that are modified within a procedure.
→ **True**

**12.** *(True/False):* The USES operator only generates PUSH instructions, so you must code POP instructions yourself.
→ **False** (RET 앞에 POP도 자동 생성)

**13.** *(True/False):* The register list in the USES directive must use commas to separate the register names.
→ **False** (공백/탭으로 구분. 콤마 쓰면 오류)

**14.** Which statement(s) in the ArraySum procedure (Section 5.2.5) would have to be modified so it could accumulate an array of 16-bit words? Create such a version of ArraySum and test it.
바꿀 곳 → **`add eax,[esi]`** 와 **`add esi,TYPE DWORD`** 두 줄.
16비트 값을 32비트로 0확장해 더하고, 포인터는 2씩 증가.
```asm
INCLUDE Irvine32.inc
.data
array WORD 1000h,2000h,3000h,4000h
.code
main PROC
    mov  esi,OFFSET array
    mov  ecx,LENGTHOF array
    call ArraySumW
    call WriteHex            ; 0000A000
    call Crlf
    exit
main ENDP

;---------------------------------------
; ArraySumW: 16비트 WORD 배열의 합
; Receives: ESI = 배열 주소, ECX = 원소 개수
; Returns:  EAX = 합
;---------------------------------------
ArraySumW PROC USES esi ecx edx
    mov  eax,0
L1: movzx edx,WORD PTR [esi]  ; 바뀐 줄: WORD를 32비트로 확장
    add  eax,edx
    add  esi,TYPE WORD        ; 바뀐 줄: 2바이트씩 이동
    loop L1
    ret
ArraySumW ENDP
END main
```

**15.** What will be the final value in EAX after these instructions execute?
`push 5 / push 6 / pop eax / pop eax`
첫 pop → 6, 두 번째 pop → 5.
→ **EAX = 5**

**16.** Which statement is true about what will happen when the example code runs? (main: push 10, push 20, call Ex2Sub, pop eax / Ex2Sub: pop eax, ret)
a. EAX will equal 10 on line 6
b. The program will halt with a runtime error on Line 10
c. EAX will equal 20 on line 6
d. The program will halt with a runtime error on Line 11
Line 10의 pop이 반환 주소를 꺼냄. RET은 20을 주소로 보고 점프.
→ **d**

**17.** Which statement is true about what will happen when the example code runs? (main: mov eax,30, push eax, push 40, call Ex3Sub / Ex3Sub: pusha, mov eax,80, popa, ret)
a. EAX will equal 40 on line 6
b. The program will halt with a runtime error on Line 6
c. EAX will equal 30 on line 6
d. The program will halt with a runtime error on Line 13
pusha/popa는 짝이 맞아 스택 균형 유지 → RET이 정상 반환 주소로 감. popa가 AX를 30으로 복원(상위 16비트는 mov eax,80 때 이미 0).
→ **c** (EAX = 30 on line 6)

**18.** Which statement is true about what will happen when the example code runs? (main: mov eax,40, push offset Here, jmp Ex4Sub, Here: mov eax,30 / Ex4Sub: ret)
a. EAX will equal 30 on line 7
b. The program will halt with a runtime error on Line 4
c. EAX will equal 30 on line 6
d. The program will halt with a runtime error on Line 11
Here 주소를 직접 push 후 jmp → RET이 Here로 돌아감 → line 6 실행 후 line 7에서 EAX=30.
→ **a**

**19.** Which statement is true about what will happen when the example code runs? (main: mov edx,0, mov eax,40, push eax, call Ex5Sub / Ex5Sub: pop eax, pop edx, push eax, ret)
a. EDX will equal 40 on line 6
b. The program will halt with a runtime error on Line 13
c. EDX will equal 0 on line 6
d. The program will halt with a runtime error on Line 11
pop eax = 반환 주소, pop edx = 40, push eax로 반환 주소 복구 → 정상 반환.
→ **a**

**20.** What values will be written to the array when the following code executes?
호출 순서: main → proc_1 → proc_2 → proc_3. 가장 안쪽부터 기록됨.
proc_3: array[0]=10 → proc_2: array[4]=20 → proc_1: array[8]=30 → main: array[12]=40
→ **array = 10, 20, 30, 40**

## 5.8.2 Algorithm Workbench

**1.** Write a sequence of statements that use only PUSH and POP instructions to exchange the values in the EAX and EBX registers (or RAX and RBX in 64-bit mode).
```asm
push eax
push ebx
pop  eax      ; EAX ← 원래 EBX
pop  ebx      ; EBX ← 원래 EAX
```

**2.** Suppose you wanted a subroutine to return to an address that was 3 bytes higher in memory than the return address currently on the stack. Write a sequence of instructions that would be inserted just before the subroutine's RET instruction that accomplish this task.
```asm
add DWORD PTR [esp],3    ; 스택 맨 위 반환 주소 +3
ret
```

**3.** Functions in high-level languages often declare local variables just below the return address on the stack. Write an instruction that you could put at the beginning of an assembly language subroutine that would reserve space for two integer doubleword variables. Then, assign the values 1000h and 2000h to the two local variables.
```asm
sub esp,8                      ; DWORD 2개 공간 확보
mov DWORD PTR [esp],1000h      ; 지역변수 1
mov DWORD PTR [esp+4],2000h    ; 지역변수 2
; ... RET 전에 add esp,8 로 해제
```

**4.** Write a sequence of statements using indexed addressing that copies an element in a doubleword array to the previous position in the same array.
```asm
mov esi,index                  ; 복사할 원소 인덱스 (1 이상)
mov eax,array[esi*4]           ; array[i]
mov array[esi*4-4],eax         ; → array[i-1]
```

**5.** Write a sequence of statements that display a subroutine's return address. Be sure that whatever modifications you make to the stack do not prevent the subroutine from returning to its caller.
```asm
MySub PROC
    push eax
    mov  eax,[esp+4]    ; push eax 때문에 반환 주소는 ESP+4
    call WriteHex
    call Crlf
    pop  eax            ; 스택 원상복구
    ret
MySub ENDP
```

## 5.9 Programming Exercises

_When you write programs to solve the programming exercises, use multiple procedures when possible. Follow the style and naming conventions used in this book, unless instructed otherwise by your instructor. Use explanatory comments in your programs at the beginning of each procedure and next to nontrivial statements._

**1. Draw Text Colors**

Write a program that displays the same string in four different colors, using a loop. Call the SetTextColor procedure from the book's link library. Any colors may be chosen, but you may find it easiest to change the foreground color.

> 답:

```asm
INCLUDE Irvine32.inc

.data
msg    BYTE "Assembly Language is fun!",0
colors DWORD lightRed, lightGreen, lightCyan, yellow   ; 사용할 4가지 전경색

.code
main PROC
    mov  ecx,LENGTHOF colors        ; 반복 횟수 = 색 개수(4)
    mov  esi,OFFSET colors          ; 색 배열 포인터
L1:
    mov  eax,[esi]                  ; 현재 색 (배경 black = 0)
    call SetTextColor
    call ShowMessage                ; 문자열 출력
    add  esi,TYPE colors            ; 다음 색으로
    loop L1

    mov  eax,lightGray + (black*16) ; 기본 색으로 복구
    call SetTextColor
    exit
main ENDP

;---------------------------------------
; ShowMessage: msg를 출력하고 줄바꿈
;---------------------------------------
ShowMessage PROC USES edx
    mov  edx,OFFSET msg
    call WriteString
    call Crlf
    ret
ShowMessage ENDP

END main
```

**2. Linking Array Items**

Suppose you are given three data items that indicate a starting index in a list, an array of characters, and an array of link index. You are to write a program that traverses the links and locates the characters in their correct sequence. For each character you locate, copy it to a new array. Suppose you used the following sample data, and assumed the arrays use zero-based indexes:

```

start = 1
chars:   H  A  C  E  B  D  F  G
links:   0  4  5  6  2  3  7  0

```

Then the values copied (in order) to the output array would be A,B,C,D,E,F,G,H. Declare the character array as type BYTE, and to make the problem more interesting, declare the links array type DWORD.

> 답:

```asm
INCLUDE Irvine32.inc

.data
start  DWORD 1
chars  BYTE  'H','A','C','E','B','D','F','G'
links  DWORD 0,4,5,6,2,3,7,0
output BYTE  LENGTHOF chars DUP(?),0     ; 결과 배열 + 문자열 종료용 0

.code
main PROC
    call TraverseLinks
    mov  edx,OFFSET output
    call WriteString                     ; ABCDEFGH
    call Crlf
    exit
main ENDP

;---------------------------------------
; TraverseLinks: start부터 links를 따라가며
; chars의 문자를 output에 순서대로 복사
;---------------------------------------
TraverseLinks PROC USES eax ecx esi edi
    mov  ecx,LENGTHOF chars              ; 문자 개수만큼 반복
    mov  esi,start                       ; 현재 인덱스
    mov  edi,0                           ; output 인덱스
L1:
    mov  al,chars[esi]                   ; 현재 위치의 문자
    mov  output[edi],al                  ; 결과 배열에 복사
    inc  edi
    mov  esi,links[esi*4]                ; 다음 인덱스 (DWORD라 *4)
    loop L1
    ret
TraverseLinks ENDP

END main
```

**3. Simple Addition (1)**

Write a program that clears the screen, locates the cursor near the middle of the screen, prompts the user for two integers, adds the integers, and displays their sum.

> 답:

```asm
INCLUDE Irvine32.inc

MID_ROW = 12                ; 화면 중앙 근처 행
MID_COL = 30                ; 화면 중앙 근처 열

.data
prompt1 BYTE "Enter the first integer:  ",0
prompt2 BYTE "Enter the second integer: ",0
sumMsg  BYTE "Sum: ",0

.code
main PROC
    call Clrscr                     ; 화면 지우기
    call AddTwoIntegers
    call Crlf
    exit
main ENDP

;---------------------------------------
; AddTwoIntegers: 화면 중앙에서 정수 2개를
; 입력받아 합을 출력
;---------------------------------------
AddTwoIntegers PROC USES eax ebx edx
    ; 첫 번째 정수 입력
    mov  dh,MID_ROW
    mov  dl,MID_COL
    call Gotoxy                     ; 커서 이동 (DH=행, DL=열)
    mov  edx,OFFSET prompt1
    call WriteString
    call ReadInt                    ; EAX = 입력값
    mov  ebx,eax                    ; 첫 값 보관

    ; 두 번째 정수 입력 (한 줄 아래)
    mov  dh,MID_ROW+1
    mov  dl,MID_COL
    call Gotoxy
    mov  edx,OFFSET prompt2
    call WriteString
    call ReadInt
    add  eax,ebx                    ; EAX = 합

    ; 합 출력
    mov  dh,MID_ROW+2
    mov  dl,MID_COL
    call Gotoxy
    mov  edx,OFFSET sumMsg
    call WriteString
    call WriteInt                   ; 부호 있는 정수 출력
    ret
AddTwoIntegers ENDP

END main
```

**4. Simple Addition (2)**

Use the solution program from the preceding exercise as a starting point. Let this new program repeat the same steps three times, using a loop. Clear the screen after each loop iteration.

> 답:

```asm
INCLUDE Irvine32.inc

MID_ROW = 12
MID_COL = 30

.data
prompt1 BYTE "Enter the first integer:  ",0
prompt2 BYTE "Enter the second integer: ",0
sumMsg  BYTE "Sum: ",0

.code
main PROC
    mov  ecx,3                      ; 3번 반복
L1:
    call Clrscr
    call AddTwoIntegers
    call Crlf
    call Crlf
    call WaitMsg                    ; 결과 확인할 시간 ("Press any key...")
    call Clrscr                     ; 반복마다 화면 지우기
    loop L1
    exit
main ENDP

;---------------------------------------
; AddTwoIntegers: 화면 중앙에서 정수 2개를
; 입력받아 합을 출력 (ECX 등 레지스터 보존)
;---------------------------------------
AddTwoIntegers PROC USES eax ebx edx
    mov  dh,MID_ROW
    mov  dl,MID_COL
    call Gotoxy
    mov  edx,OFFSET prompt1
    call WriteString
    call ReadInt
    mov  ebx,eax                    ; 첫 값 보관

    mov  dh,MID_ROW+1
    mov  dl,MID_COL
    call Gotoxy
    mov  edx,OFFSET prompt2
    call WriteString
    call ReadInt
    add  eax,ebx                    ; 합

    mov  dh,MID_ROW+2
    mov  dl,MID_COL
    call Gotoxy
    mov  edx,OFFSET sumMsg
    call WriteString
    call WriteInt
    ret
AddTwoIntegers ENDP

END main
```

**5. BetterRandomRange Procedure**

The RandomRange procedure from the Irvine32 library generates a pseudorandom integer between 0 and N − 1. Your task is to create an improved version that generates an integer between M and N − 1. Let the caller pass M in EBX and N in EAX. If we call the procedure BetterRandomRange, the following code is a sample test:

```nasm
mov ebx,-300    ; lower bound
mov eax,100     ; upper bound
call BetterRandomRange
```

Write a short test program that calls BetterRandomRange from a loop that repeats 50 times. Display each randomly generated value.

> 답:

```asm
INCLUDE Irvine32.inc

.code
main PROC
    call Randomize                  ; 난수 시드 초기화
    mov  ecx,50                     ; 50번 반복
L1:
    mov  ebx,-300                   ; M (하한)
    mov  eax,100                    ; N (상한, 결과는 N-1까지)
    call BetterRandomRange
    call WriteInt                   ; 부호 있는 값 출력
    call Crlf
    loop L1
    exit
main ENDP

;---------------------------------------
; BetterRandomRange: M ~ N-1 범위 난수 생성
; Receives: EBX = M, EAX = N
; Returns:  EAX = 난수 (M <= EAX <= N-1)
;---------------------------------------
BetterRandomRange PROC
    sub  eax,ebx                    ; 범위 크기 = N - M
    call RandomRange                ; EAX = 0 ~ (N-M-1)
    add  eax,ebx                    ; M만큼 이동 → M ~ N-1
    ret
BetterRandomRange ENDP

END main
```

**6. Random Strings**

Create a procedure that generates a random string of length L, containing all capital letters. When calling the procedure, pass the value of L in EAX, and pass a pointer to an array of byte that will hold the random string. Write a test program that calls your procedure 20 times and displays the strings in the console window.

> 답:

```.data
INCLUDE Irvine32.inc

STR_LEN = 10                        ; 문자열 길이 L

.data
buffer BYTE STR_LEN+1 DUP(0)        ; L개 문자 + 종료 0

.code
main PROC
    call Randomize
    mov  ecx,20                     ; 20번 생성
L1:
    mov  eax,STR_LEN                ; EAX = L
    mov  esi,OFFSET buffer          ; ESI = 버퍼 주소
    call CreateRandomString
    mov  edx,OFFSET buffer
    call WriteString
    call Crlf
    loop L1
    exit
main ENDP

;---------------------------------------
; CreateRandomString: 대문자 난수 문자열 생성
; Receives: EAX = 길이 L, ESI = BYTE 배열 주소
; Returns:  배열에 문자열 저장 (끝에 0 추가)
;---------------------------------------
CreateRandomString PROC USES eax ecx esi
    mov  ecx,eax                    ; L번 반복
L1:
    mov  eax,26                     ; 0~25 난수
    call RandomRange
    add  al,'A'                     ; 'A'~'Z'로 변환
    mov  [esi],al
    inc  esi
    loop L1
    mov  BYTE PTR [esi],0           ; 문자열 종료
    ret
CreateRandomString ENDP

END main
```

**7. Random Screen Locations**

Write a program that displays a single character at 100 random screen locations, using a timing delay of 100 milliseconds. Hint: Use the GetMaxXY procedure to determine the current size of the console window.

> 답:

```asm
INCLUDE Irvine32.inc

.data
rows BYTE ?                         ; 콘솔 행 수
cols BYTE ?                         ; 콘솔 열 수

.code
main PROC
    call Randomize
    call Clrscr
    call GetMaxXY                   ; AX = 행 수, DX = 열 수
    mov  rows,al
    mov  cols,dl

    mov  ecx,100                    ; 100개 위치
L1:
    call ShowRandomChar
    mov  eax,100                    ; 100ms 지연
    call Delay
    loop L1

    mov  dh,rows                    ; 커서를 맨 아래로 옮겨 마무리
    dec  dh
    mov  dl,0
    call Gotoxy
    exit
main ENDP

;---------------------------------------
; ShowRandomChar: 무작위 위치에 '*' 출력
;---------------------------------------
ShowRandomChar PROC USES eax edx
    movzx eax,cols
    call RandomRange                ; 0 ~ cols-1
    mov  dl,al                      ; 열
    movzx eax,rows
    call RandomRange                ; 0 ~ rows-1
    mov  dh,al                      ; 행
    call Gotoxy
    mov  al,'*'
    call WriteChar
    ret
ShowRandomChar ENDP

END main
```

**8. Color Matrix**

Write a program that displays a single character in all possible combinations of foreground and background colors (16 × 16 = 256). The colors are numbered from 0 to 15, so you can use a nested loop to generate all possible combinations.

> 답:

```asm
INCLUDE Irvine32.inc

.code
main PROC
    mov  ebx,0                      ; 배경색 0~15
    mov  ecx,16                     ; 바깥 루프: 배경색 16개
Outer:
    push ecx                        ; 바깥 루프 카운터 저장
    call ShowRow                    ; 한 배경색에 대해 전경색 16개 출력
    inc  ebx                        ; 다음 배경색
    pop  ecx
    loop Outer

    mov  eax,lightGray + (black*16) ; 기본 색 복구
    call SetTextColor
    exit
main ENDP

;---------------------------------------
; ShowRow: 배경색 EBX에서 전경색 0~15로
; 문자 하나씩 출력 후 줄바꿈
; Receives: EBX = 배경색
;---------------------------------------
ShowRow PROC USES eax ecx edi
    mov  edi,0                      ; 전경색 0~15
    mov  ecx,16                     ; 안쪽 루프
Inner:
    mov  eax,ebx
    shl  eax,4                      ; 배경색 * 16
    add  eax,edi                    ; + 전경색
    call SetTextColor
    mov  al,'A'
    call WriteChar
    inc  edi
    loop Inner

    mov  eax,lightGray + (black*16) ; 줄 끝은 기본 색으로
    call SetTextColor
    call Crlf
    ret
ShowRow ENDP

END main
```

**9. Recursive Procedure**

Direct recursion is the term we use when a procedure calls itself. Of course, you never want to let a procedure keep calling itself forever, because the runtime stack would fill up. Instead, you must limit the recursion in some way. Write a program that calls a recursive procedure. Inside this procedure, add 1 to a counter so you can verify the number of times it executes. Run your program with a debugger, and at the end of the program, check the counter's value. Put a number in ECX that specifies the number of times you want to allow the recursion to continue. Using only the LOOP instruction (and no other conditional statements from later chapters), find a way for the recursive procedure to call itself a fixed number of times.

> 답:

```asm
INCLUDE Irvine32.inc

.data
counter DWORD 0                     ; 실행 횟수

.code
main PROC
    mov  ecx,10                     ; 재귀 허용 횟수
    call Recurse
    mov  eax,counter                ; 디버거에서 확인할 값 (10)
    call WriteDec
    call Crlf
    exit
main ENDP

;---------------------------------------
; Recurse: ECX번 자기 자신을 호출
; Receives: ECX = 호출 횟수
; LOOP가 ECX를 1 줄이고 0이 아니면 L1으로 점프 → 재귀
; ECX가 0이 되면 점프 안 함 → ret로 되돌아감
;---------------------------------------
Recurse PROC
    inc  counter                    ; 실행될 때마다 +1
    loop L1                         ; ECX-1, ECX≠0이면 재귀
    ret                             ; ECX=0 → 재귀 종료
L1:
    call Recurse                    ; 자기 자신 호출
    ret
Recurse ENDP

END main
```

**10. Fibonacci Generator**

Write a procedure that produces N values in the Fibonacci number series and stores them in an array of doubleword. Input parameters should be a pointer to an array of doubleword, a counter of the number of values to generate. Write a test program that calls your procedure, passing N = 47. The first value in the array will be 1, and the last value will be 2,971,215,073. Use the Visual Studio debugger to open and inspect the array contents.

> 답:

```asm
INCLUDE Irvine32.inc

FIB_COUNT = 47

.data
fibArray DWORD FIB_COUNT DUP(?)

.code
main PROC
    mov  esi,OFFSET fibArray        ; 배열 주소
    mov  ecx,FIB_COUNT              ; 생성 개수 N
    call FibGenerator

    ; 확인용 출력 (디버거로 fibArray를 봐도 됨)
    mov  esi,OFFSET fibArray
    mov  ecx,FIB_COUNT
L1:
    mov  eax,[esi]
    call WriteDec                   ; 부호 없는 값 (마지막 2971215073)
    call Crlf
    add  esi,TYPE fibArray
    loop L1
    exit
main ENDP

;---------------------------------------
; FibGenerator: 피보나치 수 N개를 배열에 저장
; Receives: ESI = DWORD 배열 주소, ECX = N
; 수열: 1, 1, 2, 3, 5, ...
;---------------------------------------
FibGenerator PROC USES eax ebx ecx edx esi
    mov  eax,1                      ; 현재 값 F(n)
    mov  ebx,0                      ; 이전 값 F(n-1)
L1:
    mov  [esi],eax                  ; 현재 값 저장
    mov  edx,eax                    ; 현재 값 임시 보관
    add  eax,ebx                    ; 다음 값 = 현재 + 이전
    mov  ebx,edx                    ; 이전 ← 현재
    add  esi,TYPE DWORD
    loop L1
    ret
FibGenerator ENDP

END main
```

**11. Finding Multiples of K**

In a byte array of size N, write a procedure that finds all multiples of K that are less than N. Initialize the array to all zeros at the beginning of the program, and then whenever a multiple is found, set the corresponding array element to 1. Your procedure must save and restore any registers it modifies. Call your procedure twice, with K = 2, and again with K = 3. Let N equal to 50. Run your program in the debugger and verify that the array values were set correctly. Note: This procedure can be a useful tool when finding prime integers. An efficient algorithm for finding prime numbers is known as the Sieve of Eratosthenes. You will be able to implement this algorithm when conditional statements are covered in Chapter 6.

> 답:

```asm
INCLUDE Irvine32.inc

N = 50

.data
array2 BYTE N DUP(?)                ; K=2 결과
array3 BYTE N DUP(?)                ; K=3 결과

.code
main PROC
    ; 배열을 0으로 초기화
    mov  esi,OFFSET array2
    mov  ecx,N
    call ClearArray
    mov  esi,OFFSET array3
    call ClearArray

    ; K = 2
    mov  esi,OFFSET array2
    mov  ecx,N
    mov  ebx,2
    call FindMultiples

    ; K = 3
    mov  esi,OFFSET array3
    mov  ebx,3
    call FindMultiples

    ; 결과 확인 (디버거 대신 메모리 덤프)
    mov  esi,OFFSET array2
    mov  ecx,N
    mov  ebx,TYPE BYTE
    call DumpMem
    mov  esi,OFFSET array3
    call DumpMem
    exit
main ENDP

;---------------------------------------
; ClearArray: BYTE 배열을 0으로 채움
; Receives: ESI = 배열 주소, ECX = 크기
;---------------------------------------
ClearArray PROC USES ecx esi
L1:
    mov  BYTE PTR [esi],0
    inc  esi
    loop L1
    ret
ClearArray ENDP

;---------------------------------------
; FindMultiples: N보다 작은 K의 배수(K, 2K, ...)
; 위치를 1로 표시 (0은 제외)
; Receives: ESI = 배열 주소, ECX = N, EBX = K (0 < K < N)
; 모든 수정 레지스터 저장/복원 (USES)
;---------------------------------------
FindMultiples PROC USES eax ecx edx edi
    ; 배수 개수 = (N-1) / K  → 조건문 없이 LOOP 횟수로 사용
    mov  eax,ecx
    dec  eax
    mov  edx,0
    div  ebx                        ; EAX = 배수 개수
    mov  ecx,eax

    mov  edi,ebx                    ; 첫 배수 = K
L1:
    mov  BYTE PTR [esi+edi],1       ; 배수 위치 표시
    add  edi,ebx                    ; 다음 배수
    loop L1
    ret
FindMultiples ENDP

END main
```
