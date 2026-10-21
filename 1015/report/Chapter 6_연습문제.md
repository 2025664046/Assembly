# 6.10 Review Questions and Exercises

## 6.10.1 Short Answer

**1.** What will be the value of BX after the following instructions execute?

```asm
mov bx,0FFFFh
and bx,6Bh
```

> 답: BX = 006Bh

**2.** What will be the value of BX after the following instructions execute?

```asm
mov bx,91BAh
and bx,92h
```

> 답: BX = 0092h

**3.** What will be the value of BX after the following instructions execute?

```asm
mov bx,0649Bh
or bx,3Ah
```

> 답:BX = 64BBh

**4.** What will be the value of BX after the following instructions execute?

```asm
mov bx,029D6h
xor bx,8181h
```

> 답: BX = A857h

**5.** What will be the value of EBX after the following instructions execute?

```asm
mov ebx,0AFAF649Bh
or ebx,3A219604h
```

> 답: EBX = BFAFF69Fh

**6.** What will be the value of RBX after the following instructions execute?

```asm
mov rbx,0AFAF649Bh
xor rbx,0FFFFFFFFh
```

> 답: RBX = FFFFFFFF50509B64h

**7.** In the following instruction sequence, show the resulting value of AL where indicated, in binary:

```asm
mov al,01101111b
and al,00101101b      ; a.

mov al,6Dh
and al,4Ah            ; b.

mov al,00001111b
or  al,61h            ; c.

mov al,94h
xor al,37h            ; d.
```

> 답:
> a. 00101101b
> b. 01001000b
> c. 01101111b
> d. 10100011b

**8.** In the following instruction sequence, show the resulting value of AL where indicated, in hexadecimal:

```asm
mov al,7Ah
not al                ; a.

mov al,3Dh
and al,74h            ; b.

mov al,9Bh
or  al,35h            ; c.

mov al,72h
xor al,0DCh           ; d.
```

> 답:
> a. 85h
> b. 34h
> c. BFh
> d. AEh

**9.** In the following instruction sequence, show the values of the Carry, Zero, and Sign flags where indicated:

```asm
mov al,00001111b
test al,00000010b     ; a. CF= ZF= SF=

mov al,00000110b
cmp al,00000101b      ; b. CF= ZF= SF=

mov al,00000101b
cmp al,00000111b      ; c. CF= ZF= SF=
```

> 답:
> a. CF=0, ZF=0, SF=0
> b. CF=0, ZF=0, SF=0
> c. CF=1, ZF=0, SF=1

**10.** Which conditional jump instruction executes a branch based on the contents of ECX?

> 답: ECX가 0일 때 점프하는 명령어는 JECXZ이다.

**11.** How are JA and JNBE affected by the Zero and Carry flags?

> 답: JA와 JNBE는 동의어이며, CF=0 및 ZF=0일 때 점프한다.

**12.** What will be the final value in EDX after this code executes?

```asm
    mov edx,1
    mov eax,7FFFh
    cmp eax,8000h
    jl L1
    mov edx,0
L1:
```

> 답: EDX = 1

**13.** What will be the final value in EDX after this code executes?

```asm
    mov edx,1
    mov eax,7FFFh
    cmp eax,8000h
    jb L1
    mov edx,0
L1:
```

> 답: EDX = 1

**14.** What will be the final value in EDX after this code executes?

```asm
    mov edx,1
    mov eax,7FFFh
    cmp eax,0FFFF8000h
    jl L2
    mov edx,0
L2:
```

> 답: EDX = 0

**15.** (True/False): The following code will jump to the label named Target.

```asm
mov eax,-30
cmp eax,-50
jg Target
```

> 답: 참.

**16.** (True/False): The following code will jump to the label named Target.

```asm
mov eax,-42
cmp eax,26
ja Target
```

> 답: 참.

**17.** What will be the value of RBX after the following instructions execute?

```asm
mov rbx,0FFFFFFFFFFFFFFFFh
and rbx,80h
```

> 답: RBX = 0000000000000080h

**18.** What will be the value of RBX after the following instructions execute?

```asm
mov rbx,0FFFFFFFFFFFFFFFFh
and rbx,808080h
```

> 답: RBX = 0000000000808080h

**19.** What will be the value of RBX after the following instructions execute?

```asm
mov rbx,0FFFFFFFFFFFFFFFFh
and rbx,80808080h
```

> 답: RBX = FFFFFFFF80808080h

---

## 6.10.2 Algorithm Workbench

**1.** Write a single instruction that converts an ASCII digit in AL to its corresponding binary value. If AL already contains a binary value (00h to 09h), leave it unchanged.

> 답:

```asm
and al,0Fh
```

**2.** Write instructions that calculate the parity of a 32-bit memory operand. Hint: Use the formula presented earlier in this section: B0 XOR B1 XOR B2 XOR B3.

> 답:

```asm
.data
mem DWORD 12345678h
.code
mov al,BYTE PTR mem          ; B0
xor al,BYTE PTR [mem+1]      ; B0 XOR B1
xor al,BYTE PTR [mem+2]      ; ... XOR B2
xor al,BYTE PTR [mem+3]      ; ... XOR B3
; 마지막 XOR 직후 PF=1 -> 짝수 패리티, PF=0 -> 홀수 패리티
```

**3.** Given two bit-mapped sets named SetX and SetY, write a sequence of instructions that generate a bit string in EAX that represents members in SetX that are not members of SetY.

> 답:

```asm
mov eax,SetY
not eax            ; SetY의 여집합
and eax,SetX       ; SetX ∩ (SetY의 여집합) = SetX − SetY
```

**4.** Write instructions that jump to label L1 when the unsigned integer in DX is less than or equal to the integer in CX.

> 답:

```asm
cmp dx,cx
jbe L1
```

