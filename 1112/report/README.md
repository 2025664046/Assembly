# 9장. Strings and Arrays

## 1. String Primitive Instructions (문자열 기본 명령어)

문자열 기본 명령어는 메모리에 저장된 문자열이나 배열의 데이터를
처리한다. 32비트 모드에서는 ESI, EDI를 이용해 메모리 주소를 지정하고,
데이터 크기에 따라 AL, AX, EAX를 사용한다.

  레지스터        역할
  --------------- ------------------------------------
  ESI             원본 데이터(source)의 주소
  EDI             목적지 데이터(destination)의 주소
  AL / AX / EAX   데이터 크기에 따라 사용하는 누산기
  ECX             반복 횟수 카운터

### 1.1 String Primitive 명령어 종류

  -----------------------------------------------------------------------
  명령어                              동작
  ----------------------------------- -----------------------------------
  `MOVSB/MOVSW/MOVSD`                 ESI가 가리키는 데이터를 EDI가
                                      가리키는 곳으로 복사

  `CMPSB/CMPSW/CMPSD`                 ESI와 EDI가 가리키는 두 메모리 값
                                      비교

  `SCASB/SCASW/SCASD`                 AL/AX/EAX와 EDI가 가리키는 메모리
                                      값 비교

  `STOSB/STOSW/STOSD`                 AL/AX/EAX의 값을 EDI가 가리키는
                                      메모리에 저장

  `LODSB/LODSW/LODSD`                 ESI가 가리키는 메모리 값을
                                      AL/AX/EAX로 읽어옴
  -----------------------------------------------------------------------

-   B는 Byte(1바이트), W는 Word(2바이트), D는 Doubleword(4바이트)를
    의미한다.
-   문자열 명령어는 한 번 실행하면 기본적으로 데이터 하나만 처리한다.

### 1.2 반복 접두사 (Repeat Prefix)

반복 접두사를 사용하면 ECX를 카운터로 사용하여 문자열 명령어를 여러 번
실행할 수 있다.

  -----------------------------------------------------------------------
  접두사                  의미                    반복 조건
  ----------------------- ----------------------- -----------------------
  `REP`                   Repeat                  ECX가 0이 될 때까지

  `REPE` / `REPZ`         Repeat while Equal /    ECX가 0이 되거나 비교
                          Zero                    결과가 같지 않을 때까지

  `REPNE` / `REPNZ`       Repeat while Not Equal  ECX가 0이 되거나 비교
                          / Not Zero              결과가 같을 때까지
  -----------------------------------------------------------------------

#### 예제 1. 배열 전체 복사하기

``` asm
.data
source BYTE "HELLO"
target BYTE 5 DUP(?)

.code
    cld
    mov esi, OFFSET source
    mov edi, OFFSET target
    mov ecx, LENGTHOF source
    rep movsb
```

**예제가 하는 일** - ESI에 원본 배열의 시작 주소, EDI에 대상 배열의 시작
주소를 저장한다. - ECX에 복사할 바이트 수를 저장한다. - `REP MOVSB`가
ECX 횟수만큼 반복되어 source의 각 바이트를 target으로 복사한다.

### 1.3 Direction Flag (방향 플래그)

문자열 명령어 실행 후 ESI와 EDI가 증가할지 감소할지는 Direction
Flag(DF)에 따라 결정된다.

  명령어   동작
  -------- ---------------------------------------------
  `CLD`    DF를 0으로 설정하여 주소 증가 방향으로 처리
  `STD`    DF를 1로 설정하여 주소 감소 방향으로 처리

#### 예제 2. 정방향 복사

``` asm
    cld
    mov esi, OFFSET source
    mov edi, OFFSET target
    mov ecx, LENGTHOF source
    rep movsb
```

**예제가 하는 일**

`CLD`로 정방향 처리를 설정한다. `REP MOVSB`가 반복될 때마다 ESI와 EDI가
바이트 크기만큼 증가하므로 배열의 앞에서 뒤 방향으로 복사한다.

