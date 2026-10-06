# 1001 과제 - 4.9 Review Questions and Exercises

## 4.9.1 Short Answer

**1.** What will be the value in EDX after each of the lines marked (a) and (b) execute?

```asm
.data
one WORD 8002h
two WORD 4321h
.code
mov edx,21348041h
movsx edx,one ; (a)
movsx edx,two ; (b)
```

**답:** a줄 실행되면 `FFFF8002h`, b줄 실행되면 `00004321h`이다. `MOVSX`는 부호 확장을 수행한다.

---

**2.** What will be the value in EAX after the following lines execute?

```asm
mov eax,1002FFFFh
inc ax
```

**답:** `10020000h`이다. `INC AX`에서 `FFFFh`가 `0000h`로 증가하고 EAX의 상위 16비트는 그대로이다.

---

**3.** What will be the value in EAX after the following lines execute?

```asm
mov eax,30020000h
dec ax
```

**답:** `3002FFFFh`이다. `DEC AX`에서 `0000h`가 `FFFFh`로 감소한다.

---

**4.** What will be the value in EAX after the following lines execute?

```asm
mov eax,1002FFFFh
neg ax
```

**답:** `10020001h`이다. `NEG`는 2의 보수를 취하므로 `FFFFh`가 `0001h`가 된다.

---

**5.** What will be the value of the Parity flag after the following lines execute?

```asm
mov al,1
add al,3
```

**답:** `PF = 1`이다. 결과 `AL = 04h`이고 1의 개수가 짝수이므로 Parity flag가 설정된다.

---

**6.** What will be the value of EAX and the Sign flag after the following lines execute?

```asm
mov eax,5
sub eax,6
```

**답:** `EAX = FFFFFFFFh`, `SF = 1`이다. 결과가 `-1`이므로 Sign flag가 설정된다.

---

**7.** In the following code, the value in AL is intended to be a signed byte. Explain how the Overflow flag helps, or does not help you, to determine whether the final value in AL falls within a valid signed range.

```asm
mov al,-1
add al,130
```

**답:** `AL = 81h`이고 signed 값으로 `-127`이다. `OF = 0`이며, 양수와 음수를 더한 경우에는 Overflow flag만으로 유효 범위를 판단할 수 있는 문제가 발생하지 않는다.

---

**8.** What value will RAX contain after the following instruction executes?

```asm
mov rax,44445555h
```

**답:** `0000000044445555h`이다.

---

**9.** What value will RAX contain after the following instructions execute?

```asm
.data
dwordVal DWORD 84326732h
.code
mov rax,0FFFFFFFF00000000h
mov rax,dwordVal
```

**답:** `0000000084326732h`이다. DWORD 값을 RAX로 이동하면 상위 32비트가 0으로 확장된다.

---

**10.** What value will EAX contain after the following instructions execute?

```asm
.data
dVal DWORD 12345678h
.code
mov ax,3
mov WORD PTR dVal+2,ax
mov eax,dVal
```

**답:** `00035678h`이다. 정확히 계산하면 `dVal+2`에 `0003h`를 저장하므로 원래 `12345678h`의 상위 WORD `1234h`가 `0003h`로 바뀐다.

---

**11.** What will EAX contain after the following instructions execute?

```asm
.data
dVal DWORD ?
.code
mov dVal,12345678h
mov ax,WORD PTR dVal+2
add ax,3
mov WORD PTR dVal,ax
mov eax,dVal
```

**답:** `1234567Bh`이다. 상위 WORD `5678h`에 3을 더한 `567Bh`를 하위 WORD에 저장한다.

---

**12.** (Yes/No): Is it possible to set the Overflow flag if you add a positive integer to a negative integer?

**답:** No. 서로 부호가 다른 두 정수를 더할 때 signed overflow는 발생하지 않는다.

---

**13.** (Yes/No): Will the Overflow flag be set if you add a negative integer to a negative integer and produce a positive result?

**답:** Yes. 음수 + 음수가 양수가 되었다면 signed overflow가 발생한 것이다.

---

**14.** (Yes/No): Is it possible for the NEG instruction to set the Overflow flag?

**답:** Yes. 최소 음수값을 `NEG`할 때 Overflow flag가 설정될 수 있다.

---