**5.** Write instructions that jump to label L2 when the signed integer in AX is greater than the integer in CX.

> 답:

```asm
cmp ax,cx
jg L2
```

**6.** Write instructions that first clear bits 0 and 1 in AL. Then, if the destination operand is equal to zero, the code should jump to label L3. Otherwise, it should jump to label L4.

> 답:

```asm
and al,11111100b    ; 비트 0, 1 클리어 (ZF도 함께 설정됨)
jz  L3              ; 결과 = 0 이면 L3
jmp L4              ; 아니면 L4
```

**7.** Implement the following pseudocode in assembly language. Use short-circuit evaluation and assume that val1 and X are 32-bit variables.

```text
if( val1 > ecx ) AND ( ecx > edx )
    X = 1
else
    X = 2;
```

> 답:

```asm
    cmp val1,ecx
    jbe L_else        ; 첫 조건이 거짓 -> 두 번째는 검사하지 않음
    cmp ecx,edx
    jbe L_else
    mov X,1
    jmp L_next
L_else:
    mov X,2
L_next:
```

**8.** Implement the following pseudocode in assembly language. Use short-circuit evaluation and assume that X is a 32-bit variable.

```text
if( ebx > ecx ) OR ( ebx > val1 )
    X = 1
else
    X = 2
```

> 답:

```asm
    cmp ebx,ecx
    ja  L_then        ; 첫 조건이 참 → 바로 then
    cmp ebx,val1
    ja  L_then
    mov X,2           ; 둘 다 거짓
    jmp L_next
L_then:
    mov X,1
L_next:
```

**9.** Implement the following pseudocode in assembly language. Use short-circuit evaluation and assume that X is a 32-bit variable.

```text
if( ebx > ecx AND ebx > edx) OR ( edx > eax )
    X = 1
else
    X = 2
```

> 답:

```asm
    cmp ebx,ecx
    jbe L_or          ; AND의 첫 조건 거짓 → OR의 오른쪽 검사로
    cmp ebx,edx
    ja  L_then        ; ebx>ecx AND ebx>edx 참 → then
L_or:
    cmp edx,eax
    ja  L_then        ; edx > eax 참 → then
    mov X,2
    jmp L_next
L_then:
    mov X,1
L_next:
```

**10.** Implement the following pseudocode in assembly language. Use short-circuit evaluation and assume that A, B, and N are 32-bit signed integers.

```text
while N > 0
    if N != 3 AND (N < A OR N > B)
        N = N - 2
    else
        N = N - 1
end whle
```

> 답:

```asm
L_while:
    cmp N,0
    jle L_endw          ; N <= 0 이면 종료

    cmp N,3
    je  L_else          ; N == 3 → AND가 거짓
    mov eax,N
    cmp eax,A
    jl  L_then          ; N < A → OR가 참
    cmp eax,B
    jg  L_then          ; N > B → OR가 참
    jmp L_else          ; 둘 다 거짓

L_then:
    sub N,2
    jmp L_while
L_else:
    dec N
    jmp L_while
L_endw:
```

---

# 6.11 Programming Exercises

## 6.11.1 Suggestions for Testing Your Code

We have a few suggestions on how you can test the code you write for the programming exercises in this chapter, and in future chapters.

- Always step through your program with a debugger the first time you test it. It’s so easy to forget a small detail, and the debugger lets you see exactly what’s going on.
- If the specifications call for a signed array, be sure to include some negative values.
- When a range of input values is specified, include test data that falls before, on, and after these boundaries.
- Create multiple test cases, using arrays of different lengths.
- When you’re writing a program that writes to an array, the Visual Studio debugger is the best tool for evaluating your program’s correctness. Use the debugger’s Memory window to display the array, choosing either hexadecimal or decimal representation.
- Immediately after calling the procedure you’re testing, call it a second time to verify that the procedure has preserved all registers. Here’s an example:

  ```asm
  mov esi,OFFSET array
  mov ecx,count
  call CalcSum ; returns sum in EAX
  call CalcSum ; call second time to see if registers are preserved
  ```

  Usually there is a single return value in EAX, which of course, cannot be preserved. For that reason, you usually should not use EAX as an input parameter.

- If you’re planning to pass more than one array to a procedure, make sure you do not refer to the array by name inside the procedure. Instead, set ESI or EDI to the array’s offset before calling your procedure. That means you will be using indirect addressing (such as [esi] or [edi]) inside the procedure.
- If you need to create a variable for use only inside the procedure, you can use the .data directive before the variable, and then follow it with the .code directive. Here’s an example:

  ```asm
  MyCoolProcedure PROC
  .data
  sum SDWORD ?
  .code
      mov sum,0
      (etc.)
  ```

  The variable will still be publicly visible, unlike local variables in languages like C++ or Java. But when you declare it inside a procedure, you’re making it obvious that you do not plan to use it anywhere else. Of course, you must use a runtime instruction to initialize variables used inside a procedure, because you will call this procedure more than once. You don’t want it to have any leftover value the second time the procedure is called.

---

## 6.11.2 Exercise Descriptions

### ★ 1. Filling an Array

Create a procedure that fills an array of doublewords with N random integers, making sure the values fall within the range j...k, inclusive. When calling the procedure, pass a pointer to the array that will hold the data, pass N, and pass the values of j and k. Preserve all register values between calls to the procedure. Write a test program that calls the procedure twice, using different values for j and k. Verify your results using a debugger.

> 답:

