# 8. Advanced Procedures

## 1. Stack Frames

**Stack frame(= activation record)** 은 스택에서 다음 항목을 위해 따로 잡아 둔 영역이다.

- 전달된 인자(passed arguments)
- 서브루틴 복귀 주소(return address)
- 지역 변수(local variables)
- 저장된 레지스터(saved registers)

### 1.1 Stack Frame 생성 순서

| 순서 | 동작 | 설명 |
|---|---|---|
| 1 | Push Arguments | 인자를 스택에 push |
| 2 | Call Subroutine | `call` 실행 → return address push |
| 3 | Push EBP | 호출자의 EBP 저장 |
| 4 | Set EBP to ESP | EBP를 현재 ESP로 설정 (프레임의 기준점) |
| 5 | Allocate Local Variables | `sub esp, n`으로 지역변수 공간 확보 |
| 6 | Save Registers | 사용할 레지스터를 스택에 저장 |

### 1.2 레지스터 파라미터의 단점

레지스터로 인자를 넘기면, 호출 전에 해당 레지스터를 **push로 보존 → 인자 값 대입 → 호출 후 pop으로 복원**해야 한다.

```asm
push ebx                    ; save register values
push ecx
push esi
mov  esi, OFFSET array      ; starting OFFSET
mov  ecx, LENGTHOF array    ; size, in units
mov  ebx, TYPE array        ; doubleword format
call DumpMem                ; display memory
pop  esi                    ; restore register values
pop  ecx
pop  ebx
```

- push/pop 때문에 코드가 지저분해지고, 레지스터를 쓰려던 **성능상의 이점도 사라지는 경향**이 있다.
- 참고: Microsoft는 32비트 프로그램용으로 레지스터 기반 인자 전달 규약인 **fastcall** 을 제공한다.

### 1.3 Value vs Reference 인자

| 구분 | 전달 내용 | 예 |
|---|---|---|
| Pass by value | 값의 **복사본**을 push | `AddTwo(val1, val2)` |
| Pass by reference | 객체의 **주소(offset)** 를 push | `Swap(&val1, &val2)` |

#### Passing by Value

```asm
.data
val1 DWORD 5
val2 DWORD 6
.code
push val2
push val1
call AddTwo        ; int sum = AddTwo(val1, val2);
```

```
        ┌──────────┐
 (val2) │    6     │
        ├──────────┤
 (val1) │    5     │ ◄── ESP
        └──────────┘
```

#### Passing by Reference

```asm
push OFFSET val2
push OFFSET val1
call Swap          ; Swap(&val1, &val2);
```

#### Passing Arrays

고급 언어는 배열을 **항상 reference로** 전달한다. 즉, 배열의 시작 주소를 push한다.

```asm
.data
array DWORD 50 DUP(?)
.code
push OFFSET array
call ArrayFill
```

### 1.4 Stack Parameter 접근 (AddTwo 예제)

```c
int AddTwo(int x, int y)
{
    return x + y;
}
```

```asm
AddTwo PROC
    push ebp
    mov  ebp, esp          ; base of stack frame
    mov  eax, [ebp + 12]   ; second parameter
    add  eax, [ebp + 8]    ; first parameter
    pop  ebp
    ret
AddTwo ENDP
```

스택 구조 (호출 `push 6` → `push 5` → `call AddTwo` 이후):

```
        ┌────────────────┐
        │       6        │  [EBP + 12]
        ├────────────────┤
        │       5        │  [EBP + 8]
        ├────────────────┤
        │ return address │  [EBP + 4]
        ├────────────────┤
        │      EBP       │  ◄── EBP, ESP
        └────────────────┘
```

> `push ebp` 후 `mov ebp, esp` 를 하면 EBP가 고정 기준점이 되므로, 그 위(높은 주소)의 인자는 **+ offset**, 아래의 지역변수는 **− offset** 으로 접근한다.

### 1.5 Explicit Stack Parameters

`[ebp + 8]` 처럼 **상수 오프셋을 코드에 직접 명시**하여 접근하는 매개변수를 *explicit stack parameter* 라고 한다. 가독성을 위해 심볼릭 상수로 정의하기도 한다.

```asm
y_param EQU [ebp + 12]
x_param EQU [ebp + 8]

AddTwo PROC
    push ebp
    mov  ebp, esp
    mov  eax, y_param
    add  eax, x_param
    pop  ebp
    ret
AddTwo ENDP
```

### 1.6 Stack 정리 (Cleaning Up the Stack)

