# 10장. Structures and Macros - Review Questions and Exercises

## 10.7 Review Questions and Exercises

### 10.7.1 Short Answer

**1. What is the purpose of the STRUCT directive?**

* 답: 서로 다른 데이터 타입을 가질 수 있는 관련 변수(필드)들을 하나의 사용자 정의 데이터 타입으로 묶어 구조체를 정의할 때 사용한다.

**2. Assume that the following structure has been defined:**

```asm
RentalInvoice STRUCT
    invoiceNum BYTE 5 DUP(' ')
    dailyPrice WORD ?
    daysRented WORD ?
RentalInvoice ENDS
```

**State whether or not each of the following declarations is valid:**

* **a. `RentalInvoice rentals <>`**

  * 답: **유효하지 않음(Invalid).** 변수 이름(`rentals`)이 구조체 타입(`RentalInvoice`)보다 먼저 와야 한다.

* **b. `rentals RentalInvoice <>`**

  * 답: **유효함(Valid).** 모든 필드를 구조체 정의의 기본값으로 초기화하여 `rentals` 변수를 선언한다.

* **c. `march RentalInvoice <'12345',10,0>`**

  * 답: **유효함(Valid).** 세 필드를 순서대로 `'12345'`, `10`, `0`으로 초기화한다.

* **d. `RentalInvoice <,10,0>`**

  * 답: **유효함(Valid).** 익명(이름 없는) 구조체 변수를 선언하며, 첫 번째 필드는 기본값을 사용하고 나머지 두 필드는 `10`과 `0`으로 초기화한다.

* **e. `current RentalInvoice <,15,0,0>`**

  * 답: **유효하지 않음(Invalid).** `RentalInvoice` 구조체는 필드가 3개뿐인데 초기값을 4개 지정했다.

**3. (True/False): A macro cannot contain data definitions.**

* 답: **False.** 매크로 내부에는 `.data` 세그먼트 전환 지시어와 함께 변수 및 데이터 정의를 포함할 수 있다. (단, 매크로가 여러 번 호출될 때 레이블 중복을 피하기 위해 `LOCAL` 지시어를 사용해야 한다.)

**4. What is the purpose of the LOCAL directive?**

* 답: 매크로가 한 프로그램 내에서 여러 번 호출(확장)될 때, 매크로 내부에 정의된 레이블이나 변수 이름이 중복되어 어셈블리 오류가 발생하는 것을 방지하기 위해 고유한 이름을 자동 생성하도록 지정한다. (매크로 정의에서 `MACRO` 지시어 바로 다음 줄에 위치해야 한다.)

**5. Which directive displays a message on the console during the assembly step?**

* 답: `ECHO` 지시어. 어셈블리가 진행되는 동안 표준 출력(콘솔)에 메시지를 표시한다.

**6. Which directive marks the end of a conditional block of statements?**

* 답: `ENDIF` 지시어. (`IF`, `IFB`, `IFNB`, `IFDEF` 등으로 시작된 조건부 블록을 닫는다.)

**7. List all the relational operators that can be used in constant boolean expressions.**

* 답: `LT` (작다), `GT` (크다), `EQ` (같다), `NE` (같지 않다), `LE` (작거나 같다), `GE` (크거나 같다).

**8. What is the purpose of the & operator in a macro definition?**

* 답: 치환 연산자(Substitution operator)로, 매크로 매개변수 이름에 대한 모호한 참조를 해소하여 매개변수가 실제 인수로 치환되도록 강제한다. (예: 문자열 리터럴 내부나 다른 텍스트와 붙어 있는 경우)

**9. What is the purpose of the ! operator in a macro definition?**

* 답: 리터럴 문자 연산자(Literal-character operator)로, 매크로 인수로 특수 문자나 구분 기호(쉼표, 공백, `<`, `>` 등)를 지시어 해석 없이 문자 그대로 전달할 때 해당 문자 앞에 붙인다.

**10. What is the purpose of the % operator in a macro definition?**

* 답: 확장 연산자(Expansion operator)로, 매크로 인수로 전달된 상수 표현식이나 텍스트 매크로를 먼저 계산(확장)하여 그 결과 값을 텍스트로 전달한다.