```asm
INCLUDE Irvine32.inc

.data
arrayA  SDWORD 10 DUP(?)
arrayB  SDWORD 12 DUP(?)
msgA    BYTE "Array A (10 values, range 20..40):",0dh,0ah,0
msgB    BYTE "Array B (12 values, range -50..50):",0dh,0ah,0

.code
main PROC
    call Randomize                  ; seed the random number generator once

    ; ---- first call: j = 20, k = 40 ----
    mov  esi,OFFSET arrayA          ; ESI = pointer to array
    mov  ecx,LENGTHOF arrayA        ; ECX = N
    mov  ebx,20                     ; EBX = j (minimum)
    mov  edx,40                     ; EDX = k (maximum)
    call FillArray

    mov  edx,OFFSET msgA
    call WriteString
    mov  esi,OFFSET arrayA
    mov  ecx,LENGTHOF arrayA
    call ShowArray

    ; ---- second call: j = -50, k = 50 (negative values included) ----
    mov  esi,OFFSET arrayB
    mov  ecx,LENGTHOF arrayB
    mov  ebx,-50
    mov  edx,50
    call FillArray

    mov  edx,OFFSET msgB
    call WriteString
    mov  esi,OFFSET arrayB
    mov  ecx,LENGTHOF arrayB
    call ShowArray

    exit
main ENDP

;-----------------------------------------------------------
FillArray PROC
; Fills a doubleword array with N random integers in range j..k.
; Receives: ESI = offset of the array
;           ECX = N (number of elements)
;           EBX = j (minimum value, signed)
;           EDX = k (maximum value, signed)
; Returns:  nothing (all registers are preserved)
;-----------------------------------------------------------
    pushad                          ; save all registers
    jecxz Done                      ; N = 0: nothing to do

    mov  eax,edx
    sub  eax,ebx
    inc  eax                        ; EAX = k - j + 1 = size of the range
    mov  edx,eax                    ; keep range size in EDX

L1:
    mov  eax,edx                    ; EAX = range size
    call RandomRange                ; EAX = random value 0 .. range-1
    add  eax,ebx                    ; shift into j .. k
    mov  [esi],eax                  ; store in array
    add  esi,TYPE SDWORD            ; next element
    loop L1

Done:
    popad                           ; restore all registers
    ret
FillArray ENDP

;-----------------------------------------------------------
ShowArray PROC
; Displays a signed doubleword array on one line.
; Receives: ESI = offset of the array, ECX = number of elements
;-----------------------------------------------------------
    pushad
    jecxz Done
L1:
    mov  eax,[esi]
    call WriteInt
    mov  al,' '
    call WriteChar
    add  esi,TYPE SDWORD
    loop L1
Done:
    call Crlf
    popad
    ret
ShowArray ENDP

END main
```

### ★★ 2. Summing Array Elements in a Range

Create a procedure that returns the sum of all array elements falling within the range j...k (inclusive). Write a test program that calls the procedure twice, passing a pointer to a signed doubleword array, the size of the array, and the values of j and k. Return the sum in the EAX register, and preserve all other register values between calls to the procedure.

> 답:

```asm
INCLUDE Irvine32.inc

.data
array   SDWORD -20,-5,0,7,12,25,40,-13,8,100
msg1    BYTE "Sum of elements in 0..20   = ",0
msg2    BYTE "Sum of elements in -15..10 = ",0

.code
main PROC
    ; ---- first call: j = 0, k = 20  -> 0 + 7 + 12 + 8 = 27 ----
    mov  esi,OFFSET array
    mov  ecx,LENGTHOF array
    mov  ebx,0
    mov  edx,20
    call SumInRange
    mov  edx,OFFSET msg1
    call WriteString
    call WriteInt                   ; EAX = sum
    call Crlf

    ; ---- second call: j = -15, k = 10 -> -5 + 0 + 7 + -13 + 8 = -3 ----
    mov  esi,OFFSET array
    mov  ecx,LENGTHOF array
    mov  ebx,-15
    mov  edx,10
    call SumInRange
    mov  edx,OFFSET msg2
    call WriteString
    call WriteInt
    call Crlf

    exit
main ENDP

;-----------------------------------------------------------
SumInRange PROC
; Sums the elements of a signed doubleword array that lie in j..k.
; Receives: ESI = offset of the array
;           ECX = number of elements
;           EBX = j (minimum, signed)
;           EDX = k (maximum, signed)
; Returns:  EAX = sum (all other registers preserved)
;-----------------------------------------------------------
    push esi
    push ecx

    mov  eax,0                      ; sum = 0
    jecxz Done                      ; empty array

L1:
    cmp  SDWORD PTR [esi],ebx       ; element < j ?
    jl   Skip                       ; yes: not in range
    cmp  SDWORD PTR [esi],edx       ; element > k ?
    jg   Skip                       ; yes: not in range
    add  eax,[esi]                  ; in range: add to sum
Skip:
    add  esi,TYPE SDWORD            ; next element
    loop L1

Done:
    pop  ecx
    pop  esi
    ret
SumInRange ENDP

END main
```

### ★★ 3. Test Score Evaluation

Create a procedure named CalcGrade that receives an integer value between 0 and 100, and returns a single capital letter in the AL register. Preserve all other register values between calls to the procedure. The letter returned by the procedure should be according to the following ranges:

| Score Range | Letter Grade |
| :---------: | :----------: |
|  90 to 100  |      A       |
|  80 to 89   |      B       |
|  70 to 79   |      C       |
|  60 to 69   |      D       |
|   0 to 59   |      F       |

Write a test program that generates 10 random integers between 50 and 100, inclusive. Each time an integer is generated, pass it to the CalcGrade procedure. You can test your program using a debugger, or if you prefer to use the book’s library, you can display each integer and its corresponding letter grade. (The Irvine32 library is required for this solution program because it uses the RandomRange procedure.)

> 답:

```asm
INCLUDE Irvine32.inc

.data
msgSep  BYTE "  ->  ",0

.code
main PROC
    call Randomize
    mov  ecx,10                     ; generate 10 scores

L1:
    mov  eax,51
    call RandomRange                ; EAX = 0..50
    add  eax,50                     ; EAX = 50..100
    call WriteDec                   ; display the score (EAX is preserved)

    mov  edx,OFFSET msgSep
    call WriteString

    call CalcGrade                  ; AL = letter grade
    call WriteChar                  ; display the letter
    call Crlf
    loop L1

    exit
main ENDP

;-----------------------------------------------------------
CalcGrade PROC
; Converts a numeric score into a letter grade.
; Receives: AL = score (0..100)
; Returns:  AL = 'A', 'B', 'C', 'D' or 'F'
;           (all other registers are untouched)
;-----------------------------------------------------------
    cmp  al,90
    jae  GradeA                     ; score >= 90
    cmp  al,80
    jae  GradeB                     ; score >= 80
    cmp  al,70
    jae  GradeC                     ; score >= 70
    cmp  al,60
    jae  GradeD                     ; score >= 60
    mov  al,'F'                     ; otherwise 0..59
    jmp  Done
GradeA:
    mov  al,'A'
    jmp  Done
GradeB:
    mov  al,'B'
    jmp  Done
GradeC:
    mov  al,'C'
    jmp  Done
GradeD:
    mov  al,'D'
Done:
    ret
CalcGrade ENDP

END main
```

### ★★ 4. College Registration

Using the College Registration example from Section 6.7.3 as a starting point, do the following:

- Recode the logic using CMP and conditional jump instructions (instead of the .IF and .ELSEIF directives).
- Perform range checking on the credits value; it cannot be less than 1 or greater than 30. If an invalid entry is discovered, display an appropriate error message.
- Prompt the user for the grade average and credits values.
- Display a message that shows the outcome of the evaluation, such as “The student can register” or “The student cannot register”.

(The Irvine32 library is required for this solution program.)

> 답:

```asm
INCLUDE Irvine32.inc

.data
promptAvg   BYTE "Enter grade average (0 to 400): ",0
promptCred  BYTE "Enter number of credits (1 to 30): ",0
msgBadAvg   BYTE "Error: grade average must be between 0 and 400.",0dh,0ah,0
msgBadCred  BYTE "Error: credits must be between 1 and 30.",0dh,0ah,0
msgCan      BYTE "The student can register",0dh,0ah,0
msgCannot   BYTE "The student cannot register",0dh,0ah,0

gradeAverage WORD ?
credits      WORD ?

.code
main PROC
    ; ---- input ----
    mov  edx,OFFSET promptAvg
    call WriteString
    call ReadInt                    ; EAX = grade average
    mov  gradeAverage,ax

    mov  edx,OFFSET promptCred
    call WriteString
    call ReadInt                    ; EAX = credits
    mov  credits,ax

    ; ---- range checking (negative numbers become large unsigned values) ----
    cmp  gradeAverage,400
    ja   BadAverage                 ; > 400 (or negative)
    cmp  credits,1
    jb   BadCredits                 ; < 1
    cmp  credits,30
    ja   BadCredits                 ; > 30 (or negative)

    ; ---- registration logic with CMP and conditional jumps ----
    cmp  gradeAverage,350           ; gradeAverage > 350 ?
    ja   CanRegister                ; yes: can register

    cmp  gradeAverage,250           ; (gradeAverage > 250) AND (credits <= 16) ?
    jbe  Check3                     ; first part false: try next rule
    cmp  credits,16
    jbe  CanRegister                ; both true: can register

Check3:
    cmp  credits,12                 ; credits <= 12 ?
    jbe  CanRegister                ; yes: can register

CannotRegister:
    mov  edx,OFFSET msgCannot
    jmp  ShowMsg

CanRegister:
    mov  edx,OFFSET msgCan
    jmp  ShowMsg

BadAverage:
    mov  edx,OFFSET msgBadAvg
    jmp  ShowMsg

BadCredits:
    mov  edx,OFFSET msgBadCred

ShowMsg:
    call WriteString
    exit
main ENDP

END main
```

### ★★★ 5. Boolean Calculator (1)

Create a program that functions as a simple boolean calculator for 32-bit integers. It should display a menu that asks the user to make a selection from the following list:

1. x AND y
2. x OR y
3. NOT x
4. x XOR y
5. Exit program

When the user makes a choice, call a procedure that displays the name of the operation about to be performed. You must implement this procedure using the Table-Driven Selection technique, shown in Section 6.5.4. (You will implement the operations in Exercise 6.) (The Irvine32 library is required for this solution program.)

> 답:

```asm
INCLUDE Irvine32.inc

.data
menuText    BYTE 0dh,0ah
            BYTE "1. x AND y",0dh,0ah
            BYTE "2. x OR y",0dh,0ah
            BYTE "3. NOT x",0dh,0ah
            BYTE "4. x XOR y",0dh,0ah
            BYTE "5. Exit program",0dh,0ah
            BYTE "Choose (1-5): ",0

nameAND     BYTE "Operation: x AND y",0dh,0ah,0
nameOR      BYTE "Operation: x OR y",0dh,0ah,0
nameNOT     BYTE "Operation: NOT x",0dh,0ah,0
nameXOR     BYTE "Operation: x XOR y",0dh,0ah,0
nameExit    BYTE "Exiting program...",0dh,0ah,0
msgInvalid  BYTE "Invalid choice. Please enter 1 to 5.",0dh,0ah,0

; Table of lookup values (menu keys) and procedure offsets.
CaseTable   BYTE '1'
            DWORD Show_AND
EntrySize = ($ - CaseTable)             ; size of one table entry (5 bytes)
            BYTE '2'
            DWORD Show_OR
            BYTE '3'
            DWORD Show_NOT
            BYTE '4'
            DWORD Show_XOR
            BYTE '5'
            DWORD Show_Exit
NumberOfEntries = ($ - CaseTable) / EntrySize

choice      BYTE ?

.code
main PROC
MenuLoop:
    mov  edx,OFFSET menuText
    call WriteString
    call ReadChar                   ; AL = key pressed
    call WriteChar                  ; echo it
    call Crlf
    mov  choice,al                  ; remember the choice
    call SelectOperation            ; table-driven: show the operation name
    cmp  choice,'5'
    jne  MenuLoop                   ; repeat until the user chooses Exit
    exit
main ENDP

;-----------------------------------------------------------
SelectOperation PROC
; Searches CaseTable for the key in AL and calls the matching procedure.
; Receives: AL = menu key character
; Returns:  nothing (registers preserved)
;-----------------------------------------------------------
    pushad
    mov  ebx,OFFSET CaseTable       ; EBX points to the table
    mov  ecx,NumberOfEntries        ; loop counter
L1:
    cmp  al,[ebx]                   ; match found?
    jne  L2                         ; no: continue
    call NEAR PTR [ebx + 1]         ; yes: call the procedure whose address follows the key
    jmp  Done
L2:
    add  ebx,EntrySize              ; point to the next entry
    loop L1
    mov  edx,OFFSET msgInvalid      ; no entry matched
    call WriteString
Done:
    popad
    ret
SelectOperation ENDP

;-----------------------------------------------------------
; Each procedure displays the name of its operation.
;-----------------------------------------------------------
Show_AND PROC
    mov  edx,OFFSET nameAND
    call WriteString
    ret
Show_AND ENDP

Show_OR PROC
    mov  edx,OFFSET nameOR
    call WriteString
    ret
Show_OR ENDP

Show_NOT PROC
    mov  edx,OFFSET nameNOT
    call WriteString
    ret
Show_NOT ENDP

Show_XOR PROC
    mov  edx,OFFSET nameXOR
    call WriteString
    ret
Show_XOR ENDP

Show_Exit PROC
    mov  edx,OFFSET nameExit
    call WriteString
    ret
Show_Exit ENDP

END main
```

### ★★★ 6. Boolean Calculator (2)

Continue the solution program from Exercise 5 by implementing the following procedures:

- AND_op: Prompt the user for two hexadecimal integers. AND them together and display the result in hexadecimal.
- OR_op: Prompt the user for two hexadecimal integers. OR them together and display the result in hexadecimal.
- NOT_op: Prompt the user for a hexadecimal integer. NOT the integer and display the result in hexadecimal.
- XOR_op: Prompt the user for two hexadecimal integers. Exclusive-OR them together and display the result in hexadecimal.

(The Irvine32 library is required for this solution program.)

> 답: 연습 5의 프로그램을 확장한 전체 코드.

```asm
INCLUDE Irvine32.inc

.data
menuText    BYTE 0dh,0ah
            BYTE "1. x AND y",0dh,0ah
            BYTE "2. x OR y",0dh,0ah
            BYTE "3. NOT x",0dh,0ah
            BYTE "4. x XOR y",0dh,0ah
            BYTE "5. Exit program",0dh,0ah
            BYTE "Choose (1-5): ",0

nameAND     BYTE "Operation: x AND y",0dh,0ah,0
nameOR      BYTE "Operation: x OR y",0dh,0ah,0
nameNOT     BYTE "Operation: NOT x",0dh,0ah,0
nameXOR     BYTE "Operation: x XOR y",0dh,0ah,0
nameExit    BYTE "Exiting program...",0dh,0ah,0
msgInvalid  BYTE "Invalid choice. Please enter 1 to 5.",0dh,0ah,0

promptX     BYTE "Enter hexadecimal integer x: ",0
promptY     BYTE "Enter hexadecimal integer y: ",0
msgResult   BYTE "Result (hex): ",0

; Table of menu keys and procedure offsets.
CaseTable   BYTE '1'
            DWORD AND_op
EntrySize = ($ - CaseTable)
            BYTE '2'
            DWORD OR_op
            BYTE '3'
            DWORD NOT_op
            BYTE '4'
            DWORD XOR_op
            BYTE '5'
            DWORD Exit_op
NumberOfEntries = ($ - CaseTable) / EntrySize

choice      BYTE ?

.code
main PROC
MenuLoop:
    mov  edx,OFFSET menuText
    call WriteString
    call ReadChar
    call WriteChar
    call Crlf
    mov  choice,al
    call SelectOperation            ; table-driven dispatch
    cmp  choice,'5'
    jne  MenuLoop
    exit
main ENDP

;-----------------------------------------------------------
SelectOperation PROC
; Receives: AL = menu key. Calls the procedure found in CaseTable.
;-----------------------------------------------------------
    pushad
    mov  ebx,OFFSET CaseTable
    mov  ecx,NumberOfEntries
L1:
    cmp  al,[ebx]
    jne  L2
    call NEAR PTR [ebx + 1]
    jmp  Done
L2:
    add  ebx,EntrySize
    loop L1
    mov  edx,OFFSET msgInvalid
    call WriteString
Done:
    popad
    ret
SelectOperation ENDP

;-----------------------------------------------------------
AND_op PROC
; Reads two hex integers, ANDs them, displays the result in hex.
;-----------------------------------------------------------
    pushad
    mov  edx,OFFSET nameAND
    call WriteString
    mov  edx,OFFSET promptX
    call WriteString
    call ReadHex                    ; EAX = x
    mov  ebx,eax                    ; keep x in EBX
    mov  edx,OFFSET promptY
    call WriteString
    call ReadHex                    ; EAX = y
    and  eax,ebx                    ; EAX = y AND x
    mov  edx,OFFSET msgResult
    call WriteString
    call WriteHex
    call Crlf
    popad
    ret
AND_op ENDP

;-----------------------------------------------------------
OR_op PROC
; Reads two hex integers, ORs them, displays the result in hex.
;-----------------------------------------------------------
    pushad
    mov  edx,OFFSET nameOR
    call WriteString
    mov  edx,OFFSET promptX
    call WriteString
    call ReadHex
    mov  ebx,eax
    mov  edx,OFFSET promptY
    call WriteString
    call ReadHex
    or   eax,ebx                    ; EAX = y OR x
    mov  edx,OFFSET msgResult
    call WriteString
    call WriteHex
    call Crlf
    popad
    ret
OR_op ENDP

;-----------------------------------------------------------
NOT_op PROC
; Reads one hex integer, inverts all its bits, displays the result in hex.
;-----------------------------------------------------------
    pushad
    mov  edx,OFFSET nameNOT
    call WriteString
    mov  edx,OFFSET promptX
    call WriteString
    call ReadHex                    ; EAX = x
    not  eax                        ; EAX = NOT x
    mov  edx,OFFSET msgResult
    call WriteString
    call WriteHex
    call Crlf
    popad
    ret
NOT_op ENDP

;-----------------------------------------------------------
XOR_op PROC
; Reads two hex integers, XORs them, displays the result in hex.
;-----------------------------------------------------------
    pushad
    mov  edx,OFFSET nameXOR
    call WriteString
    mov  edx,OFFSET promptX
    call WriteString
    call ReadHex
    mov  ebx,eax
    mov  edx,OFFSET promptY
    call WriteString
    call ReadHex
    xor  eax,ebx                    ; EAX = y XOR x
    mov  edx,OFFSET msgResult
    call WriteString
    call WriteHex
    call Crlf
    popad
    ret
XOR_op ENDP

;-----------------------------------------------------------
Exit_op PROC
; Menu item 5: just announce the exit (main loop ends afterwards).
;-----------------------------------------------------------
    mov  edx,OFFSET nameExit
    call WriteString
    ret
Exit_op ENDP

END main
```