**15.** (Yes/No): Is it possible for both the Sign and Zero flags to be set at the same time?

**답:** No. 결과가 0이면 Sign flag는 0이고 Zero flag는 1이다.

---

**16–19.**
Use the following variable definitions for Questions 16–19:

```asm
.data
var1 SBYTE -4,-2,3,1
var2 WORD 1000h,2000h,3000h,4000h
var3 SWORD -16,-42
var4 DWORD 1,2,3,4,5
```

---

**16.** For each of the following statements, state whether or not the instruction is valid:

```asm
a. mov ax,var1
b. mov ax,var2
c. mov eax,var3
d. mov var2,var3
e. movzx ax,var2
f. movzx var2,al
g. mov ds,ax
h. mov ds,1000h
```

```text
답:
a. No  - SBYTE와 AX의 크기가 다르다.
b. Yes - WORD와 AX의 크기가 같다.
c. No  - SWORD와 EAX의 크기가 다르다.
d. No  - 메모리끼리 직접 MOV할 수 없다.
e. No  - MOVZX는 destination이 source보다 커야 한다.
f. No  - MOVZX의 destination은 register여야 한다.
g. Yes - AX의 값을 DS로 이동할 수 있다.
h. No  - segment register에는 immediate 값을 직접 MOV할 수 없다.
```

---

**17.** What will be the hexadecimal value of the destination operand after each of the following instructions execute in sequence?

```asm
mov al,var1 ; a.
mov ah,[var1+3] ; b.
```

**답:** a줄 실행 후 `AL = FCh`, b줄 실행 후 `AH = 01h`이다. 따라서 최종 AX는 `01FCh`이다.

---

**18.** What will be the value of the destination operand after each of the following instructions execute in sequence?

```asm
mov ax,var2 ; a.
mov ax,[var2+4] ; b.
mov ax,var3 ; c.
mov ax,[var3-2] ; d.
```

```text
답:
a. 1000h
b. 3000h
c. FFF0h
d. 4000h
```

`WORD` 배열은 메모리에 little-endian 방식으로 저장되므로 주소를 2 byte 단위로 계산한다.

---

**19.** What will be the value of the destination operand after each of the following instructions execute in sequence?

```asm
mov edx,var4 ; a.
movzx edx,var2 ; b.
mov edx,[var4+4] ; c.
movsx edx,var1 ; d.
```

```text
답:
a. 00000001h
b. 00001000h
c. 00000002h
d. FFFFFFFCh
```

`MOVZX`는 0으로 확장하고 `MOVSX`는 부호 확장한다.

---

## 4.9.2 Algorithm Workbench

**1.** Write a sequence of MOV instructions that will exchange the upper and lower words in a doubleword variable named three.

```asm
mov ax,WORD PTR three
mov bx,WORD PTR three+2
mov WORD PTR three, bx
mov WORD PTR three+2, ax
```

**답:** AX와 BX에 각각 하위/상위 WORD를 저장한 후 서로 교환한다.

---

**2.** Using the XCHG instruction no more than three times, reorder the values in four 8-bit registers from the order A,B,C,D to B,C,D,A.

```asm
xchg al,bl
xchg al,cl
xchg al,dl
```

**답:** 세 번의 `XCHG`로 `A,B,C,D`를 `B,C,D,A`로 바꾼다.

---

**3.** Transmitted messages often include a parity bit whose value is combined with a data byte to produce an even number of 1 bits. Suppose a message byte in the AL register contains 01110101. Show how you could use the Parity flag combined with an arithmetic instruction to determine if this message byte has even or odd parity.

```asm
mov al,01110101b
add al,0
```

**답:** `01110101`에는 1이 5개이므로 홀수 parity이다. `TEST` 후 `PF = 0`이다.

---

**4.** Write code using byte operands that adds two negative integers and causes the Overflow flag to be set.

```asm
mov al,-100
add al,-50
```

**답:** `-100 + -50 = -150`으로 signed byte 범위를 벗어나므로 `OF = 1`이다.

---

**5.** Write a sequence of two instructions that use addition to set the Zero and Carry flags at the same time.

```asm
mov al,0FFh
add al,1
```

**답:** 결과가 `00h`가 되어 `ZF = 1`, carry가 발생하여 `CF = 1`이다.