### 1.4 CMPS 명령어로 배열 비교하기

`CMPSB`, `CMPSW`, `CMPSD`는 ESI와 EDI가 가리키는 메모리 값을 비교한다.
`REPE CMPSD`는 비교한 값이 같은 동안 반복하며, 서로 다른 값이 발견되거나
ECX가 0이 되면 종료한다.

``` asm
    cld
    mov esi, OFFSET array1
    mov edi, OFFSET array2
    mov ecx, LENGTHOF array1
    repe cmpsd
```

**예제가 하는 일**

두 배열의 시작 주소를 ESI와 EDI에 저장하고, 비교할 원소 수를 ECX에
저장한다. 두 배열의 원소가 같은 동안 다음 원소를 계속 비교한다.

### 1.5 SCAS 명령어로 문자 검색하기

`SCASB`, `SCASW`, `SCASD`는 AL, AX, EAX의 값과 EDI가 가리키는 메모리
값을 비교한다.

#### 예제 3. 문자열에서 F 찾기

``` asm
.data
alpha BYTE "ABCDEF",0

.code
    cld
    mov edi, OFFSET alpha
    mov al, 'F'
    mov ecx, LENGTHOF alpha
    repne scasb
```

**예제가 하는 일**

AL에 찾을 문자 F를 저장하고, EDI가 가리키는 문자열의 문자와 비교한다.
`REPNE SCASB`는 같지 않은 동안 다음 문자로 이동하며 검색하고, F를 찾으면
반복을 종료한다.

### 1.6 STOS 명령어로 메모리 초기화하기

`STOSB`, `STOSW`, `STOSD`는 AL, AX, EAX의 값을 EDI가 가리키는 메모리에
저장한다.

#### 예제 4. 배열의 모든 바이트를 FFh로 초기화

``` asm
.data
string1 BYTE 10 DUP(?)

.code
    cld
    mov edi, OFFSET string1
    mov al, 0FFh
    mov ecx, LENGTHOF string1
    rep stosb
```

**예제가 하는 일**

AL에 `0FFh`를 저장한 다음 `REP STOSB`를 실행한다. ECX 횟수만큼 AL의 값이
배열에 저장되므로 모든 바이트가 FFh로 초기화된다.

### 1.7 LODS 명령어로 메모리 값 읽기

`LODSB`, `LODSW`, `LODSD`는 ESI가 가리키는 메모리 값을 AL, AX, EAX로
읽어온다.

  명령어      읽는 크기 저장 레지스터
  --------- ----------- ---------------
  `LODSB`       1바이트 AL
  `LODSW`       2바이트 AX
  `LODSD`       4바이트 EAX

``` asm
.data
array DWORD 10, 20, 30

.code
    cld
    mov esi, OFFSET array
    lodsd
```

**예제가 하는 일**

ESI가 가리키는 첫 번째 DWORD 값 10을 EAX로 읽어온다. 정방향이므로 실행
후 ESI는 다음 DWORD 위치로 이동한다.

------------------------------------------------------------------------

## 2. Selected String Procedures (문자열 처리 프로시저)

Irvine32 라이브러리는 널 종료 문자열(null-terminated string)을 처리하는
프로시저를 제공한다. 널 종료 문자열은 마지막에 널 문자 `0`을 저장하여
문자열의 끝을 나타낸다.

``` asm
string1 BYTE "Hello",0
```

### 2.1 Str_compare

`Str_compare`는 두 문자열을 첫 바이트부터 비교한다. 대문자와 소문자는
ASCII 코드가 다르므로 대소문자를 구분한다. 반환값 대신 Carry Flag와 Zero
Flag로 비교 결과를 확인한다.

  플래그     의미
  ---------- ------------------------------------------
  `ZERO?`    두 문자열이 같음
  `CARRY?`   첫 번째 문자열이 두 번째 문자열보다 작음
  둘 다 0    첫 번째 문자열이 두 번째 문자열보다 큼

