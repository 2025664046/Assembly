# 10장. Structures and Macros

## 1. 구조체와 공용체 (Structures & Unions, 10.1)

### 1.1 구조체 개요 (Overview)
- **구조체(Structure)**는 서로 연관된 여러 변수를 하나의 사용자 정의 데이터 타입으로 묶어주는 설계 틀(템플릿)이다. 구조체를 구성하는 개별 변수를 **필드(field)** 또는 **멤버(member)**라고 부른다.
- 배열과 달리 각 필드가 서로 다른 자료형을 가질 수 있으며, 프로그램에서 구조체 전체를 하나의 단위로 취급하거나 점(`.`) 연산자를 통해 개별 필드에 접근할 수 있다.
- **프로시저 인자 전달의 효율성:** 매개변수가 많은 프로시저에 값을 일일이 스택으로 넘기면 순서나 개수를 실수하기 쉽다. 관련 데이터를 구조체로 묶은 뒤 **구조체의 시작 주소(4바이트 오프셋) 하나만 전달**하면 스택 사용량을 줄일 수 있고, 호출된 프로시저가 원본 데이터를 직접 수정하기도 용이하다.
- MASM의 구조체는 C/C++ 구조체와 메모리 구조가 호환되므로 `COORD`, `SYSTEMTIME` 같은 Windows API 구조체를 그대로 활용할 수 있다.

```asm
; Windows API 화면 좌표 구조체 예시
COORD STRUCT
    X WORD ?            ; 오프셋 00h (2바이트)
    Y WORD ?            ; 오프셋 02h (2바이트)
COORD ENDS
```

---

### 1.2 구조체 정의와 필드 정렬 (Defining Structures, 10.1.1)
- 구조체는 `STRUCT`와 `ENDS` 지시어 쌍으로 정의하며, 반드시 해당 구조체 변수를 선언하기 전에 먼저 정의되어 있어야 한다.

```asm
구조체이름 STRUCT
    필드 선언문들...
구조체이름 ENDS
```

- **필드 초기값(Field Initializer) 지정 방식:**
  - `?` : 초기값을 지정하지 않음(미정)
  - 문자열 리터럴 : 따옴표로 감싼 문자열 (`"000000000"`)
  - 정수 : 정수 상수 또는 상수 표현식
  - 배열 : `DUP` 연산자를 이용한 반복 초기화

```asm
Employee STRUCT
    IdNum         BYTE "000000000"
    LastName      BYTE 30 DUP(0)
    Years         WORD 0
    SalaryHistory DWORD 0,0,0,0
Employee ENDS
```

#### 메모리 성능 향상을 위한 필드 정렬 (`ALIGN`)
- CPU가 메모리에 데이터를 읽고 쓸 때, 각 필드가 자신의 크기 배수에 해당하는 주소 경계에 배치되어 있으면 한 번의 메모리 접근으로 데이터를 가져올 수 있다. 경계가 어긋나면 추가적인 버스 사이클이 발생해 속도가 저하된다.
- `ALIGN datatype` 지시어를 사용하면 다음 필드의 시작 오프셋이 지정된 자료형의 배수가 되도록 컴파일러가 자동으로 빈 바이트(패딩)를 삽입한다.

```asm
Employee STRUCT
    IdNum         BYTE "000000000"  ; 9바이트 (오프셋 0~8)
    LastName      BYTE 30 DUP(0)    ; 30바이트 (오프셋 9~38)
    ALIGN         WORD              ; 1바이트 패딩 추가 (39 -> 40)
    Years         WORD 0            ; 2바이트 (오프셋 40~41)
    ALIGN         DWORD             ; 2바이트 패딩 추가 (42 -> 44)
    SalaryHistory DWORD 0,0,0,0     ; 16바이트 (오프셋 44~59)
Employee ENDS                       ; 전체 크기: 60바이트
```

| 자료형 | 권장 정렬 경계 |
| :--- | :--- |
| `BYTE`, `SBYTE` | 8비트 (1바이트) 경계 |
| `WORD`, `SWORD` | 16비트 (2바이트) 경계 |
| `DWORD`, `SDWORD`, `REAL4` | 32비트 (4바이트) 경계 |
| `QWORD`, `REAL8` | 64비트 (8바이트) 경계 |
| `structure` | 내부 멤버 중 가장 큰 정렬 기준을 따름 |
| `union` | 첫 번째 멤버의 정렬 기준을 따름 |