------------------------------------------------------------------------

### 10.7.2 Algorithm Workbench

**1. Create a structure named SampleStruct containing two fields: field1, a single 16-bit WORD, and field2, an array of 20 32-bit DWORDS. The initial values of the fields may be left undefined.**

* 답:

```asm
SampleStruct STRUCT
    field1 WORD ?
    field2 DWORD 20 DUP(?)
SampleStruct ENDS
```

**2. Write a statement that retrieves the wHour field of a SYSTEMTIME structure.**

* 답: `sysTime`이라는 이름의 `SYSTEMTIME` 구조체 변수가 선언되어 있다고 가정할 때 다음과 같이 접근한다.

```asm
mov ax, sysTime.wHour
```

**3. Using the following Triangle structure, declare a structure variable and initialize its vertices to (0,0), (5, 0), and (7,6):**

```asm
Triangle STRUCT
    Vertex1 COORD <>
    Vertex2 COORD <>
    Vertex3 COORD <>
Triangle ENDS
```

* 답: 중첩된 구조체(`COORD`)의 초기값은 중괄호 `{}` 또는 꺾쇠괄호 `<>`로 묶어 지정한다.

```asm
myTriangle Triangle < {0,0}, {5,0}, {7,6} >
```

**4. Declare an array of Triangle structures. Write a loop that initializes Vertex1 of each triangle to random coordinates in the range (0...10, 0...10).**

* 답: `RandomRange` 프로시저는 $0 \sim (\text{EAX}-1)$ 범위의 난수를 반환하므로 EAX에 `11`을 넣고 호출한다.

```asm
.data
NUM_TRIANGLES = 5
triangles Triangle NUM_TRIANGLES DUP(<>)

.code
    mov ecx, NUM_TRIANGLES
    mov esi, OFFSET triangles
L1:
    mov eax, 11
    call RandomRange            ; 0~10 난수 생성
    mov (Triangle PTR [esi]).Vertex1.X, ax

    mov eax, 11
    call RandomRange            ; 0~10 난수 생성
    mov (Triangle PTR [esi]).Vertex1.Y, ax

    add esi, TYPE Triangle
    loop L1
```

**5. Write a macro named mPrintChar that displays a single character on the screen. It should have two parameters: this first specifies the character to be displayed and the second specifies how many times the character should be repeated. Here is a sample call:**
`mPrintChar 'X',20`

* 답: 루프 레이블 충돌을 막기 위해 `LOCAL` 지시어를 사용하고 레지스터를 보존한다.

```asm
mPrintChar MACRO char, count
    LOCAL L1
    push eax
    push ecx
    mov al, char
    mov ecx, count
L1:
    call WriteChar
    loop L1
    pop ecx
    pop eax
ENDM
```

**6. Write a macro named mGenRandom that generates a random integer between 0 and** $n-1$**. Let n be the only parameter.**

* 답: `RandomRange`는 EAX에 전달된 값 $n$을 기준으로 $0 \sim n-1$ 사이의 정수를 EAX에 반환한다.

```asm
mGenRandom MACRO n
    mov eax, n
    call RandomRange
ENDM
```

**7. Write a macro named mPromptInteger that displays a prompt and inputs an integer from the user. Pass it a string literal and the name of a doubleword variable. Sample call:**

```asm
.data
minVal DWORD ?
.code
mPromptInteger "Enter the minimum value", minVal
```

* 답: 책의 `mWrite` 매크로나 매크로 내부 `.data` 선언을 활용해 문자열을 출력하고 `ReadInt`로 정수를 입력받는다.

```asm
mPromptInteger MACRO promptString, intVal
    LOCAL prompt
    .data
    prompt BYTE promptString, 0
    .code
    push eax
    push edx
    mov edx, OFFSET prompt
    call WriteString
    call ReadInt
    mov intVal, eax
    pop edx
    pop eax
ENDM
```

**8. Write a macro named mWriteAt that locates the cursor and writes a string literal to the console window. Suggestion: Invoke the mGotoxy and mWrite macros from the book's macro library.**