``` asm
.data
string1 BYTE "Apple",0
string2 BYTE "Banana",0
msg1 BYTE "same",0
msg2 BYTE "string1 is less",0
msg3 BYTE "string2 is less",0

.code
    INVOKE Str_compare, ADDR string1, ADDR string2
    .IF ZERO?
        mov edx, OFFSET msg1
    .ELSEIF CARRY?
        mov edx, OFFSET msg2
    .ELSE
        mov edx, OFFSET msg3
    .ENDIF
    call WriteString
```

**예제가 하는 일**

두 문자열을 비교하고 플래그 상태에 따라 출력할 메시지를 선택한다.
`"Apple"`은 `"Banana"`보다 작으므로 `string1 is less`가 출력된다.

### 2.2 Str_length

`Str_length`는 문자열의 길이를 계산하여 EAX에 반환한다. 호출할 때
문자열의 주소를 전달하며, 끝의 널 문자 0은 길이에 포함하지 않는다.

``` asm
.data
string1 BYTE "Hello",0

.code
    INVOKE Str_length, ADDR string1
    call WriteDec
```

**예제가 하는 일**

문자열의 길이 5가 EAX에 저장되고 `WriteDec`가 그 값을 출력한다.

### 2.3 Str_copy

`Str_copy`는 원본 문자열을 대상 문자열로 복사한다. 대상 메모리는
문자열과 널 문자를 모두 저장할 수 있을 만큼 충분해야 한다.

``` asm
.data
source BYTE "Hello",0
target BYTE 20 DUP(?)

.code
    INVOKE Str_copy, ADDR source, ADDR target
    mov edx, OFFSET target
    call WriteString
```

**예제가 하는 일**

source의 문자열을 target으로 복사한 뒤, `WriteString`으로 복사된
문자열을 출력한다.

### 2.4 Str_trim

`Str_trim`은 문자열 끝부분에 연속해서 나타나는 지정 문자를 제거한다.
문자열의 끝에서부터 뒤로 이동하여 마지막 일반 문자를 찾고, 그 바로 뒤에
널 문자 0을 삽입한다. 문자열 중간에 있는 문자는 제거하지 않는다.

``` asm
.data
string1 BYTE "Hello////",0

.code
    INVOKE Str_trim, ADDR string1, '/'
    mov edx, OFFSET string1
    call WriteString
```

**예제가 하는 일**

문자열 끝에 연속된 `/`를 제거한다. 결과 문자열은 `Hello`이다.

  원래 문자열   처리 결과
  ------------- ------------
  빈 문자열     빈 문자열
  `Hello##`     `Hello`
  `#`           빈 문자열
  `Hello`       `Hello`
  `###Hello`    `###Hello`

### 2.5 Str_ucase

`Str_ucase`는 문자열의 영문자를 모두 대문자로 변환한다. 별도의 반환값은
없으며 전달한 문자열의 내용이 직접 변경된다.

``` asm
.data
string1 BYTE "hello world",0

.code
    INVOKE Str_ucase, ADDR string1
    mov edx, OFFSET string1
    call WriteString
```

**예제가 하는 일**

string1의 영문자를 대문자로 변경하므로 `HELLO WORLD`가 출력된다.

### 2.6 문자열 프로시저 정리

  프로시저        기능                     결과
  --------------- ------------------------ --------------------
  `Str_compare`   두 문자열 비교           플래그로 결과 확인
  `Str_length`    문자열 길이 계산         EAX에 길이 저장
  `Str_copy`      문자열 복사              대상 문자열 변경
  `Str_trim`      끝의 지정 문자 제거      원본 문자열 변경
  `Str_ucase`     영문자를 대문자로 변경   원본 문자열 변경

### 2.7 String Library Demo 예제

PDF의 String Library Demo는 문자열 끝의 `/`를 제거하고, 대문자로
변환하고, 두 문자열을 비교한 다음 길이를 출력한다.