---

### 1.3 구조체 변수 선언 (Declaring Structure Variables, 10.1.2)
- 정의된 구조체 이름을 자료형처럼 사용하여 변수를 선언한다. 초기값 목록은 꺾쇠괄호(`< >`) 또는 중괄호(`{ }`)로 감싸며, 빈 괄호(`< >`)를 쓰면 구조체 정의 시 지정한 기본 초기값이 적용된다.

```asm
.data
point1  COORD <5,10>                ; X = 5, Y = 10
point2  COORD <20>                  ; X = 20, Y = ? (기본값)
point3  COORD <>                    ; X = ?, Y = ?
worker  Employee <>                 ; 모든 필드에 기본 초기값 적용
person1 Employee <"555223333">      ; 첫 번째 필드(IdNum)만 재정의
person2 Employee {"555223333"}      ; 중괄호 표기법도 동일하게 동작
person3 Employee <,"dJones">        ; 쉼표로 건너뛰어 두 번째 필드만 초기화
person4 Employee <,,,2 DUP(20000)>  ; 네 번째 배열 필드의 앞 2개 원소만 초기화
```

- **구조체 배열 및 변수 자체 정렬:**

```asm
NumPoints = 3
.data
ALIGN DWORD                         ; 구조체 변수 시작 주소를 4바이트 경계에 정렬
person    Employee <>
AllPoints COORD NumPoints DUP(<0,0>) ; 3개의 COORD 구조체 배열 선언
```

---

### 1.4 구조체 및 멤버 참조 (Referencing Structure Variables, 10.1.3)
- `TYPE`, `SIZEOF`, `LENGTHOF`, `OFFSET` 연산자를 구조체 이름, 구조체 변수, 개별 필드에 모두 적용할 수 있다.

```asm
.data
worker Employee <>

; 연산자 평가 결과 (60바이트 정렬된 Employee 기준)
; TYPE Employee                  -> 60
; SIZEOF Employee                -> 60
; SIZEOF worker                  -> 60
; TYPE Employee.SalaryHistory    -> 4
; LENGTHOF Employee.SalaryHistory -> 4
; SIZEOF Employee.SalaryHistory  -> 16
; TYPE Employee.Years            -> 2

.code
mov dx, worker.Years                    ; 개별 필드 값 읽기
mov worker.SalaryHistory, 20000         ; 배열 필드의 첫 번째 원소 수정
mov [worker.SalaryHistory + 4], 30000   ; 배열 필드의 두 번째 원소 수정
mov edx, OFFSET worker.LastName         ; 특정 필드의 메모리 오프셋 얻기
```

#### 간접(Indirect) 및 인덱스(Indexed) 주소 지정
- 레지스터로 구조체 주소를 가리킬 때는 어셈블러가 구조체 타입을 알 수 있도록 반드시 **`PTR` 연산자**로 형변환을 명시해야 한다.

```asm
; 1. 간접 주소 지정 (Indirect Operands)
mov esi, OFFSET worker
mov ax, (Employee PTR [esi]).Years

; 2. 인덱스 주소 지정 (Indexed Operands)
.data
department Employee 5 DUP(<>)
.code
mov esi, TYPE Employee                  ; 인덱스 1번 요소의 바이트 오프셋(60)
mov department[esi].Years, 4
```

#### 예제: 구조체 배열 순회 (`AllPoints.asm`)
```asm
INCLUDE Irvine32.inc

NumPoints = 3
.data
ALIGN WORD
AllPoints COORD NumPoints DUP(<0,0>)

.code
main PROC
    mov edi, 0                          ; 배열 바이트 인덱스
    mov ecx, NumPoints                  ; 반복 횟수
    mov ax, 1                           ; 초기 X, Y 좌표값
L1:
    mov (COORD PTR AllPoints[edi]).X, ax
    mov (COORD PTR AllPoints[edi]).Y, ax
    add edi, TYPE COORD                 ; 다음 구조체 요소로 이동 (+4)
    inc ax
    loop L1
    exit
main ENDP
END main
```

#### 정렬 여부에 따른 실행 성능 비교 예제
- `ALIGN`을 생략한 `EmployeeBad`와 정렬을 맞춘 `Employee`에 대해 $2^{32}-1$회 반복 접근 시간을 `GetMSeconds`로 측정하면 정렬된 구조체가 훨씬 빠르게 동작한다.