---

**6.** Write a sequence of two instructions that set the Carry flag using subtraction.

```asm
mov al,1
sub al,2
```

---

**7.** Implement the following arithmetic expression in assembly language: EAX = –val2 + 7 – val3 + val1. Assume that val1, val2, and val3 are 32-bit integer variables.

```asm
mov eax,val2
neg eax
add eax,7
sub eax,val3
add eax,val1
```

---

**8.** Write a loop that iterates through a doubleword array and calculates the sum of its elements using a scale factor with indexed addressing.

```asm
mov esi,0
mov eax,0

L1:
    add eax,array[esi*4]
    inc esi
    cmp esi,LENGTHOF array
    jl L1
```

---

**9.** Implement the following expression in assembly language: AX = (val2 + BX) –val4. Assume that val2 and val4 are 16-bit integer variables.

```asm
mov ax,val2
add ax,bx
sub ax,val4
```

---

**10.** Write a sequence of two instructions that set both the Carry and Overflow flags at the same time.

```asm
mov al,7Fh
add al,1
```

---

**11.** Write a sequence of instructions showing how the Zero flag could be used to indicate unsigned overflow after executing INC and DEC instructions.

```asm
mov al,0FFh
inc al
```

**답:** `FFh`에서 `00h`로 증가하면서 `ZF = 1`이 된다. `INC`는 CF를 변경하지 않으므로 Zero flag를 이용해 unsigned wraparound를 확인할 수 있다.

---

**12–18.**
Use the following data definitions for Questions 12–18:

```asm
.data
myBytes BYTE 10h,20h,30h,40h
myWords WORD 3 DUP(?),2000h
myString BYTE "ABCDE"
```

**12.** Insert a directive in the given data that aligns `myBytes` to an even-numbered address.

```asm
ALIGN 2
myBytes BYTE ...
```

**13.** What will be the value of EAX after each of the following instructions execute?

```asm
mov eax,TYPE myBytes      ; a.
mov eax,LENGTHOF myBytes  ; b.
mov eax,SIZEOF myBytes    ; c.
mov eax,TYPE myWords      ; d.
mov eax,LENGTHOF myWords  ; e.
mov eax,SIZEOF myWords    ; f.
mov eax,SIZEOF myString   ; g.
```

**답:**  
> a. 1
> b. 4
> c. 4
> d. 2
> e. 4
> f. 8
> g. 5

**14.** Write a single instruction that moves the first two bytes in `myBytes` to the DX register. The resulting value will be `2010h`.

```asm
mov dx,WORD PTR myBytes
```

**15.** Write an instruction that moves the second byte in `myWords` to the AL register.

```asm
mov al,BYTE PTR myWords+1
```

**16.** Write an instruction that moves all four bytes in `myBytes` to the EAX register.

```asm
mov eax,DWORD PTR myBytes
```

**17.** Insert a LABEL directive in the given data that permits `myWords` to be moved directly to a 32-bit register.

```asm
myWordsD LABEL DWORD
myWords WORD 3 DUP(?),2000h
```

**18.** Insert a LABEL directive in the given data that permits `myBytes` to be moved directly to a 16-bit register.

```asm
myBytesW LABEL WORD
myBytes BYTE 10h,20h,30h,40h
```

---

## 4.10 Programming Exercises

The following exercises may be completed in either 32-bit mode or 64-bit mode.

**1.** Converting from Big Endian to Little Endian

Write a program that uses the variables below and MOV instructions to copy the value from bigEndian to littleEndian, reversing the order of the bytes. The number’s 32-bit value is understood to be 12345678 hexadecimal.

```asm
.data
bigEndian BYTE 12h,34h,56h,78h
littleEndian DWORD?
```

```asm
mov al,bigEndian
mov ah,bigEndian+1
mov BYTE PTR littleEndian+3,al
mov BYTE PTR littleEndian+2,ah

mov al,bigEndian+2
mov ah,bigEndian+3
mov BYTE PTR littleEndian+1,al
mov BYTE PTR littleEndian,ah
```

**답:** `12 34 56 78`을 반대로 배치하여 `78 56 34 12`로 만든다.

---

**2.** Exchanging Pairs of Array Values