인자를 push했으면 **누군가는 반드시 스택에서 제거**해야 한다. 그렇지 않으면 `ret` 가 엉뚱한 값(인자)을 return address로 pop하여 **스택이 망가진다(corrupted)**.

```asm
; ❌ 잘못된 예 - stack is corrupted!
Example1 PROC
    push 6
    push 5
    call AddTwo
    ret                ; ESP가 return address를 가리키지 않음
Example1 ENDP
```

### 1.7 32-Bit Calling Conventions

#### C Calling Convention

- C / C++ 에서 사용
- 인자를 **역순**으로 push (`AddTwo(A, B)` → B 먼저, 그다음 A)
- **호출한 쪽(caller)** 이 스택 정리

```asm
Example1 PROC
    push 6
    push 5
    call AddTwo
    add  esp, 8        ; remove arguments from the stack (2개 × 4바이트)
    ret
Example1 ENDP
```

#### STDCALL Calling Convention

- `ret` 에 정수 인자를 주어, 복귀 후 ESP에 그 값만큼 더해 준다.
- **호출된 쪽(callee)** 이 스택 정리
- 정수는 **매개변수가 차지하는 스택 바이트 수**와 같아야 한다.

```asm
AddTwo PROC
    push ebp
    mov  ebp, esp          ; base of stack frame
    mov  eax, [ebp + 12]   ; second parameter
    add  eax, [ebp + 8]    ; first parameter
    pop  ebp
    ret  8                 ; clean up the stack
AddTwo ENDP
```

| 규약 | 인자 push 순서 | 스택 정리 주체 | 정리 방법 |
|---|---|---|---|
| C (cdecl) | 역순 | Caller | `add esp, n` |
| STDCALL | 역순 | Callee | `ret n` |

### 1.8 레지스터 저장/복원

서브루틴은 레지스터를 수정하기 전에 현재 값을 스택에 저장해 둔다.

```asm
MySub PROC
    push ebp               ; save base pointer
    mov  ebp, esp          ; base of stack frame
    push ecx
    push edx               ; save EDX
    mov  eax, [ebp+8]      ; get the stack parameter
    ; ...
    pop  edx               ; restore saved registers
    pop  ecx
    pop  ebp               ; restore base pointer
    ret                    ; clean up the stack
MySub ENDP
```

```
        ┌────────────────┐
        │  (parameter)   │  [EBP + 8]
        ├────────────────┤
        │ return address │  [EBP + 4]
        ├────────────────┤
        │      EBP       │  ◄── EBP
        ├────────────────┤
        │      ECX       │
        ├────────────────┤
        │      EDX       │  ◄── ESP
        └────────────────┘
```

- 복원은 **저장의 역순**(pop edx → pop ecx → pop ebp)
- `ret` 는 `[ebp+4]` 위치에 있던 **return address를 pop**하여 호출 함수로 복귀한다.

### 1.9 Local Variables

고급 언어에서 한 서브루틴 안에서만 생성·사용·소멸하는 변수. 런타임 스택에서 **EBP 아래쪽**에 만들어진다.

```c
void MySub()
{
    int X = 10;
    int Y = 20;
}
```

| Variable | Bytes | Stack Offset |
|---|---|---|
| X | 4 | EBP − 4 |
| Y | 4 | EBP − 8 |

```asm
MySub PROC
    push ebp
    mov  ebp, esp
    sub  esp, 8                    ; create locals
    mov  DWORD PTR [ebp-4], 10     ; X
    mov  DWORD PTR [ebp-8], 20     ; Y
    mov  esp, ebp                  ; remove locals from stack
    pop  ebp
    ret
MySub ENDP
```

```
        ┌────────────────┐
        │ return address │
        ├────────────────┤
        │      EBP       │  ◄── EBP
        ├────────────────┤
        │    10 (X)      │  [EBP - 4]
        ├────────────────┤
        │    20 (Y)      │  [EBP - 8]  ◄── ESP
        └────────────────┘
```

종료 전에 `mov esp, ebp` 로 ESP를 EBP 값으로 되돌려 **지역변수를 스택에서 해제**한다.

### 1.10 Reference Parameters (ArrayFill 예제)

Reference 파라미터는 보통 **EBP 기준 base-offset 주소지정**으로 접근한다. 아래는 16비트 정수 의사난수로 배열을 채우는 프로시저이다.