```asm
EmployeeBad STRUCT
    IdNum         BYTE "000000000"
    LastName      BYTE 30 DUP(0)
    Years         WORD 0
    SalaryHistory DWORD 0,0,0,0
EmployeeBad ENDS

.data
ALIGN DWORD
startTime DWORD ?
emp Employee <>                         ; 또는 emp EmployeeBad <>

.code
    call GetMSeconds                    ; 시작 시각 측정
    mov startTime, eax
    mov ecx, 0FFFFFFFFh
L1:
    mov emp.Years, 5
    mov emp.SalaryHistory, 35000
    loop L1
    call GetMSeconds                    ; 종료 시각 측정
    sub eax, startTime
    call WriteDec                       ; 소요 시간(ms) 출력
```

---

### 1.5 예제: 시스템 현재 시각 출력 (`ShowTime.ASM`, 10.1.4)
- Windows API의 `SYSTEMTIME` 구조체와 `GetLocalTime`, `SetConsoleCursorPosition` 함수를 호출하여 콘솔의 지정된 위치에 현재 시:분:초를 출력한다.

```asm
INCLUDE Irvine32.inc

.data
sysTime       SYSTEMTIME <>
XYPos         COORD <10,5>
consoleHandle DWORD ?
colonStr      BYTE ":",0

.code
main PROC
    ; 표준 출력 콘솔 핸들 획득
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    mov consoleHandle, eax

    ; 커서 위치 이동 및 로컬 시스템 시간 조회
    INVOKE SetConsoleCursorPosition, consoleHandle, XYPos
    INVOKE GetLocalTime, ADDR sysTime

    ; 시간 출력 (hh:mm:ss)
    movzx eax, sysTime.wHour
    call WriteDec
    mov edx, OFFSET colonStr
    call WriteString

    movzx eax, sysTime.wMinute
    call WriteDec
    call WriteString

    movzx eax, sysTime.wSecond
    call WriteDec
    call Crlf
    call WaitMsg
    exit
main ENDP
END main
```

---

### 1.6 중첩 구조체 (Structures Containing Structures, 10.1.5)
- 구조체 내부의 필드로 또 다른 구조체 타입을 포함할 수 있다.

```asm
Rectangle STRUCT
    UpperLeft  COORD <>
    LowerRight COORD <>
Rectangle ENDS

.data
rect1 Rectangle <>
rect2 Rectangle {}
rect3 Rectangle { {10,10}, {50,20} }
rect4 Rectangle < <10,10>, <50,20> >

.code
mov rect1.UpperLeft.X, 10

mov esi, OFFSET rect1
mov (Rectangle PTR [esi]).UpperLeft.Y, 10

mov edi, OFFSET rect2.LowerRight
mov (COORD PTR [edi]).X, 50

mov edi, OFFSET rect2.LowerRight.X
mov WORD PTR [edi], 50
```

---

### 1.7 예제: 취객의 걸음 시뮬레이션 (`Walk.asm`, 10.1.6)
- 시작 좌표 $(25, 25)$에서 출발해 동·서·남·북 네 방향 중 임의의 방향으로 50걸음 이동하며 경로를 `COORD` 배열에 기록하는 프로그램이다.