Write a program with a loop and indexed addressing that exchanges every pair of values in an array with an even number of elements. Therefore, item i will exchange with item i+1, and item i+2 will exchange with item i+3, and so on.

```asm
mov esi,0

L1:
    mov eax,array[esi*4]
    xchg eax,array[esi*4+4]
    mov array[esi*4],eax

    add esi,2
    cmp esi,LENGTHOF array
    jl L1
```

**답:** `0↔1`, `2↔3`처럼 두 원소씩 교환한다.

---

**3.** Summing the Gaps between Array Values

Write a program with a loop and indexed addressing that calculates the sum of all the gaps between successive array elements. The array elements are doublewords, sequenced in nondecreasing order. So, for example, the array {0, 2, 5, 9, 10} has gaps of 2, 3, 4, and 1, whose sum equals 10.

```asm
mov esi,0
mov eax,0

L1:
    mov ebx,array[esi*4+4]
    sub ebx,array[esi*4]
    add eax,ebx

    inc esi
    cmp esi,LENGTHOF array-1
    jl L1
```

**답:** 인접한 두 원소의 차이를 구해서 모두 더한다.

---

**4.** Copying a Word Array to a DoubleWord Array

Write a program that uses a loop to copy all the elements from an unsigned Word (16-bit) array into an unsigned doubleword (32-bit) array.

```asm
mov esi,0
mov edi,0

L1:
    movzx eax,wordArray[esi*2]
    mov dwordArray[edi*4],eax

    inc esi
    inc edi
    cmp esi,LENGTHOF wordArray
    jl L1
```

**답:** `MOVZX`로 WORD를 DWORD 크기로 0 확장한 후 저장한다.

---

**5.** Fibonacci Numbers

Write a program that uses a loop to calculate the first seven values of the Fibonacci number sequence, described by the following formula: Fib(1) = 1, Fib(2) = 1, Fib(n) = Fib(n – 1) + Fib(n – 2).

```asm
mov eax,1
mov ebx,1
mov ecx,7

L1:
    mov edx,eax
    add edx,ebx
    mov eax,ebx
    mov ebx,edx

    loop L1
```

**답:** 피보나치 수열은 `1, 1, 2, 3, 5, 8, 13`이다.

---

**6.** Reverse an Array

Use a loop with indirect or indexed addressing to reverse the elements of an integer array in place. Do not copy the elements to any other array. Use the SIZEOF, TYPE, and LENGTHOF operators to make the program as flexible as possible if the array size and type should be changed in the future.

```asm
mov esi,0
mov edi,LENGTHOF array-1

L1:
    cmp esi,edi
    jge L2

    mov eax,array[esi*TYPE array]
    xchg eax,array[edi*TYPE array]
    mov array[esi*TYPE array],eax

    inc esi
    dec edi
    jmp L1

L2:
```

**답:** 배열의 앞쪽과 뒤쪽 원소를 하나씩 교환하여 원본 배열 자체를 뒤집는다.

---

**7.** Copy a String in Reverse Order

Write a program with a loop and indirect addressing that copies a string from source to target, reversing the character order in the process. Use the following variables:

```asm
source BYTE "This is the source string",0
target BYTE SIZEOF source DUP('#')
```

```asm
mov esi,OFFSET source
mov edi,OFFSET target
mov ecx,SIZEOF source-1
add esi,ecx

L1:
    mov al,[esi]
    mov [edi],al
    dec esi
    inc edi
    loop L1
```

**답:** source의 마지막 문자부터 target에 저장하여 문자열 순서를 반대로 만든다.

---

**8.** Shifting the Elements in an Array

Using a loop and indexed addressing, write code that rotates the members of a 32-bit integer array forward one position. The value at the end of the array must wrap around to the first position. For example, the array [10,20,30,40] would be transformed into [40,10,20,30].


```asm
mov esi,LENGTHOF array-1
mov eax,array[esi*4]

L1:
    mov ebx,array[esi*4-4]
    mov array[esi*4],ebx

    dec esi
    cmp esi,0
    jg L1

mov array, eax
```

**답:** 마지막 값 `40`을 먼저 저장한 후 나머지 원소를 뒤로 한 칸씩 이동시키고, 마지막에 `40`을 첫 번째 위치에 넣는다.