```asm
ArrayFill PROC
    push ebp
    mov  ebp, esp
    pushad                      ; save registers
    mov  esi, [ebp+12]          ; offset of array
    mov  ecx, [ebp+8]           ; array length
    cmp  ecx, 0                 ; ECX == 0?
    je   L2                     ; yes: skip over loop
L1:
    mov  eax, 10000h            ; get random 0 - FFFFh
    call RandomRange            ; from the link library
    mov  [esi], ax              ; insert value in array
    add  esi, TYPE WORD         ; move to next element
    loop L1
L2: popad                       ; restore registers
    pop  ebp
    ret  8                      ; clean up the stack
ArrayFill ENDP
```

```
        ┌────────────────┐
        │ offset (array) │  [EBP + 12]
        ├────────────────┤
        │     count      │  [EBP + 8]
        ├────────────────┤
        │ return address │
        ├────────────────┤
        │      EBP       │  ◄── EBP, ESP
        └────────────────┘
```

### 1.11 LEA Instruction

`LEA` 는 **간접 피연산자의 주소(effective address)** 를 반환한다. `OFFSET` 은 어셈블 시점에 주소가 결정되는 전역 변수에만 쓸 수 있지만, 스택 위 지역변수의 주소는 **실행 시점**에 결정되므로 `LEA` 가 필요하다.

```c
void makeArray()
{
    char myString[30];
    for (int i = 0; i < 30; i++)
        myString[i] = '*';
}
```

```asm
makeArray PROC
    push ebp
    mov  ebp, esp
    sub  esp, 32                  ; myString is at EBP-30
    lea  esi, [ebp-30]            ; load address of myString
    mov  ecx, 30                  ; loop counter
L1: mov  BYTE PTR [esi], '*'      ; fill one position
    inc  esi                      ; move to next
    loop L1                       ; continue until ECX = 0
    add  esp, 32                  ; remove the array (restore ESP)
    pop  ebp
    ret
makeArray ENDP
```

> 30바이트가 필요하지만 스택은 4바이트(doubleword) 단위로 정렬하므로 32바이트를 확보한다.

### 1.12 ENTER and LEAVE Instructions

**ENTER** 는 호출된 프로시저의 스택 프레임을 자동으로 만든다.

1. `push ebp` — EBP 저장
2. `mov ebp, esp` — EBP를 현재 ESP로 설정
3. `sub esp, numbytes` — 지역변수 공간 확보

```asm
ENTER numbytes, nestinglevel
```

- `numbytes` : 지역변수용으로 예약할 스택 바이트 수
- `nestinglevel` : 프로시저의 lexical nesting level (보통 0)

```asm
; Example 1                     ; 동일한 코드
MySub PROC                      MySub PROC
    enter 0, 0                      push ebp
                                    mov  ebp, esp

; Example 2                     ; 동일한 코드
MySub PROC                      MySub PROC
    enter 8, 0                      push ebp
                                    mov  ebp, esp
                                    sub  esp, 8
```

**LEAVE** 는 ENTER의 동작을 되돌려 ESP와 EBP를 호출 당시 값으로 복원한다.

```asm
MySub PROC                      ; 동일한 코드
    enter 8, 0                  MySub PROC
    ; ...                           push ebp
    leave                           mov  ebp, esp
    ret                             sub  esp, 8
MySub ENDP                          ; ...
                                    mov  esp, ebp
                                    pop  ebp
                                    ret
                                MySub ENDP
```

> ENTER를 사용했다면 같은 프로시저 끝에서 **반드시 LEAVE도 함께 사용**하는 것이 좋다.

### 1.13 LOCAL Directive

`LOCAL` 은 지역변수를 **이름과 크기(타입)를 지정해** 선언한다. (ENTER는 이름 없는 단일 블록만 예약한다.)

```asm
LOCAL varlist
;   label:type
```

```asm
MySub PROC
    LOCAL var1:BYTE

BubbleSort PROC
    LOCAL temp:DWORD, SwapFlag:BYTE

Merge PROC
    LOCAL pArray:PTR WORD
    LOCAL TempArray[10]:DWORD
```

---

## 2. Recursion

**재귀 서브루틴**은 직접 또는 간접적으로 **자기 자신을 호출**하는 서브루틴이다.

### 2.1 Endless Recursion

종료 조건이 없는 재귀는 스택이 가득 찰 때까지 호출을 반복한다.

```asm
; Endless Recursion (Endless.asm)
INCLUDE Irvine32.inc
.data
endlessStr BYTE "This recursion never stops", 0
.code
main PROC
    call Endless
    exit
main ENDP

Endless PROC
    mov  edx, OFFSET endlessStr
    call WriteString
    call Endless
    ret                          ; never executes
Endless ENDP
END main
```