### ★★ 7. Probabilities and Colors

Write a program that randomly chooses among three different colors for displaying text on the screen. Use a loop to display 20 lines of text, each with a randomly chosen color. The probabilities for each color are to be as follows: white = 30%, blue = 10%, green = 60%.

Suggestion: Generate a random integer between 0 and 9. If the resulting integer falls in the range 0 to 2 (inclusive), choose white. If the integer equals 3, choose blue. If the integer falls in the range 4 to 9 (inclusive), choose green. Test your program by running it ten times, each time observing whether the distribution of line colors appears to match the required probabilities. (The Irvine32 library is required for this solution program.)

> 답:

```asm
INCLUDE Irvine32.inc

.data
msgLine     BYTE "Line ",0
msgText     BYTE ": This line has a randomly chosen color.",0dh,0ah,0
msgWhite    BYTE "White lines: ",0
msgBlue     BYTE "Blue lines:  ",0
msgGreen    BYTE "Green lines: ",0
whiteCount  DWORD 0
blueCount   DWORD 0
greenCount  DWORD 0

.code
main PROC
    call Randomize
    mov  esi,1                      ; ESI = line number (1..20)

L1:
    mov  eax,10
    call RandomRange                ; EAX = 0..9
    cmp  eax,2
    jbe  UseWhite                   ; 0..2  -> white (30%)
    cmp  eax,3
    je   UseBlue                    ; 3     -> blue  (10%)

    ; 4..9 -> green (60%)
    inc  greenCount
    mov  eax,green + (black * 16)
    jmp  ApplyColor

UseWhite:
    inc  whiteCount
    mov  eax,white + (black * 16)
    jmp  ApplyColor

UseBlue:
    inc  blueCount
    mov  eax,blue + (black * 16)

ApplyColor:
    call SetTextColor               ; EAX = foreground + background*16

    mov  edx,OFFSET msgLine
    call WriteString
    mov  eax,esi
    call WriteDec                   ; line number
    mov  edx,OFFSET msgText
    call WriteString

    inc  esi
    cmp  esi,20
    jbe  L1                         ; repeat for lines 1..20

    ; restore the default color and show the counts for checking the odds
    mov  eax,white + (black * 16)
    call SetTextColor
    call Crlf

    mov  edx,OFFSET msgWhite
    call WriteString
    mov  eax,whiteCount
    call WriteDec
    call Crlf

    mov  edx,OFFSET msgBlue
    call WriteString
    mov  eax,blueCount
    call WriteDec
    call Crlf

    mov  edx,OFFSET msgGreen
    call WriteString
    mov  eax,greenCount
    call WriteDec
    call Crlf

    exit
main ENDP

END main
```

### ★★★ 8. Message Encryption

Revise the encryption program in Section 6.3.4 in the following manner: Create an encryption key consisting of multiple characters. Use this key to encrypt and decrypt the plaintext by XOR-ing each character of the key against a corresponding byte in the message. Repeat the key as many times as necessary until all plain text bytes are translated. Suppose, for example, the key were equal to “ABXmv#7”. This is how the key would align with the plain text bytes:

```text
Plain text  T h i s       i s     a     P l a i n t e x t       m e s s a g e (etc.)
Key         A B X m v     # 7 A B X m v # 7 A B X m v # 7 A B X m v # 7
```

(The key repeats until it equals the length of the plain text...)

> 답:

```asm
INCLUDE Irvine32.inc

BUFMAX = 128                        ; maximum buffer size

.data
key         BYTE "ABXmv#7"          ; multi-character encryption key
KEYSIZE = ($ - key)                 ; number of key characters (7)

sPrompt     BYTE "Enter the plain text: ",0
sEncrypt    BYTE "Cipher text (hex bytes): ",0
sDecrypt    BYTE "Decrypted:               ",0
buffer      BYTE BUFMAX+1 DUP(0)
bufSize     DWORD ?

.code
main PROC
    call InputTheString             ; input the plain text
    call TranslateBuffer            ; encrypt the buffer
    call ShowCipherHex              ; cipher bytes may be 0 or unprintable -> show in hex
    call TranslateBuffer            ; decrypt the buffer (same operation)
    mov  edx,OFFSET sDecrypt
    call DisplayMessage
    exit
main ENDP

;-----------------------------------------------------------
InputTheString PROC
; Prompts the user for a plaintext string. Saves the string and its length.
;-----------------------------------------------------------
    pushad
    mov  edx,OFFSET sPrompt
    call WriteString
    mov  ecx,BUFMAX                 ; maximum character count
    mov  edx,OFFSET buffer          ; point to the buffer
    call ReadString                 ; EAX = number of characters read
    mov  bufSize,eax                ; save the length
    call Crlf
    popad
    ret
InputTheString ENDP

;-----------------------------------------------------------
DisplayMessage PROC
; Displays a message (EDX) followed by the buffer as text.
;-----------------------------------------------------------
    pushad
    call WriteString
    mov  edx,OFFSET buffer
    call WriteString
    call Crlf
    call Crlf
    popad
    ret
DisplayMessage ENDP

;-----------------------------------------------------------
ShowCipherHex PROC
; Displays every byte of the buffer as two hex digits.
;-----------------------------------------------------------
    pushad
    mov  edx,OFFSET sEncrypt
    call WriteString
    mov  ecx,bufSize
    jecxz Done
    mov  esi,0
L1:
    movzx eax,buffer[esi]           ; one cipher byte
    mov  ebx,1                      ; size = 1 byte
    call WriteHexB                  ; display as hex
    mov  al,' '
    call WriteChar
    inc  esi
    loop L1
Done:
    call Crlf
    call Crlf
    popad
    ret
ShowCipherHex ENDP

;-----------------------------------------------------------
TranslateBuffer PROC
; Encrypts/decrypts the buffer by XORing each byte with the next key
; character; the key restarts from its first character after the last one.
; Receives: nothing   Returns: nothing
;-----------------------------------------------------------
    pushad
    mov  ecx,bufSize                ; loop counter = message length
    jecxz Done                      ; empty message
    mov  esi,0                      ; ESI = index into buffer
    mov  edi,0                      ; EDI = index into key
L1:
    mov  al,key[edi]                ; current key character
    xor  buffer[esi],al             ; translate one byte
    inc  esi                        ; next message byte
    inc  edi                        ; next key character
    cmp  edi,KEYSIZE                ; reached the end of the key?
    jb   L2
    mov  edi,0                      ; yes: wrap around to the start of the key
L2:
    loop L1
Done:
    popad
    ret
TranslateBuffer ENDP

END main
```

### ★★ 9. Validating a PIN

Banks use a Personal Identification Number (PIN) to uniquely identify each customer. Let us assume that our bank has a specified range of acceptable values for each digit in its customers’ 5-digit PINs. The table shown below contains the acceptable ranges, where digits are numbered from left to right in the PIN. Then we can see that the PIN 52413 is valid. But the PIN 43534 is invalid because the first digit is out of range. Similarly, 64535 is invalid because of its last digit.

| Digit Number | Range  |
| :----------: | :----: |
|      1       | 5 to 9 |
|      2       | 2 to 5 |
|      3       | 4 to 8 |
|      4       | 1 to 4 |
|      5       | 3 to 6 |

Your task is to create a procedure named Validate_PIN that receives a pointer to an array of byte containing a 5-digit PIN. Declare two arrays to hold the minimum and maximum range values, and use these arrays to validate each digit of the PIN that was passed to the procedure. If any digit is found to be outside its valid range, immediately return the digit’s position (between 1 and 5) in the EAX register. If the entire PIN is valid, return 0 in EAX. Preserve all other register values between calls to the procedure. Write a test program that calls Validate_PIN at least four times, using both valid and invalid byte arrays. By running the program in a debugger, verify that the return value in EAX after each procedure call is valid. Or, if you prefer to use the book’s library, you can display “Valid” or “Invalid” on the console after each procedure call.

> 답:

```asm
INCLUDE Irvine32.inc

PIN_LEN = 5

.data
minDigits   BYTE 5,2,4,1,3          ; minimum allowed value of digits 1..5
maxDigits   BYTE 9,5,8,4,6          ; maximum allowed value of digits 1..5

; Test PINs (each digit stored as a number 0..9)
pin1        BYTE 5,2,4,1,3          ; 52413 : valid
pin2        BYTE 4,3,5,3,4          ; 43534 : digit 1 out of range
pin3        BYTE 5,9,5,3,4          ; 59534 : digit 2 out of range
pin4        BYTE 5,2,4,0,3          ; 52403 : digit 4 out of range
pin5        BYTE 5,2,4,1,7          ; 52417 : digit 5 out of range
pin6        BYTE 6,4,5,3,5          ; 64535 : valid by the table above

msgPin      BYTE "PIN #",0
msgValid    BYTE ": Valid",0dh,0ah,0
msgInvalid  BYTE ": Invalid, digit position out of range = ",0

.code
main PROC
    mov  esi,OFFSET pin1
    mov  ebx,1
    call TestPin
    mov  esi,OFFSET pin2
    mov  ebx,2
    call TestPin
    mov  esi,OFFSET pin3
    mov  ebx,3
    call TestPin
    mov  esi,OFFSET pin4
    mov  ebx,4
    call TestPin
    mov  esi,OFFSET pin5
    mov  ebx,5
    call TestPin
    mov  esi,OFFSET pin6
    mov  ebx,6
    call TestPin
    exit
main ENDP

;-----------------------------------------------------------
TestPin PROC
; Calls Validate_PIN and prints the outcome.
; Receives: ESI = offset of the PIN, EBX = test number
;-----------------------------------------------------------
    pushad
    mov  edx,OFFSET msgPin
    call WriteString
    mov  eax,ebx
    call WriteDec                   ; test number
    call Validate_PIN               ; EAX = 0 (valid) or failing position
    cmp  eax,0
    jne  Bad
    mov  edx,OFFSET msgValid
    call WriteString
    jmp  Done
Bad:
    mov  edx,OFFSET msgInvalid
    call WriteString
    call WriteDec                   ; position of the bad digit
    call Crlf
Done:
    popad
    ret
TestPin ENDP

;-----------------------------------------------------------
Validate_PIN PROC
; Checks each digit of a 5-digit PIN against minDigits/maxDigits.
; Receives: ESI = offset of the PIN (5 bytes, each 0..9)
; Returns:  EAX = 0 if every digit is in range,
;           otherwise EAX = position (1..5) of the first bad digit.
; All other registers are preserved.
;-----------------------------------------------------------
    push ebx
    push ecx

    mov  ebx,0                      ; EBX = digit index (0..4)
    mov  ecx,PIN_LEN                ; loop counter
L1:
    mov  al,[esi+ebx]               ; current digit
    cmp  al,minDigits[ebx]
    jb   BadDigit                   ; below the minimum
    cmp  al,maxDigits[ebx]
    ja   BadDigit                   ; above the maximum
    inc  ebx                        ; next digit
    loop L1

    mov  eax,0                      ; all digits valid
    jmp  Done

BadDigit:
    mov  eax,ebx
    inc  eax                        ; convert index (0-based) to position (1-based)

Done:
    pop  ecx
    pop  ebx
    ret
Validate_PIN ENDP

END main
```

### ★★★★ 10. Parity Checking

Data transmission systems and file subsystems often use a form of error detection that relies on calculating the parity (even or odd) of blocks of data. Your task is to create a procedure that returns True in the EAX register if the bytes in an array contain even parity, or False if the parity is odd. In other words, if you count all the bits in the entire array, their count will be even or odd. Preserve all other register values between calls to the procedure. Write a test program that calls your procedure twice, each time passing it a pointer to an array and the length of the array. The procedure’s return value in EAX should be 1 (True) or 0 (False). For test data, create two arrays containing at least 10 bytes, one having even parity, and another having odd parity.

Tip: Earlier in this chapter, we showed how you can repeatedly apply the XOR instruction to a sequence of byte values to determine their parity. So, this suggests the use of a loop. But be careful, since some machine instructions affect the Parity flag, and others do not. You can find this out by looking at the individual instructions in Appendix B. The code in your loop that checks the parity will have to carefully save and restore the state of the Parity flag to avoid having it unintentionally modified by your code.

> 답:

```asm
INCLUDE Irvine32.inc

.data
; Number of 1 bits: 1+2+3+4+5+6+7+8+0+2 = 38 (even)
evenArray   BYTE 01h,03h,07h,0Fh,1Fh,3Fh,7Fh,0FFh,00h,81h
; Number of 1 bits: 1+2+3+4+5+6+7+8+0+1 = 37 (odd)
oddArray    BYTE 01h,03h,07h,0Fh,1Fh,3Fh,7Fh,0FFh,00h,80h

msgEven     BYTE "evenArray -> EAX = ",0
msgOdd      BYTE "oddArray  -> EAX = ",0
msgTrue     BYTE "  (True: even parity)",0dh,0ah,0
msgFalse    BYTE "  (False: odd parity)",0dh,0ah,0

.code
main PROC
    ; ---- test 1: even parity ----
    mov  esi,OFFSET evenArray
    mov  ecx,LENGTHOF evenArray
    call ParityCheck
    mov  edx,OFFSET msgEven
    call WriteString
    call WriteDec                   ; 1 expected
    cmp  eax,1
    jne  Test1False
    mov  edx,OFFSET msgTrue
    jmp  Show1
Test1False:
    mov  edx,OFFSET msgFalse
Show1:
    call WriteString

    ; ---- test 2: odd parity ----
    mov  esi,OFFSET oddArray
    mov  ecx,LENGTHOF oddArray
    call ParityCheck
    mov  edx,OFFSET msgOdd
    call WriteString
    call WriteDec                   ; 0 expected
    cmp  eax,1
    jne  Test2False
    mov  edx,OFFSET msgTrue
    jmp  Show2
Test2False:
    mov  edx,OFFSET msgFalse
Show2:
    call WriteString

    exit
main ENDP

;-----------------------------------------------------------
ParityCheck PROC
; Determines whether the whole array has an even number of 1 bits.
; Receives: ESI = offset of a byte array, ECX = length of the array
; Returns:  EAX = 1 (True) if the total number of 1 bits is even,
;           EAX = 0 (False) if it is odd.
; All other registers are preserved.
; Idea: XOR of all bytes has the same parity as the whole array.
;-----------------------------------------------------------
    push esi
    push ecx
    push edx

    mov  dl,0                       ; DL = running XOR of all bytes
    jecxz Check                     ; empty array: DL = 0 -> even parity

L1:
    xor  dl,[esi]                   ; fold the next byte into DL
    inc  esi                        ; (INC changes PF, so PF is read only after the loop)
    loop L1                         ; LOOP does not change any flag

Check:
    or   dl,dl                      ; set PF from the final XOR value
    jp   IsEven                     ; PF = 1: even number of 1 bits
    mov  eax,0                      ; odd parity -> False
    jmp  Done
IsEven:
    mov  eax,1                      ; even parity -> True

Done:
    pop  edx
    pop  ecx
    pop  esi
    ret
ParityCheck ENDP

END main
```