* 답:

```asm
mWriteAt MACRO X, Y, literal
    mGotoxy X, Y
    mWrite literal
ENDM
```

**9. Show the expanded code produced by the following statement that invokes the mWriteString macro from Section 10.2.5:**
`mWriteStr namePrompt`

* 답: (`mWriteStr` 매크로 정의에 따라 `EDX`를 보존하고 오프셋을 로드한 뒤 `WriteString`을 호출하는 코드로 확장된다.)

```asm
push edx
mov  edx,OFFSET namePrompt
call WriteString
pop  edx
```

**10. Show the expanded code produced by the following statement that invokes the mReadString macro from Section 10.2.5:**
`mReadStr customerName`

* 답: (`mReadStr` 매크로 정의에 따라 버퍼 오프셋과 `SIZEOF` 크기를 지정하여 `ReadString`을 호출하는 코드로 확장된다.)

```asm
push ecx
push edx
mov  edx,OFFSET customerName
mov  ecx,(SIZEOF customerName) - 1
call ReadString
pop  edx
pop  ecx
```

**11. Write a macro named mDumpMemx that receives a single parameter, the name of a variable. Your macro must call the mDumpMem macro from the book's library, passing it the variable's offset, number of units, and unit size. Demonstrate a call to the mDumpMemx macro.**

* 답: `OFFSET`, `LENGTHOF`, `TYPE` 연산자를 이용해 변수 정보를 `mDumpMem`에 전달한다.

```asm
mDumpMemx MACRO varName
    mDumpMem OFFSET varName, LENGTHOF varName, TYPE varName
ENDM

; 호출 예시
.data
myArray DWORD 10h, 20h, 30h, 40h
.code
mDumpMemx myArray
```

**12. Show an example of a macro parameter having a default argument initializer.**

* 답: 매개변수 이름 뒤에 `:=<기본값>` 형식을 지정한다.

```asm
mPrintLine MACRO char:=<'*'>, count:=<40>
    mPrintChar char, count
    call Crlf
ENDM
```

**13. Write a short example that uses the IF, ELSE, and ENDIF directives.**

* 답:

```asm
mSetMode MACRO isDebug
    IF isDebug EQ 1
        call DumpRegs
    ELSE
        call Crlf
    ENDIF
ENDM
```

**14. Write a statement using the IF directive that checks the value of the constant macro parameter Z; if Z is less than zero, display a message during assembly indicating that Z is invalid.**

* 답:

```asm
IF Z LT 0
    ECHO Error: Parameter Z is invalid (must be >= 0).
ENDIF
```

**15. Write a short macro that demonstrates the use of the & operator when the macro parameter is embedded in a literal string.**

* 답: 문자열 따옴표 안에서 매개변수를 치환하기 위해 `&` 연산자를 사용한다.

```asm
mShowVarName MACRO varName
    LOCAL msg
    .data
    msg BYTE "Variable name is: &varName", 0
    .code
    mov edx, OFFSET msg
    call WriteString
    call Crlf
ENDM
```

**16. Assume the following mLocate macro definition:**

```asm
mLocate MACRO xval,yval
    IF xval LT 0        ;; xval < 0?
        EXITM           ;; if so, exit
    ENDIF
    IF yval LT 0        ;; yval < 0?
        EXITM           ;; if so, exit
    ENDIF
    mov bx,0            ;; video page 0
    mov ah,2            ;; locate cursor
    mov dh,yval
    mov dl,xval
    int 10h             ;; call the BIOS
ENDM
```

**Show the source code generated by the preprocessor when the macro is expanded by each of the following statements:**

* **`mLocate -2,20`**

  * 답: 첫 번째 조건(`-2 LT 0`)이 참이므로 `EXITM`이 실행되어 **아무 코드도 생성되지 않는다.**

* **`mLocate 10,20`**

  * 답: 두 조건 모두 거짓이므로 아래 명령어들이 생성된다.

```asm
    mov bx,0
    mov ah,2
    mov dh,20
    mov dl,10
    int 10h
```