```asm
INCLUDE Irvine32.inc

WalkMax = 50
StartX  = 25
StartY  = 25

DrunkardWalk STRUCT
    path      COORD WalkMax DUP(<0,0>)
    pathsUsed WORD 0
DrunkardWalk ENDS

DisplayPosition PROTO currX:WORD, currY:WORD

.data
aWalk DrunkardWalk <>

.code
main PROC
    mov esi, OFFSET aWalk
    call TakeDrunkenWalk
    exit
main ENDP

TakeDrunkenWalk PROC
    LOCAL currX:WORD, currY:WORD
    pushad
    mov edi, esi
    add edi, OFFSET DrunkardWalk.path
    mov ecx, WalkMax
    mov currX, StartX
    mov currY, StartY

Again:
    mov ax, currX
    mov (COORD PTR [edi]).X, ax
    mov ax, currY
    mov (COORD PTR [edi]).Y, ax

    INVOKE DisplayPosition, currX, currY

    mov eax, 4                  ; 0~3 사이의 난수 생성
    call RandomRange
    .IF eax == 0                ; 북(North)
        dec currY
    .ELSEIF eax == 1            ; 남(South)
        inc currY
    .ELSEIF eax == 2            ; 서(West)
        dec currX
    .ELSE                       ; 동(East)
        inc currX
    .ENDIF

    add edi, TYPE COORD
    loop Again

    mov (DrunkardWalk PTR [esi]).pathsUsed, WalkMax
    popad
    ret
TakeDrunkenWalk ENDP

DisplayPosition PROC currX:WORD, currY:WORD
.data
commaStr BYTE ",",0
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

---

### 1.8 공용체 (Unions, 10.1.7)
- **공용체(Union)**는 구조체와 문법이 유사하지만, 모든 필드가 **동일한 시작 오프셋(메모리 공간)을 공유**한다는 점이 다르다. 공용체의 전체 크기는 내부 필드 중 가장 긴 필드의 크기와 같다.
- 초기값은 최대 1개만 지정할 수 있으며, 정의 시 여러 필드에 초기값을 적더라도 첫 번째 필드의 초기값만 유효하다.

```asm
; 독립적인 공용체 정의
Integer UNION
    D DWORD 0
    W WORD  0
    B BYTE  0
Integer ENDS

; 구조체 내부에 공용체 중첩
FileInfo STRUCT
    UNION FileID
        D DWORD ?
        W WORD  ?
        B BYTE  ?
    ENDS
    FileName BYTE 64 DUP(?)
FileInfo ENDS

.data
val1 Integer <12345678h>
val2 Integer <100h>
val3 Integer <>

.code
mov val3.B, al                  ; 하위 1바이트 접근
mov val3.W, ax                  ; 하위 2바이트 접근
mov val3.D, eax                 ; 전체 4바이트 접근
```

- 공용체 내부에 구조체를 포함할 수도 있다(예: Windows 콘솔 입력 이벤트를 다루는 `INPUT_RECORD`).

```asm
INPUT_RECORD STRUCT
    EventType WORD ?
    ALIGN DWORD
    UNION Event
        KEY_EVENT_RECORD          <>
        MOUSE_EVENT_RECORD        <>
        WINDOW_BUFFER_SIZE_RECORD <>
        MENU_EVENT_RECORD         <>
        FOCUS_EVENT_RECORD        <>
    ENDS
INPUT_RECORD ENDS
```

---

## 2. 매크로 (Macros, 10.2)

### 2.1 매크로 개념과 인라인 확장 (Overview, 10.2.1 ~ 10.2.3)
- **매크로 프로시저(Macro Procedure)**는 이름을 부여한 어셈블리 명령어 블록이다.
- 일반 프로시저(`CALL`/`RET`)와 달리 매크로를 호출하면 어셈블러의 전처리(Preprocessing) 단계에서 **매크로 본문 코드가 호출 위치에 그대로 복사·삽입**되는데, 이를 **인라인 확장(Inline Expansion)**이라고 한다.
- 매개변수는 자료형이 없는 **텍스트 치환 자리표시자(Placeholder)**로 동작한다.

```asm
; 매크로 정의
mPutchar MACRO char
    push eax
    mov  al, char
    call WriteChar
    pop  eax
ENDM

; 매크로 호출 및 전처리 확장 결과
.code
    mPutchar 'A'
    ; [확장된 코드]
    ; push eax
    ; mov  al, 'A'
    ; call WriteChar
    ; pop  eax