``` asm
INCLUDE Irvine32.inc

.data
string_1 BYTE "abcde////",0
string_2 BYTE "ABCDE",0
msg0 BYTE "string_1 in upper case: ",0
msg1 BYTE "string_1 and string_2 are equal",0
msg2 BYTE "string_1 is less than string_2",0
msg3 BYTE "string_2 is less than string_1",0
msg4 BYTE "Length of string_2 is ",0
msg5 BYTE "string_1 after trimming: ",0

.code
main PROC
    call trim_string
    call upper_case
    call compare_strings
    call print_length
    exit
main ENDP

trim_string PROC
    INVOKE Str_trim, ADDR string_1, '/'
    mov edx, OFFSET msg5
    call WriteString
    mov edx, OFFSET string_1
    call WriteString
    call Crlf
    ret
trim_string ENDP

upper_case PROC
    mov edx, OFFSET msg0
    call WriteString
    INVOKE Str_ucase, ADDR string_1
    mov edx, OFFSET string_1
    call WriteString
    call Crlf
    ret
upper_case ENDP

compare_strings PROC
    INVOKE Str_compare, ADDR string_1, ADDR string_2
    .IF ZERO?
        mov edx, OFFSET msg1
    .ELSEIF CARRY?
        mov edx, OFFSET msg2
    .ELSE
        mov edx, OFFSET msg3
    .ENDIF
    call WriteString
    call Crlf
    ret
compare_strings ENDP

print_length PROC
    mov edx, OFFSET msg4
    call WriteString
    INVOKE Str_length, ADDR string_2
    call WriteDec
    call Crlf
    ret
print_length ENDP

END main
```

**실행 순서** 1. `trim_string`: string_1 끝의 `/` 제거 2. `upper_case`:
string_1을 대문자로 변환 3. `compare_strings`: string_1과 string_2 비교
후 메시지 출력 4. `print_length`: string_2의 길이를 계산하여 출력

------------------------------------------------------------------------

## 3. Two-Dimensional Arrays (2차원 배열)

2차원 배열은 행(row)과 열(column)로 구성된다. 메모리는 연속된 공간이므로
2차원 배열도 메모리에는 일렬로 저장된다.

### 3.1 Row-Major Order (행 우선 저장)

행 우선 저장은 첫 번째 행의 원소를 모두 저장한 다음 두 번째 행의 원소를
저장하는 방식이다.

``` text
배열:
1  2  3
4  5  6

메모리 저장 순서:
1 → 2 → 3 → 4 → 5 → 6
```

### 3.2 Base-Index Operand

Base-index operand는 두 레지스터의 값을 더하여 유효 주소를 계산한다.

``` asm
[base + index]
```

2차원 배열을 행 우선 방식으로 접근할 때 일반적으로 base 레지스터에는
선택한 행의 시작 주소를, index 레지스터에는 열의 위치를 저장한다.

#### 예제 1. 바이트 배열의 특정 원소 접근

``` asm
.data
matrix BYTE 1, 2, 3
       BYTE 4, 5, 6

.code
    mov ebx, OFFSET matrix
    mov eax, 1
    mov ecx, 3
    mul ecx
    add ebx, eax
    mov esi, 1
    mov al, [ebx + esi]
```

**예제가 하는 일**

-   EBX에 배열 시작 주소를 저장한다.
-   EAX의 행 번호 1과 ECX의 행 크기 3을 곱해 행 오프셋을 계산한다.
-   계산한 오프셋을 EBX에 더하여 두 번째 행의 시작 주소를 만든다.
-   ESI에 열 위치 1을 저장하고 `[EBX + ESI]`로 두 번째 행의 두 번째 원소
    5를 읽는다.

### 3.3 2차원 배열의 행 합계 계산

PDF의 `calc_row_sum`은 바이트 행렬에서 선택한 행의 모든 원소를 더한다.