* **`mLocate col,row`**

  * 답: 전처리기는 심볼 이름(`col`, `row`)의 문자열/주소값을 기준으로 `LT 0`을 평가하며, 음수 상수가 아니므로 조건문을 통과하여 아래와 같이 확장된다.

```asm
    mov bx,0
    mov ah,2
    mov dh,row
    mov dl,col
    int 10h
```

------------------------------------------------------------------------

## 10.8 Programming Exercises

**1. mReadkey Macro**

* 답: `ReadChar`를 호출하면 `AL`에 ASCII 코드, `AH`에 스캔 코드가 반환된다.

```asm
INCLUDE Irvine32.inc

mReadkey MACRO asciiCode, scanCode
    push eax
    call ReadChar
    mov asciiCode, al
    mov scanCode, ah
    pop eax
ENDM

.data
ascii BYTE ?
scan  BYTE ?
msg1  BYTE "Press any key: ", 0
msg2  BYTE "ASCII code: ", 0
msg3  BYTE "  Scan code: ", 0

.code
main PROC
    mov edx, OFFSET msg1
    call WriteString

    mReadkey ascii, scan
    call Crlf

    mov edx, OFFSET msg2
    call WriteString
    movzx eax, ascii
    call WriteHex

    mov edx, OFFSET msg3
    call WriteString
    movzx eax, scan
    call WriteHex
    call Crlf

    exit
main ENDP
END main
```

**2. mWritestringAttr Macro**

* 답: `SetTextColor`로 색상을 변경해 문자열을 출력한 뒤 원래 색상(`lightGray`)으로 복구한다.

```asm
INCLUDE Irvine32.inc

mWritestringAttr MACRO strName, color
    push eax
    push edx
    mov eax, color
    call SetTextColor
    mov edx, OFFSET strName
    call WriteString
    mov eax, lightGray
    call SetTextColor
    pop edx
    pop eax
ENDM

.data
str1 BYTE "This is white text.", 0dh, 0ah, 0
str2 BYTE "This is yellow text.", 0dh, 0ah, 0
str3 BYTE "This is lightCyan text.", 0dh, 0ah, 0

.code
main PROC
    mWritestringAttr str1, white
    mWritestringAttr str2, yellow
    mWritestringAttr str3, lightCyan
    exit
main ENDP
END main
```

**3. mMove32 Macro**

* 답: x86 어셈블리에서는 메모리에서 메모리로의 직접 `MOV`가 불가능하므로 `EAX` 레지스터를 경유한다.

```asm
INCLUDE Irvine32.inc

mMove32 MACRO destination, source
    push eax
    mov eax, source
    mov destination, eax
    pop eax
ENDM

.data
val1 DWORD 12345678h
val2 DWORD 0

.code
main PROC
    mMove32 val2, val1
    mov eax, val2
    call WriteHex
    call Crlf
    exit
main ENDP
END main
```

**4. mMult32 Macro**

* 답: 32비트 부호 없는 곱셈(`MUL`) 또는 부호 있는 곱셈(`IMUL`)을 사용해 하위 32비트 결과를 첫 번째 피연산자(또는 결과 저장용 피연산자)에 저장한다.

```asm
INCLUDE Irvine32.inc

mMult32 MACRO op1, op2
    push eax
    push edx
    mov eax, op1
    mul op2
    mov op1, eax
    pop edx
    pop eax
ENDM

.data
num1 DWORD 250
num2 DWORD 40

.code
main PROC
    mMult32 num1, num2          ; num1 = 250 * 40 = 10000
    mov eax, num1
    call WriteDec
    call Crlf
    exit
main ENDP
END main
```

**★★ 5. mReadInt Macro**

* 답: `TYPE` 연산자와 `IF`/`ELSEIF` 조건부 어셈블리 지시어를 사용하여 인수의 크기가 2바이트(`WORD`)인지 4바이트(`DWORD`)인지 판별한다.