```

- **매크로 디버깅 팁:**
  1. 어셈블 시 생성되는 리스팅 파일(`.LST`)을 열어 매크로가 의도한 명령어로 치환되었는지 확인한다.
  2. Visual Studio 디버거 실행 중 우클릭 후 **Go to Disassembly**를 선택하면 매크로 호출 아래에 생성된 기계어 명령어를 직접 추적할 수 있다.

---

### 2.2 매크로 고급 기능 (`REQ`, `;;`, `ECHO`, `LOCAL`, 10.2.4)
1. **필수 매개변수 (`REQ`):** 매개변수 뒤에 `:REQ`를 붙이면 호출 시 해당 인수를 생략했을 때 어셈블 오류를 발생시킨다.
2. **매크로 주석 (`;;`):** 일반 세미콜론(`;`) 주석은 매크로가 확장될 때마다 리스팅 파일에 함께 복사되지만, 이중 세미콜론(`;;`) 주석은 확장 결과에서 제외된다.
3. **어셈블 시 메시지 출력 (`ECHO`):** 프로그램이 어셈블되는 도중 콘솔 창에 안내 메시지를 출력한다.
4. **지역 레이블 (`LOCAL`):** 매크로 내부에 데이터 라벨이나 분기 라벨이 있을 때 매크로를 두 번 이상 호출하면 "심볼 중복 정의(Redefinition)" 오류가 발생한다. `MACRO` 바로 다음 줄에 `LOCAL`을 선언하면 호출할 때마다 `??0000`, `??0001` 형태의 고유한 이름을 자동 생성한다.

```asm
mWrite MACRO text
    LOCAL string                ;; 호출 시마다 ??0000, ??0001 등으로 자동 치환
    .data
    string BYTE text, 0
    .code
    push edx
    mov  edx, OFFSET string
    call WriteString
    pop  edx
ENDM
```

#### 중첩 매크로 (Nested Macros)
- 매크로 내부에서 다른 매크로를 호출할 수 있으며, 바깥 매크로가 받은 인수를 내부 매크로로 그대로 전달할 수 있다.

```asm
mWriteln MACRO text
    mWrite text
    call Crlf
ENDM
```

---

### 2.3 교재 매크로 라이브러리 (`Macros.inc`, 10.2.5 ~ 10.2.6)
- `Irvine32` 환경에서는 자주 쓰는 입출력 프로시저를 감싼(Wrapper) 표준 매크로 라이브러리 `Macros.inc`를 제공한다.

| 매크로 이름 | 매개변수 | 기능 설명 |
| :--- | :--- | :--- |
| `mDump` | `varName, useLabel` | 변수의 이름과 기본 속성을 사용해 메모리 내용 덤프 |
| `mDumpMem` | `address, itemCount, componentSize` | 지정된 메모리 영역을 16진수로 출력 |
| `mGotoxy` | `X, Y` | 콘솔 창 버퍼의 커서 좌표 이동 |
| `mReadString` | `varName` | 키보드로부터 문자열 입력받기 |
| `mShow` | `itsName, format` | 변수나 레지스터 값을 지정된 포맷으로 출력 |
| `mShowRegister` | `regName, regValue` | 32비트 레지스터 이름과 16진수 값 출력 |
| `mWrite` | `text` | 문자열 리터럴을 콘솔 창에 출력 |
| `mWriteSpace` | `count` | 지정한 개수만큼 공백 문자 출력 |
| `mWriteString` | `buffer` | 문자열 변수의 내용을 콘솔 창에 출력 |

#### 예제: 래퍼 매크로 활용 (`Wraps.asm`)
```asm
INCLUDE Irvine32.inc
INCLUDE Macros.inc

.data
array     DWORD 1,2,3,4,5,6,7,8
firstName BYTE 31 DUP(?)
lastName  BYTE 31 DUP(?)

.code
main PROC
    mGotoxy 0, 0
    mWrite <"Sample Macro Program", 0dh, 0ah>

    mGotoxy 0, 5
    mWrite "Please enter your first name: "
    mReadString firstName
    call Crlf

    mWrite "Please enter your last name: "
    mReadString lastName
    call Crlf

    mWriteString firstName
    mWriteSpace 1
    mWriteString lastName
    call Crlf

    mDumpMem OFFSET array, LENGTHOF array, TYPE array
    exit