### 2.2 Recursively Calculating a Sum

> 유용한 재귀 서브루틴에는 **항상 종료 조건(terminating condition)** 이 있다.

```asm
; Sum of Integers (RecursiveSum.asm)
INCLUDE Irvine32.inc
.code
main PROC
    mov  ecx, 5                  ; count = 5
    mov  eax, 0                  ; holds the sum
    call CalcSum                 ; calculate sum
L1: call WriteDec                ; display EAX
    call Crlf                    ; new line
    exit
main ENDP

;------------------------------------------------------
CalcSum PROC
; Calculates the sum of a list of integers
; Receives: ECX = count
; Returns:  EAX = sum
;------------------------------------------------------
    cmp  ecx, 0                  ; check counter value
    jz   L2                      ; quit if zero
    add  eax, ecx                ; otherwise, add to sum
    dec  ecx                     ; decrement counter
    call CalcSum                 ; recursive call
L2: ret
CalcSum ENDP
END main
```

처음 두 줄(`cmp`, `jz`)이 카운터를 검사하여 ECX = 0 이면 더 이상 재귀 호출하지 않는다. `ret` 가 처음 실행되면 이전 `CalcSum` 호출로 복귀하고, 그 호출이 다시 그 이전 호출로 복귀하는 식으로 풀려 나간다.

**Table 8-1. Stack Frame and Registers (CalcSum)**

| Pushed on Stack | Value in ECX | Value in EAX |
|---|---|---|
| L1 | 5 | 0 |
| L2 | 4 | 5 |
| L2 | 3 | 9 |
| L2 | 2 | 12 |
| L2 | 1 | 14 |
| L2 | 0 | 15 |

### 2.3 Calculating a Factorial

재귀 서브루틴은 임시 데이터를 **스택 파라미터**에 저장하는 경우가 많다. 재귀 호출이 풀릴(unwind) 때 스택에 저장해 둔 데이터가 유용하게 쓰인다.

```c
int function factorial(int n)
{
    if (n == 0)
        return 1;
    else
        return n * factorial(n - 1);
}
```

```
Recursive calls          Backing up
5! = 5 * 4!              5 * 24 = 120
4! = 4 * 3!              4 * 6  = 24
3! = 3 * 2!              3 * 2  = 6
2! = 2 * 1!              2 * 1  = 2
1! = 1 * 0!              1 * 1  = 1
0! = 1 (Base case)       1 = 1
```

#### 예제 프로그램 (Fact.asm)

n(0~12 사이의 unsigned 정수)을 스택으로 전달하고, 결과는 EAX로 반환한다.

```asm
; Calculating a Factorial (Fact.asm)
INCLUDE Irvine32.inc
.code
main PROC
    push 5                       ; calc 5!
    call Factorial               ; calculate factorial (EAX)
    call WriteDec                ; display it
    call Crlf
    exit
main ENDP

;---------------------------------------------------
Factorial PROC
; Calculates a factorial.
; Receives: [ebp+8] = n, the number to calculate
; Returns:  eax = the factorial of n
;---------------------------------------------------
    push ebp
    mov  ebp, esp
    mov  eax, [ebp+8]            ; get n
    cmp  eax, 0                  ; n > 0?
    ja   L1                      ; yes: continue
    mov  eax, 1                  ; no: return 1 as the value of 0!
    jmp  L2                      ; and return to the caller
L1: dec  eax
    push eax                     ; Factorial(n-1)
    call Factorial
; Instructions from this point on execute when each
; recursive call returns.
ReturnFact:
    mov  ebx, [ebp+8]            ; get n
    mul  ebx                     ; EDX:EAX = EAX * EBX
L2: pop  ebp                     ; return EAX
    ret  4                       ; clean up stack
Factorial ENDP
END main
```

#### N = 3 추적

호출이 깊어질 때마다 `N`, `Ret Addr`, `EBP` 가 한 세트씩 쌓인다.

```
N=3 호출      N=2 호출        N=1 호출        N=0 호출 (base case)
┌────────┐   ┌────────┐     ┌────────┐      ┌────────┐
│ N = 3  │   │ N = 3  │     │ N = 3  │      │ N = 3  │
│RetAddr │   │RetAddr │     │RetAddr │      │RetAddr │
│ EBP    │   │ EBP    │     │ EBP    │      │ EBP    │
└────────┘   │ N = 2  │     │ N = 2  │      │ N = 2  │
             │RetAddr │     │RetAddr │      │RetAddr │
             │ EBP    │     │ EBP    │      │ EBP    │
             └────────┘     │ N = 1  │      │ N = 1  │
                            │RetAddr │      │RetAddr │
                            │ EBP    │      │ EBP    │
                            └────────┘      │ N = 0  │
                                            │RetAddr │
                                            │ EBP    │
                                            └────────┘
```