```asm
INCLUDE Irvine32.inc

mReadInt MACRO intVal
    push eax
    call ReadInt
    IF (TYPE intVal) EQ 2
        mov intVal, ax
    ELSEIF (TYPE intVal) EQ 4
        mov intVal, eax
    ELSE
        ECHO Error: mReadInt requires a 16-bit or 32-bit operand.
    ENDIF
    pop eax
ENDM

.data
wordVal  SWORD ?
dwordVal SDWORD ?
prompt1  BYTE "Enter a 16-bit signed integer: ", 0
prompt2  BYTE "Enter a 32-bit signed integer: ", 0

.code
main PROC
    mov edx, OFFSET prompt1
    call WriteString
    mReadInt wordVal
    movsx eax, wordVal
    call WriteInt
    call Crlf

    mov edx, OFFSET prompt2
    call WriteString
    mReadInt dwordVal
    mov eax, dwordVal
    call WriteInt
    call Crlf

    exit
main ENDP
END main
```

**★★ 6. mWriteInt Macro**

* 답: `TYPE` 연산자로 인수의 크기(1, 2, 4바이트)를 확인한 뒤, 1바이트와 2바이트는 `MOVSX`로 부호 확장하여 `EAX`에 넣고 `WriteInt`를 호출한다.

```asm
INCLUDE Irvine32.inc

mWriteInt MACRO intVal
    push eax
    IF (TYPE intVal) EQ 1
        movsx eax, intVal
    ELSEIF (TYPE intVal) EQ 2
        movsx eax, intVal
    ELSEIF (TYPE intVal) EQ 4
        mov eax, intVal
    ELSE
        ECHO Error: mWriteInt requires a 8-, 16-, or 32-bit operand.
    ENDIF
    call WriteInt
    pop eax
ENDM

.data
bVal SBYTE -42
wVal SWORD -1234
dVal SDWORD 987654

.code
main PROC
    mWriteInt bVal
    call Crlf
    mWriteInt wVal
    call Crlf
    mWriteInt dVal
    call Crlf
    exit
main ENDP
END main
```

**7. The Professor's Lost Phone**

* 답: 기존 `DrunkardWalk` 프로그램에서 총 걸음 수(`WalkMax`) 중 무작위 시점(`dropStep`)을 미리 뽑아두고, 해당 단계에 도달했을 때의 좌표를 휴대폰 분실 위치로 저장하여 출력한다.

```asm
INCLUDE Irvine32.inc

WalkMax = 50
StartX = 25
StartY = 25

DrunkardWalk STRUCT
    path COORD WalkMax DUP(<0,0>)
    pathsUsed WORD 0
DrunkardWalk ENDS

DisplayPosition PROTO currX:WORD, currY:WORD

.data
aWalk DrunkardWalk <>
dropStep DWORD ?
phonePos COORD <>
msgLost  BYTE " -> [Phone lost here!]", 0dh, 0ah, 0

.code
main PROC
    call Randomize
    mov eax, WalkMax
    call RandomRange            ; 0 ~ (WalkMax - 1) 중 무작위 분실 시점 결정
    mov dropStep, eax

    mov esi, OFFSET aWalk
    call TakeDrunkenWalk
    exit
main ENDP

TakeDrunkenWalk PROC
    pushad
    mov edi, esi
    add edi, OFFSET DrunkardWalk.path
    mov ecx, WalkMax
    mov ebx, 0                  ; 현재 단계 인덱스(0 ~ WalkMax-1)
    mov dx, StartX
    mov ax, StartY

Again:
    mov (COORD PTR [edi]).X, dx
    mov (COORD PTR [edi]).Y, ax

    INVOKE DisplayPosition, dx, ax

    ; 휴대폰 분실 시점 확인
    cmp ebx, dropStep
    jne NextMove
    mov phonePos.X, dx
    mov phonePos.Y, ax
    push edx
    mov edx, OFFSET msgLost
    call WriteString
    pop edx
    jmp SkipCrlf

NextMove:
    call Crlf
SkipCrlf:
    mov eax, 4
    call RandomRange
    .IF eax == 0                ; 북쪽
        dec ax
    .ELSEIF eax == 1            ; 남쪽
        inc ax
    .ELSEIF eax == 2            ; 서쪽
        dec dx
    .ELSE                       ; 동쪽
        inc dx
    .ENDIF

    inc ebx
    add edi, TYPE COORD
    loop Again

Finish:
    mov (DrunkardWalk PTR [esi]).pathsUsed, WalkMax
    popad
    ret
TakeDrunkenWalk ENDP

DisplayPosition PROC currX:WORD, currY:WORD
.data
commaStr BYTE ",", 0
.code
    pushad
    movzx eax, currX
    call WriteDec
    mov edx, OFFSET commaStr
    call WriteString
    movzx eax, currY
    call WriteDec
    popad
    ret
DisplayPosition ENDP
END main
```