main ENDP
END main
```

---

## 3. 조건부 어셈블리 지시어 (Conditional-Assembly Directives, 10.3)

### 3.1 주요 조건부 지시어 목록
- 전처리 단계에서 조건을 검사하여 특정 코드 블록을 어셈블할지 제외할지 결정한다.

| 지시어 | 설명 |
| :--- | :--- |
| `IF expression` | 상수 불린 표현식이 참(0이 아님)이면 어셈블 허용 |
| `IFB <argument>` | 인수가 비어 있으면(Blank) 참 |
| `IFNB <argument>` | 인수가 비어 있지 않으면(Not Blank) 참 |
| `IFIDN <arg1>,<arg2>` | 두 인수가 정확히 일치하면 참 (대소문자 구분) |
| `IFIDNI <arg1>,<arg2>` | 두 인수가 일치하면 참 (대소문자 구분 안 함) |
| `IFDIF <arg1>,<arg2>` | 두 인수가 다르면 참 (대소문자 구분) |
| `IFDIFI <arg1>,<arg2>` | 두 인수가 다르면 참 (대소문자 구분 안 함) |
| `IFDEF name` | 심볼 `name`이 이미 정의되어 있으면 참 |
| `IFNDEF name` | 심볼 `name`이 정의되어 있지 않으면 참 |
| `ELSE` / `ELSEIF` | 이전 조건이 거짓일 때 대체 분기 처리 |
| `ENDIF` | 조건부 어셈블리 블록 종료 |
| `EXITM` | 매크로 확장을 즉시 중단하고 빠져나감 |

---

### 3.2 인수 검사 및 기본값 설정 (`IFB`, `:=`, `IF`, `IFIDNI`, 10.3.1 ~ 10.3.5)

#### 1) 누락된 인수 검사 (`IFB`) 및 기본 인수 초기화 (`:=`)
```asm
; 인수가 비어 있을 때 에러 메시지 출력 후 종료
mWriteString MACRO string
    IFB <string>
        ECHO * Error: parameter missing in mWriteString
        EXITM
    ENDIF
    push edx
    mov  edx, OFFSET string
    call WriteString
    pop  edx
ENDM

; 기본 인수 초기화 (인수 생략 시 공백 문자열 사용)
mWriteln MACRO text:=<" ">
    mWrite text
    call Crlf
ENDM
```

#### 2) 관계 연산자와 상수 범위 검사 (`mGotoxyConst`)
- `IF` 지시어에서는 `LT`($<$), `GT`($>$), `EQ`($=$), `NE`($\ne$), `LE`($\le$), `GE`($\ge$) 관계 연산자만 사용할 수 있으며, 레지스터나 런타임 변수는 조건식에 쓸 수 없다.

```asm
; 상수 좌표 X (0 <= X < 80), Y (0 <= Y < 25) 유효성 검사 매크로
mGotoxyConst MACRO X:REQ, Y:REQ
    LOCAL ERRS
    ERRS = 0
    IF (X LT 0) OR (X GT 79)
        ECHO Warning: First argument to mGotoxy (X) is out of range.
        ERRS = 1
    ENDIF
    IF (Y LT 0) OR (Y GT 24)
        ECHO Warning: Second argument to mGotoxy (Y) is out of range.
        ERRS = ERRS + 1
    ENDIF
    IF ERRS GT 0
        EXITM
    ENDIF
    push edx
    mov  dh, Y
    mov  dl, X
    call Gotoxy
    pop  edx
ENDM
```

#### 3) 대소문자 구분 없는 심볼 비교 (`IFIDNI`)
- 레지스터 충돌을 방지할 때 유용하다. 아래 `mReadBuf`에서 두 번째 인수로 `EDX`가 들어오면 버퍼 주소가 덮어써지므로 이를 차단한다.

```asm
mReadBuf MACRO bufferPtr, maxChars
    IFIDNI <maxChars>, <EDX>
        ECHO Warning: Second argument to mReadBuf cannot be EDX
        EXITM
    ENDIF
    push ecx
    push edx
    mov  edx, bufferPtr
    mov  ecx, maxChars
    call ReadString
    pop  edx
    pop  ecx
ENDM
```

---

### 3.3 특수 연산자 (`&`, `<>`, `!`, `%`, 10.3.7)

| 연산자 | 명칭 | 역할 |
| :--- | :--- | :--- |
| `&` | 치환 연산자 (Substitution) | 문자열 리터럴 내부 등에서 매개변수 이름이 실제 인수로 치환되도록 강제 |
| `<>` | 리터럴 텍스트 연산자 (Literal-Text) | 쉼표, 공백, 특수기호가 포함된 여러 토큰을 하나의 텍스트 인수로 묶음 |
| `!` | 리터럴 문자 연산자 (Literal-Character) | `>`, `;`, `&` 등 전처리기 예약 기호를 일반 문자로 취급하도록 이스케이프 |
| `%` | 확장 연산자 (Expansion) | 텍스트 매크로나 상수 수식을 먼저 계산하여 그 결과 값을 텍스트로 변환 |

```asm
; 1. 치환 연산자(&) 예시
mShowRegister MACRO regName
    .data
    tempStr BYTE "&regName=", 0       ; ECX 전달 시 "ECX="로 치환됨