N = 0에서 `EAX = 1` 을 반환한 뒤 풀려 나가며 곱한다.

| 복귀 단계 | 계산 | EAX |
|---|---|---|
| N = 0 반환 | base case | 1 |
| N = 1 복귀 | 1 × 1 | 1 |
| N = 2 복귀 | 2 × 1 | 2 |
| N = 3 복귀 | 3 × 2 | 6 |

---

## 3. INVOKE, ADDR, PROC, PROTO

### 3.1 INVOKE Directive

- **32비트 모드에서만** 사용 가능
- 인자를 스택에 push(`.MODEL` 의 language specifier가 정한 순서)하고 프로시저를 호출
- `CALL` 대신 쓰면 **한 줄로 여러 인자 전달** 가능

```asm
INVOKE procedureName [, argumentList]
```

```asm
; 기존 방식
push TYPE array
push LENGTHOF array
push OFFSET array
call DumpArray

; INVOKE 방식 (위와 동일)
INVOKE DumpArray, OFFSET array, LENGTHOF array, TYPE array
```

> INVOKE는 ① 인자를 올바른 순서로 push하고 ② `call` 로 실행하고 ③ 호출 규약(stdcall, cdecl 등)에 따라 스택 정리까지 자동 처리해 주는 호출용 매크로이다.

인자는 거의 개수 제한 없이 쓸 수 있고, 여러 줄에 나누어 쓸 수 있다.

```asm
INVOKE DumpArray,        ; displays an array
    OFFSET array,        ; points to the array
    LENGTHOF array,      ; the array length
    TYPE array           ; array component size
```

**Table 8-2. INVOKE에 사용할 수 있는 인자 종류**

| Type | Examples |
|---|---|
| Immediate value | `10`, `3000h`, `OFFSET mylist`, `TYPE array` |
| Integer expression | `(10 * 20)`, `COUNT` |
| Variable | `myList`, `array`, `myWord`, `myDword` |
| Address expression | `[myList+2]`, `[ebx + esi]` |
| Register | `eax`, `bl`, `edi` |
| ADDR name | `ADDR myList` |
| OFFSET name | `OFFSET myList` |

### 3.2 ADDR Operator

INVOKE로 호출할 때 **포인터 인자**를 넘기는 데 사용한다.

```asm
INVOKE FillArray, ADDR myArray
```

```asm
INVOKE mySub, ADDR [ebp+12]     ; ❌ error
; ADDR의 인자는 assembly-time constant 여야 한다.

mov esi, ADDR myArray           ; ❌ error
; ADDR 연산자는 INVOKE와 함께 쓸 때만 사용 가능하다.
```

**예제**

```asm
.data
Array DWORD 20 DUP(?)
.code
; ...
INVOKE Swap,                     ; 아래 코드와 동일
    ADDR Array,                  ;   push OFFSET Array+4
    ADDR [Array+4]               ;   push OFFSET Array
                                 ;   call Swap
```

### 3.3 PROC Directive

프로시저를 정의하는 지시어.

```asm
label PROC [attributes] [USES reglist], parameter_list

; attributes = [distance] [langtype] [visibility] [prologuearg]
```

**Table 8-3. PROC의 attributes 필드**

| Attribute | Description |
|---|---|
| distance | `NEAR` 또는 `FAR`. 어셈블러가 생성하는 RET 종류(RET / RETF)를 결정 |
| langtype | 호출 규약 지정 (C, PASCAL, STDCALL 등). `.MODEL` 에서 지정한 언어를 override |
| visibility | 다른 모듈에서의 가시성: `PRIVATE`, `PUBLIC`(기본), `EXPORT`. EXPORT이면 링커가 export table에 이름을 넣고, PUBLIC 가시성도 활성화 |
| prologuearg | prologue/epilogue 코드 생성에 영향을 주는 인자 |

#### Parameter Lists

PROC은 쉼표로 구분한 **이름 있는 파라미터 목록**을 받을 수 있다.

```asm
label PROC [attributes] [USES reglist],
    parameter_1,
    parameter_2,
    .
    .
    parameter_n

; 한 줄로도 가능
label PROC [attributes], parameter_1, parameter_2, ..., parameter_n

; 파라미터 형식
;   paramName:type
```