**★★★ 8. Drunkard's Walk with Probabilities**

* 답: 방향을 `0=북, 1=동, 2=남, 3=서`(시계 방향)로 정의하면, 직진(`+0`), 우회전(`+1 mod 4`), 후진(`+2 mod 4`), 좌회전(`+3 mod 4`)으로 간단히 계산할 수 있다. `0~99` 범위의 난수를 생성하여 50% / 10% / 20% / 20% 확률을 분기한다.

```asm
INCLUDE Irvine32.inc

WalkMax = 50
StartX = 25
StartY = 25

DrunkardWalk STRUCT
    path COORD WalkMax DUP(<0,0>)
    pathsUsed WORD 0
DrunkardWalk ENDS

DisplayPosition PROTO currX:WORD, currY:WORD

.data
aWalk DrunkardWalk <>
currDir DWORD 0                 ; 기본 시작 방향: 0 (북쪽)

.code
main PROC
    call Randomize
    mov esi, OFFSET aWalk
    call TakeDrunkenWalk
    exit
main ENDP

TakeDrunkenWalk PROC
    pushad
    mov edi, esi
    add edi, OFFSET DrunkardWalk.path
    mov ecx, WalkMax
    mov dx, StartX
    mov ax, StartY

Again:
    mov (COORD PTR [edi]).X, dx
    mov (COORD PTR [edi]).Y, ax
    INVOKE DisplayPosition, dx, ax

    ; 0~99 난수로 확률 결정
    push eax
    mov eax, 100
    call RandomRange

    .IF eax < 50                ; 50%: 같은 방향 유지
        ; currDir 변화 없음
    .ELSEIF eax < 60            ; 10%: 반대 방향(180도 회전)
        add currDir, 2
    .ELSEIF eax < 80            ; 20%: 우회전(시계 방향 90도)
        add currDir, 1
    .ELSE                       ; 20%: 좌회전(반시계 방향 90도)
        add currDir, 3
    .ENDIF
    and currDir, 3              ; mod 4 연산 (0~3 유지)
    pop eax

    ; 결정된 방향(currDir)에 따라 좌표 이동
    .IF currDir == 0            ; 북(North)
        dec ax
    .ELSEIF currDir == 1        ; 동(East)
        inc dx
    .ELSEIF currDir == 2        ; 남(South)
        inc ax
    .ELSE                       ; 서(West)
        dec dx
    .ENDIF

    add edi, TYPE COORD
    loop Again

    mov (DrunkardWalk PTR [esi]).pathsUsed, WalkMax
    popad
    ret
TakeDrunkenWalk ENDP

DisplayPosition PROC currX:WORD, currY:WORD
.data
commaStr BYTE ",", 0
.code
    pushad
    movzx eax, currX
    call WriteDec
    mov edx, OFFSET commaStr
    call WriteString
    movzx eax, currY
    call WriteDec
    call Crlf
    popad
    ret
DisplayPosition ENDP
END main
```

**★★★★ 9. Shifting Multiple Doublewords**

* 답: 리틀 엔디언 배열에서 오른쪽 시프트(`R`)는 낮은 인덱스부터 높은 인덱스 방향으로 `SHRD`를 수행하고 마지막 요소를 `SHR`하며, 왼쪽 시프트(`L`)는 높은 인덱스부터 낮은 인덱스 방향으로 `SHLD`를 수행하고 첫 번째 요소를 `SHL`한다. (`IFIDNI`로 대소문자 구분 없이 방향을 비교한다.)