ENDM

; 2. 리터럴 텍스트(<>) 및 리터럴 문자(!) 연산자 예시
BadYValue TEXTEQU <Warning: Y-coordinate is !> 24>
ShowWarning MACRO message
    mWrite "&message"
ENDM
; 호출: ShowWarning BadYValue  ->  "Warning: Y-coordinate is > 24" 출력

; 3. 확장 연산자(%)와 @LINE 내장 매크로를 이용한 에러 줄 번호 출력
Mul32 MACRO op1, op2, product
    IFIDNI <op2>, <EAX>
        LINENUM TEXTEQU %(@LINE)
        % ECHO * Error on line LINENUM: EAX cannot be the second argument.
        EXITM
    ENDIF
    push eax
    mov  eax, op1
    mul  op2
    mov  product, eax
    pop  eax
ENDM
```

---

### 3.4 매크로 함수 (Macro Functions, 10.3.8)
- 매크로 함수는 어셈블리 명령어를 생성하는 대신 `EXITM <반환값>`을 통해 **상수(정수 또는 문자열)를 반환**한다. 호출 시에는 반드시 인수를 괄호 `()`로 감싸야 한다.

```asm
; 심볼 정의 여부를 확인하는 매크로 함수
IsDefined MACRO symbol
    IFDEF symbol
        EXITM <-1>              ; True (-1)
    ELSE
        EXITM <0>               ; False (0)
    ENDIF
ENDM

; 활용 예시 (HelloNew.asm): 명령행 옵션(ML -c -DRealMode=1)에 따라 16/32비트 모드 전환
INCLUDE Macros.inc

IF IsDefined( RealMode )
    INCLUDE Irvine16.inc
ELSE
    INCLUDE Irvine32.inc
ENDIF

.code
main PROC
    Startup
    mWrite <"This program can be assembled to run ",0dh,0ah>
    mWrite <"in both Real mode and Protected mode.",0dh,0ah>
    exit
main ENDP
END main
```

---

## 4. 반복 블록 정의 (Defining Repeat Blocks, 10.4)

MASM은 런타임이 아닌 **어셈블(전처리) 시점**에 코드나 데이터 선언문을 반복 생성하는 4가지 지시어를 제공한다.

### 4.1 `WHILE` 지시어 (10.4.1)
- 상수 불린 표현식이 참인 동안 블록 내부의 문장을 반복 생성한다.

```asm
; 어셈블 시점에 0F0000000h 미만의 피보나치 수열 테이블 생성
.data
val1 = 1
val2 = 1
DWORD val1                      ; 1
DWORD val2                      ; 1
val3 = val1 + val2

WHILE val3 LT 0F0000000h
    DWORD val3
    val1 = val2
    val2 = val3
    val3 = val1 + val2
ENDM
```

---

### 4.2 `REPEAT` 지시어 (10.4.2)
- 지정된 부호 없는 상수 정수 표현식 횟수만큼 블록을 고정 반복한다.

```asm
REPEAT 10
    inc eax
ENDM
```

---

### 4.3 `FOR` 지시어 (10.4.3)
- 쉼표로 구분된 심볼 리스트의 각 항목을 매개변수에 차례로 대입하며 블록을 반복 생성한다.

```asm
COURSE STRUCT
    Number  BYTE 9 DUP(?)
    Credits BYTE ?
COURSE ENDS

SEMESTER STRUCT
    Courses    COURSE 6 DUP(<>)
    NumCourses WORD ?
SEMESTER ENDS

.data
FOR semName, <Fall2013, Spring2014, Summer2014, Fall2014>
    semName SEMESTER <>
ENDM
; [전개 결과] Fall2013, Spring2014, Summer2014, Fall2014 구조체 변수 4개 생성
```

---

### 4.4 `FORC` 지시어 (10.4.4)
- 문자열에 포함된 **각 문자(Character)**를 하나씩 순회하며 블록을 반복 생성한다. 특수 문자가 포함될 경우 `!` 연산자를 함께 사용한다.

```asm
.data
Delimiters LABEL BYTE
FORC code, <@#$%^&*!<!>>
    BYTE "&code"
ENDM
; [전개 결과] '@', '#', '$', '%', '^', '&', '*', '<', '>' 9바이트 테이블 생성
```