#### Example 1 : AddTwo

두 doubleword를 받아 합을 EAX로 반환.

```asm
; 파라미터 이름 사용                 ; MASM이 생성하는 실제 코드
AddTwo PROC,                         AddTwo PROC
    val1:DWORD,                          push ebp
    val2:DWORD                           mov  ebp, esp
    mov  eax, val1                       mov  eax, dword ptr [ebp+8]
    add  eax, val2                       add  eax, dword ptr [ebp+0Ch]
    ret                                  leave
AddTwo ENDP                              ret  8
                                     AddTwo ENDP
```

#### Example 2 : FillArray

byte 배열의 포인터를 받음.

```asm
FillArray PROC,
    pArray:PTR BYTE
    . . .
FillArray ENDP
```

#### Example 3 : Swap

doubleword 포인터 2개를 받음.

```asm
Swap PROC,
    pValX:PTR DWORD,
    pValY:PTR DWORD
    . . .
Swap ENDP
```

#### Example 4 : Read_File

byte 포인터 `pBuffer`, 지역변수 `fileHandle`(DWORD), 저장할 레지스터 EAX/EBX.

```asm
; 선언문                              ; MASM이 생성하는 실제 코드
Read_File PROC USES eax ebx,          Read_File PROC
    pBuffer:PTR BYTE                      push ebp
    LOCAL fileHandle:DWORD                mov  ebp, esp
                                          add  esp, 0FFFFFFFCh   ; create fileHandle
    mov  esi, pBuffer                     push eax               ; save EAX
    mov  fileHandle, eax                  push ebx               ; save EBX
    .                                     mov  esi, dword ptr [ebp+8]  ; pBuffer (parameter)
    .                                     mov  dword ptr [ebp-4], eax  ; fileHandle
    ret                                   pop  ebx
Read_File ENDP                            pop  eax
                                          leave
                                          ret  4
                                      Read_File ENDP
```

> `add esp, 0FFFFFFFCh` 는 `sub esp, 4` 와 같다 (−4).

#### RET Instruction Modified by PROC

PROC에 파라미터가 하나 이상 있고 STDCALL이 기본 규약이면, 파라미터가 n개일 때 MASM이 다음 entry/exit 코드를 생성한다.

```asm
push ebp
mov  ebp, esp
.
.
leave
ret  (n*4)
```

#### Parameter Classifications

데이터 이동 방향에 따른 파라미터 분류.

| 분류 | 사용 시점 |
|---|---|
| Input | 프로시저가 데이터를 **수정하면 안 될 때** |
| Output | 프로시저가 변수에 **데이터를 대입**해야 할 때 |
| Input-Output | 프로시저가 **기존 데이터를 수정**해야 할 때 |

### 3.4 Example: Exchanging Two Integers (Swap.asm)

```asm
; Swap Procedure Example (Swap.asm)
INCLUDE Irvine32.inc
Swap PROTO, pValX:PTR DWORD, pValY:PTR DWORD
.data
Array DWORD 10000h, 20000h
.code
main PROC
    ; Display the array before the exchange:
    mov  esi, OFFSET Array
    mov  ecx, 2                          ; count = 2
    mov  ebx, TYPE Array
    call DumpMem                         ; dump the array values
    INVOKE Swap, ADDR Array, ADDR [Array+4]
    ; Display the array after the exchange:
    call DumpMem
    exit
main ENDP

;------------------------------------------------------
Swap PROC USES eax esi edi,
    pValX:PTR DWORD,                     ; pointer to first integer
    pValY:PTR DWORD                      ; pointer to second integer
;
; Exchange the values of two 32-bit integers
; Returns: nothing
;------------------------------------------------------
    mov  esi, pValX                      ; get pointers
    mov  edi, pValY
    mov  eax, [esi]                      ; get first integer
    xchg eax, [edi]                      ; exchange with second
    mov  [esi], eax                      ; replace first integer
    ret                                  ; PROC generates RET 8 here
Swap ENDP
END main
```

### 3.5 Debugging Tips

#### Argument Size Mismatch

DWORD 배열에서 포인터를 **1바이트씩** 어긋나게 넘기면 doubleword 경계가 깨진다.

```asm
.data
DoubleArray DWORD 10000h, 20000h
.code
INVOKE Swap, ADDR [DoubleArray + 0], ADDR [DoubleArray + 1]
```

#### Passing the Wrong Type of Pointer

`Swap` 은 **doubleword 포인터 2개**를 기대하는데, 실수로 **byte 포인터**를 넘긴 경우이다. Swap은 각 주소에서 4바이트씩 읽고 쓰므로 인접한 바이트까지 오염된다.