```asm
INCLUDE Irvine32.inc

mShiftDoublewords MACRO arrayName, direction, numberOfBits
    LOCAL L1
    push eax
    push ecx
    push esi

    mov cl, numberOfBits

    IFIDNI <direction>, <R>
        mov esi, OFFSET arrayName
        mov ecx, (LENGTHOF arrayName) - 1
    L1:
        mov eax, [esi + 4]
        push ecx
        mov cl, numberOfBits
        shrd [esi], eax, cl
        pop ecx
        add esi, 4
        loop L1

        mov cl, numberOfBits
        shr DWORD PTR [esi], cl

    ELSEIFIDNI <direction>, <L>
        mov esi, OFFSET arrayName + ((LENGTHOF arrayName) - 1) * 4
        mov ecx, (LENGTHOF arrayName) - 1
    L1:
        mov eax, [esi - 4]
        push ecx
        mov cl, numberOfBits
        shld [esi], eax, cl
        pop ecx
        sub esi, 4
        loop L1

        mov cl, numberOfBits
        shl DWORD PTR [esi], cl
    ELSE
        ECHO Error: Direction must be R or L.
    ENDIF

    pop esi
    pop ecx
    pop eax
ENDM

.data
array DWORD 648B2165h, 8C943A29h, 6DFA4B86h, 91F76C04h, 8BAF9857h

.code
main PROC
    ; 오른쪽으로 4비트 시프트 후 출력
    mShiftDoublewords array, R, 4
    call DisplayArray

    ; 다시 왼쪽으로 4비트 시프트 후 출력
    mShiftDoublewords array, L, 4
    call DisplayArray

    exit
main ENDP

DisplayArray PROC
    mov esi, OFFSET array
    mov ecx, LENGTHOF array
L1:
    mov eax, [esi]
    call WriteHex
    mov al, ' '
    call WriteChar
    add esi, 4
    loop L1
    call Crlf
    ret
DisplayArray ENDP
END main
```

**★★★ 10. Three-Operand Instructions**

* 답: `EAX`는 매크로 작업용으로 예약되어 보존하지 않고, `div3`에서 사용하는 `EDX`는 `CDQ` 실행 전후로 `PUSH`/`POP`하여 보존한다.

```asm
INCLUDE Irvine32.inc

add3 MACRO destination, source1, source2
    mov eax, source1
    add eax, source2
    mov destination, eax
ENDM

sub3 MACRO destination, source1, source2
    mov eax, source1
    sub eax, source2
    mov destination, eax
ENDM

mul3 MACRO destination, source1, source2
    mov eax, source1
    imul source2
    mov destination, eax
ENDM

div3 MACRO destination, source1, source2
    push edx
    mov eax, source1
    cdq
    idiv source2
    mov destination, eax
    pop edx
ENDM

.data
w    SDWORD 10
y    SDWORD 5
z    SDWORD 4
x    SDWORD ?
temp SDWORD ?

.code
main PROC
    ; 수식 1: x = (w + y) * z  -> (10 + 5) * 4 = 60
    add3 temp, w, y
    mul3 x, temp, z
    mov eax, x
    call WriteInt
    call Crlf

    ; 수식 2: x = (w - y) / z  -> (10 - 5) / 4 = 1
    sub3 temp, w, y
    div3 x, temp, z
    mov eax, x
    call WriteInt
    call Crlf

    ; 수식 3: x = (w * y) + (z * 2) -> 50 + 8 = 58
    mul3 temp, w, y
    mul3 x, z, <2>              ; 즉시값 대신 메모리 피연산자 원칙 준수 시 아래처럼 변수 사용 권장
    ; (모든 인수가 메모리 피연산자인 경우)
    mul3 temp, w, y
    add3 x, temp, z             ; x = (10 * 5) + 4 = 54
    mov eax, x
    call WriteInt
    call Crlf

    ; 수식 4: x = (w * z) - (y + z) -> 40 - 9 = 31
    mul3 temp, w, z
    add3 x, y, z
    sub3 x, temp, x
    mov eax, x
    call WriteInt
    call Crlf

    exit
main ENDP
END main
```