``` asm
; Receives: EBX = table offset
;           EAX = row index
;           ECX = row size, in bytes
; Returns: EAX holds the sum.

calc_row_sum PROC USES ebx ecx edx esi
    mul ecx
    add ebx, eax
    mov eax, 0
    mov esi, 0

L1:
    movzx edx, BYTE PTR [ebx + esi]
    add eax, edx
    inc esi
    loop L1

    ret
calc_row_sum ENDP
```

**예제가 하는 일** 1. 행 번호와 행 크기를 곱해 선택한 행의 오프셋을
계산한다. 2. 배열 시작 주소에 행 오프셋을 더한다. 3. EAX를 0으로
초기화하여 합계를 저장한다. 4. ESI를 0으로 시작하여 해당 행의 각
바이트에 접근한다. 5. `MOVZX`로 바이트 값을 EDX에 읽어온 뒤 EAX에
더한다. 6. ESI를 1 증가시키고 `LOOP`로 행의 원소 수만큼 반복한다. 7.
최종 합계는 EAX에 저장된다.

### 3.4 WORD 배열의 주소 계산

WORD 배열은 원소 하나가 2바이트이므로 인덱스에 2를 곱해야 실제 바이트
오프셋을 구할 수 있다.

  자료형     원소 크기   인덱스 배율
  -------- ----------- -------------
  BYTE         1바이트             1
  WORD         2바이트             2
  DWORD        4바이트             4

``` asm
.data
array WORD 10, 20, 30, 40

.code
    mov esi, 2
    mov ax, [array + esi * 2]
```

**예제가 하는 일**

인덱스 2에 WORD의 크기 2를 곱해 4바이트 오프셋을 만든다. 따라서 세 번째
원소인 30을 AX로 읽는다.

### 3.5 Base-Index-Displacement Operand

Base-index-displacement operand는 변위(displacement), base 레지스터,
index 레지스터, 선택적인 scale을 함께 사용하여 유효 주소를 계산한다.

``` asm
[displacement + base + index * scale]
```

  구성 요소      의미
  -------------- -----------------------------------------
  Displacement   배열 또는 변수의 시작 주소, 상수 오프셋
  Base           행의 시작 위치 등을 저장
  Index          원소의 위치
  Scale          원소 크기에 맞춰 인덱스에 곱하는 값

#### 예제 2. DWORD 배열 접근

``` asm
.data
array DWORD 10, 20, 30, 40

.code
    mov esi, 2
    mov eax, array[esi * 4]
```

**예제가 하는 일**

DWORD는 4바이트이므로 인덱스 2에 4를 곱한다. 배열 시작 주소에서 8바이트
떨어진 세 번째 원소 30을 EAX로 읽는다.

------------------------------------------------------------------------

## 4. Searching and Sorting Integer Arrays (정수 배열 검색과 정렬)

정수 배열을 처리하는 대표적인 방법으로 버블 정렬(Bubble Sort)과 이진
탐색(Binary Search)이 있다.

### 4.1 Bubble Sort (버블 정렬)

버블 정렬은 인접한 두 원소를 비교하고, 정렬 순서와 반대라면 두 값을
교환하는 정렬 방법이다. 오름차순 정렬에서는 앞의 값이 뒤의 값보다 크면
교환한다.

#### 버블 정렬 진행 예제

초기 배열: `5, 3, 8, 1`

  단계         비교 및 처리                     배열
  ------------ -------------------------------- ------------
  시작         초기 상태                        5, 3, 8, 1
  1            5와 3 교환                       3, 5, 8, 1
  2            5와 8은 교환하지 않음            3, 5, 8, 1
  3            8과 1 교환                       3, 5, 1, 8
  1회전 종료   가장 큰 값 8이 마지막으로 이동   3, 5, 1, 8
  2회전        5와 1 교환                       3, 1, 5, 8
  3회전        3과 1 교환                       1, 3, 5, 8

한 번의 회전이 끝나면 가장 큰 값이 배열의 마지막 위치로 이동한다. 이
과정을 반복하면 배열 전체가 정렬된다. 원소가 n개라면 최대 n-1번의
회전으로 정렬할 수 있다.