```asm
.data
ByteArray BYTE 10h, 20h, 30h, 40h, 50h, 60h, 70h, 80h
.code
INVOKE Swap, ADDR [ByteArray + 0], ADDR [ByteArray + 1]
```

#### Passing Immediate Values

```asm
Sub2 PROC, dataPtr:PTR WORD
    mov  esi, dataPtr             ; get the address
    mov  WORD PTR [esi], 0        ; dereference, assign zero
    ret
Sub2 ENDP

INVOKE Sub2, 1000h                ; ❌ runtime error
```

`Sub2` 는 `1000h` 를 포인터 값으로 받아 메모리 주소 `1000h` 를 역참조하므로 **런타임 오류**가 발생한다. 포인터 파라미터에는 즉시값이 아니라 `ADDR 변수` 를 넘겨야 한다.

### 3.6 WriteStackFrame Procedure

Irvine32 라이브러리의 `WriteStackFrame` 은 **현재 프로시저의 스택 프레임**(스택 파라미터, return address, 지역변수, 저장된 레지스터)을 출력해 주는 디버깅용 프로시저이다.

```asm
main PROC
    mov  eax, 0EAEAEAEAh
    mov  ebx, 0EBEBEBEBh
    INVOKE myProc, 1111h, 2222h      ; pass two integer arguments
    exit
main ENDP

myProc PROC USES eax ebx,
    x: DWORD, y: DWORD
    LOCAL a:DWORD, b:DWORD

    PARAMS = 2
    LOCALS = 2
    SAVED_REGS = 2
    mov  a, 0AAAAh
    mov  b, 0BBBBh
    INVOKE WriteStackFrame, PARAMS, LOCALS, SAVED_REGS
```

출력 결과:

```
Stack Frame

00002222 ebp+12 (parameter)
00001111 ebp+8  (parameter)
00401083 ebp+4  (return address)
0012FFF0 ebp+0  (saved ebp)       <--- ebp
0000AAAA ebp-4  (local variable)
0000BBBB ebp-8  (local variable)
EAEAEAEA ebp-12 (saved register)
EBEBEBEB ebp-16 (saved register)  <--- esp
```

---

## 4. Multimodule Programs

각 모듈은 **독립적으로 어셈블**되므로, 한 모듈의 소스를 고치면 그 모듈만 다시 어셈블하면 된다. 링커가 모든 OBJ 파일을 하나의 실행 파일로 합치는 데 걸리는 시간은 소스를 전부 어셈블하는 시간보다 훨씬 짧다.

| 방식 | 특징 |
|---|---|
| Traditional | `EXTERN` 지시어 사용 (이식성) |
| Microsoft Advanced | `INVOKE` + `PROTO` 사용 (간편함) |

### 4.1 프로시저 이름 숨기기 / 내보내기

MASM은 기본적으로 **모든 프로시저를 public** 으로 만든다. `PRIVATE` 한정자로 이를 바꿀 수 있다.

```asm
mySub PROC PRIVATE
```

private으로 만들면 **캡슐화**가 되어 모듈 내부에 프로시저를 숨기고, 서로 다른 모듈의 같은 이름 프로시저 간 **이름 충돌**을 피할 수 있다.

#### OPTION PROC:PRIVATE

파일 맨 위에 두면 모든 프로시저가 기본 private이 되고, 내보낼 것만 `PUBLIC` 으로 지정한다.

```asm
OPTION PROC:PRIVATE
PUBLIC mySub
```

`PUBLIC` 은 쉼표로 구분한 이름 목록을 받는다. 개별 프로시저에 직접 지정할 수도 있다.

```asm
PUBLIC sub1, sub2, sub3

mySub PROC PUBLIC
    .
mySub ENDP
```

> ⚠️ 시작 모듈에서 `OPTION PROC:PRIVATE` 를 쓴다면 **시작 프로시저(보통 main)를 반드시 PUBLIC** 으로 지정해야 한다. 그렇지 않으면 OS 로더가 찾지 못한다.
>
> ```asm
> main PROC PUBLIC
> ```

### 4.2 Calling External Procedures

`EXTERN` 은 현재 모듈 밖의 프로시저를 호출할 때 사용하며, 프로시저 이름과 스택 프레임 크기를 알려 준다.

```asm
INCLUDE Irvine32.inc
EXTERN sub1@0:PROC
.code
main PROC
    call sub1@0
    exit
main ENDP
END main
```