### 4.2 BubbleSort 어셈블리 예제

``` asm
; Sort 32-bit signed integers in ascending order.
; Receives: pointer to array, array size
; Returns: nothing

BubbleSort PROC USES eax ecx esi,
    pArray:PTR DWORD,
    Count:DWORD

    mov ecx, Count
    dec ecx

L1:
    push ecx
    mov esi, pArray

L2:
    mov eax, [esi]
    cmp [esi+4], eax
    jg L3
    xchg eax, [esi+4]
    mov [esi], eax

L3:
    add esi, 4
    loop L2
    pop ecx
    loop L1

L4:
    ret
BubbleSort ENDP
```

**예제가 하는 일** 1. `Count - 1`을 ECX에 저장하여 바깥쪽 회전 횟수를
정한다. 2. L1에서 현재 회전 횟수를 스택에 저장하고 ESI를 배열 첫 위치로
설정한다. 3. L2에서 현재 원소를 EAX로 가져오고 다음 원소 `[ESI+4]`와
비교한다. 4. `JG L3`는 다음 원소가 더 크면 교환하지 않고 넘어간다는
뜻이다. 5. 순서가 반대라면 `XCHG`와 `MOV`로 두 원소를 교환한다. 6. ESI를
4 증가시켜 다음 DWORD 원소로 이동한다. 7. 안쪽 반복이 끝나면 저장한
ECX를 복원하고 다음 회전을 진행한다.

### 4.3 Binary Search (이진 탐색)

이진 탐색은 **이미 정렬된 배열**에서 원하는 값을 찾는 방법이다. 가운데
원소를 확인한 뒤 검색할 값이 왼쪽과 오른쪽 중 어느 쪽에 있는지 판단하여
검색 범위를 절반으로 줄인다.

#### 이진 탐색 순서

1.  검색 범위의 시작 위치를 `first`, 마지막 위치를 `last`로 정한다.
2.  `mid = (first + last) / 2`를 계산한다.
3.  가운데 원소와 검색 값 `searchVal`을 비교한다.
4.  같으면 검색에 성공하고 mid를 반환한다.
5.  검색 값이 더 크면 `first = mid + 1`로 변경한다.
6.  검색 값이 더 작으면 `last = mid - 1`로 변경한다.
7.  `first`가 `last`보다 커지면 검색 실패이다.

#### 예제 1. 이진 탐색 과정

``` text
배열:   1, 3, 5, 7, 9, 11, 13
인덱스: 0  1  2  3  4   5   6
검색 값: 7
```

  단계     first   last   mid   가운데 값 처리
  ------ ------- ------ ----- ----------- -------------------------
  1            0      6     3           7 검색 값과 같으므로 성공

가운데 인덱스 3의 값이 7이므로 검색에 성공한다. 이진 탐색은 정렬된
배열에서 검색 범위를 절반씩 줄인다.

### 4.4 BinarySearch 어셈블리 예제

``` asm
; Searches an array of signed integers.
; Returns: EAX = matching position, or -1 if not found.

BinarySearch PROC USES ebx edx esi edi,
    pArray:PTR DWORD,
    Count:DWORD,
    searchVal:DWORD

    LOCAL first:DWORD,
          last:DWORD,
          mid:DWORD

    mov first, 0
    mov eax, Count
    dec eax
    mov last, eax
    mov edi, searchVal
    mov ebx, pArray

L1:
    mov eax, first
    cmp eax, last
    jg L5

    mov eax, last
    add eax, first
    shr eax, 1
    mov mid, eax

    mov esi, mid
    shl esi, 2
    mov edx, [ebx+esi]

    cmp edx, edi
    jge L2

    mov eax, mid
    inc eax
    mov first, eax
    jmp L4

L2:
    cmp edx, edi
    jle L3

    mov eax, mid
    dec eax
    mov last, eax
    jmp L4

L3:
    mov eax, mid
    jmp L9

L4:
    jmp L1

L5:
    mov eax, -1

L9:
    ret
BinarySearch ENDP
```

**예제가 하는 일** 1. first를 0으로, last를 `Count - 1`로 초기화한다. 2.
EDI에 검색 값, EBX에 배열 시작 주소를 저장한다. 3. first가 last보다 크면
검색 범위가 없으므로 실패 처리로 이동한다. 4. `(first + last) / 2`를
계산하여 mid를 구한다. `SHR` 1회는 2로 나누는 효과가 있다. 5. DWORD
배열이므로 mid에 4를 곱해 실제 바이트 오프셋을 계산한다. 6.
`[EBX + ESI]`에서 가운데 원소를 EDX로 읽는다. 7. 검색 값이 더 크면
first를 `mid + 1`로, 더 작으면 last를 `mid - 1`로 변경한다. 8. 값이
같으면 mid를 EAX에 저장하여 반환한다. 9. 검색 범위가 없어지면 EAX에 -1을
저장하여 반환한다.

### 4.5 Bubble Sort와 Binary Search 비교

  -----------------------------------------------------------------------
  구분                    Bubble Sort             Binary Search
  ----------------------- ----------------------- -----------------------
  목적                    배열 정렬               배열에서 값 검색

  전제                    정렬 순서를 정함        배열이 이미 정렬되어
                                                  있어야 함

  핵심 동작               인접한 원소 비교 및     가운데 원소와 비교하여
                          교환                    범위 절반 축소

  결과                    정렬된 배열             찾은 위치 또는 -1
  -----------------------------------------------------------------------

### 4.6 전체 프로그램 처리 순서

PDF의 예제 프로그램은 다음 순서로 배열을 처리한다.

1.  배열에 임의의 정수를 채운다.
2.  배열을 출력한다.
3.  Bubble Sort로 배열을 정렬한다.
4.  정렬된 배열을 다시 출력한다.
5.  사용자에게 검색할 정수를 입력받는다.
6.  Binary Search로 값을 검색한다.
7.  검색 결과를 출력한다.

------------------------------------------------------------------------

## 5. 핵심 내용 정리

### 5.1 문자열 기본 명령어

  명령어    기능
  --------- ---------------------------
  `MOVS`    메모리에서 메모리로 복사
  `CMPS`    두 메모리 값 비교
  `SCAS`    누산기와 메모리 값 비교
  `STOS`    누산기 값을 메모리에 저장
  `LODS`    메모리 값을 누산기로 읽기
  `REP`     ECX가 0이 될 때까지 반복
  `REPE`    같을 동안 반복
  `REPNE`   같지 않을 동안 반복
  `CLD`     주소 증가 방향
  `STD`     주소 감소 방향

### 5.2 배열 처리 개념

  개념                 핵심 내용
  -------------------- ----------------------------------------------
  Row-major order      행 단위로 연속 저장
  Base-index operand   base와 index를 더해 주소 계산
  Scale                원소 크기에 맞춰 인덱스에 곱하는 값
  Bubble Sort          인접 원소를 비교하고 필요하면 교환
  Binary Search        가운데 값과 비교해 검색 범위를 절반으로 줄임

## 정리

-   문자열 기본 명령어는 ESI, EDI, 누산기 레지스터를 이용해 문자열과
    배열을 처리한다.
-   `REP`, `REPE`, `REPNE`를 사용하면 반복 작업을 간단하게 작성할 수
    있다.
-   `CLD`와 `STD`는 문자열 명령어의 주소 이동 방향을 결정한다.
-   Irvine32 라이브러리는 문자열 비교, 길이 계산, 복사, 끝 문자 제거,
    대문자 변환 프로시저를 제공한다.
-   2차원 배열은 메모리에 연속적으로 저장되며 행과 열의 위치를 이용해
    원소 주소를 계산한다.
-   버블 정렬은 인접 원소를 비교하고 교환하여 배열을 정렬한다.
-   이진 탐색은 정렬된 배열에서 가운데 원소를 기준으로 검색 범위를
    절반씩 줄인다.