이름 끝의 **`@n` 접미사**는 선언된 파라미터가 사용하는 **총 스택 바이트 수**이다. 확장 PROC으로 선언했다면 **파라미터 1개당 4바이트**를 더한다.

```asm
AddTwo PROC,
    val1:DWORD,
    val2:DWORD
    . . .
AddTwo ENDP

; 다른 모듈에서 (4바이트 × 2 = 8)
EXTERN AddTwo@8:PROC

; INVOKE/PROTO 방식
AddTwo PROTO,
    val1:DWORD,
    val2:DWORD
```

### 4.3 모듈 간 변수/심볼 사용

#### Exporting Variables and Symbols

변수와 심볼은 기본적으로 **자신이 속한 모듈에서만 사용 가능(private)** 하다. `PUBLIC` 으로 내보낸다.

```asm
PUBLIC count, SYM1
SYM1 = 10
.data
count DWORD 0
```

#### Accessing External Variables and Symbols

```asm
EXTERN name : type

EXTERN one:WORD, two:SDWORD, three:PTR BYTE, four:ABS
```

#### EXTERNDEF + INCLUDE 파일

`EXTERNDEF` 는 **PUBLIC과 EXTERN 둘 다를 대신**한다. 공용 `.inc` 파일에 한 번만 선언하면 모든 모듈에서 재사용할 수 있다.

```asm
; vars.inc
EXTERNDEF count:DWORD, SYM1:ABS
```

```asm
; sub1.asm
.386
.model flat, STDCALL
INCLUDE vars.inc
SYM1 = 10
.data
count DWORD 0
END
```

```asm
; main.asm
.386
.model flat, stdcall
.stack 4096
ExitProcess proto, dwExitCode:dword
INCLUDE vars.inc
.code
main PROC
    mov  count, 2000h
    mov  eax, SYM1
    INVOKE ExitProcess, 0
main ENDP
END main
```

### 4.4 Example: ArraySum Program

구조도(Figure 8-5):

```
                  ArraySum Program (main)
        ┌────────────┬──────────┴──────────┬──────────────┐
      Clrscr   PromptForIntegers        ArraySum       DisplaySum
                 ┌────┴─────┐                         ┌────┴─────┐
            WriteString  ReadInt                 WriteString  WriteInt
```

- `Clrscr`, `WriteString`, `ReadInt`, `WriteInt` 는 Irvine32 라이브러리 프로시저 (회색 박스)
- `PromptForIntegers`, `ArraySum`, `DisplaySum` 을 각각 별도 모듈로 분리하여 구현
- 구현 방식은 ① `EXTERN` 을 사용하는 방식과 ② `INVOKE` + `PROTO` 를 사용하는 방식 두 가지

---

## 5. Chapter Summary

| 절 | 주제 |
|---|---|
| 8.2 | Stack Frames (Stack Parameters, 호출 규약, Local Variables, Reference Parameters, LEA, ENTER/LEAVE, LOCAL) |
| 8.3 | Recursion (재귀 합, 팩토리얼) |
| 8.4 | INVOKE, ADDR, PROC, PROTO (파라미터 분류, Swap 예제, 디버깅 팁, WriteStackFrame) |
| 8.5 | Multimodule Programs (이름 숨기기/내보내기, 외부 프로시저, 외부 변수, ArraySum) |
| 8.6 | Advanced Use of Parameters (Optional) |
| 8.7 | Java Bytecodes (Optional) |

### 핵심 요약

- **스택 프레임** = 인자 + return address + 저장된 EBP + 지역변수 + 저장된 레지스터
- 인자는 `[ebp+8]`, `[ebp+12]` …, 지역변수는 `[ebp-4]`, `[ebp-8]` … 로 접근
- **C 규약**은 호출자가 `add esp, n` 으로, **STDCALL** 은 피호출자가 `ret n` 으로 스택을 정리
- `ENTER` / `LEAVE` 는 프롤로그/에필로그를 자동화, `LOCAL` 은 **이름 있는** 지역변수 선언
- 포인터가 필요하면 `ADDR`(INVOKE 전용), 지역변수의 주소는 `LEA`
- 재귀 프로시저에는 **반드시 종료 조건**이 있어야 하며, 호출마다 스택 프레임이 쌓인다
- `INVOKE` + `PROC`(파라미터 목록) + `PROTO` 로 호출을 간결하게 작성
- 멀티모듈에서는 `PUBLIC` / `EXTERN` / `EXTERNDEF` 로 이름을 공유하고, `PRIVATE` 로 캡슐화
