# 9장. Strings and Arrays - Review Questions and Programming Exercises

## 9.9 Review Questions and Exercises

### 9.9.1 Short Answer

**1. Which Direction flag setting causes index registers to move
backward through memory when executing string primitives?**

-   답: 방향 플래그가 설정된 상태(DF = 1, `STD` 명령어)이면 ESI와 EDI가
    감소하여 높은 주소에서 낮은 주소 방향으로 이동한다.

**2. When a repeat prefix is used with STOSW, what value is added to or
subtracted from the index register?**

-   답: 2. `STOSW`는 워드(2바이트) 단위로 저장하므로 DF = 0이면 EDI에
    2를 더하고 DF = 1이면 2를 뺀다.

**3. In what way is the CMPS instruction ambiguous?**

-   답: 오퍼랜드가 명시되지 않아 어느 쪽이 source이고 어느 쪽이
    target인지 헷갈리기 쉽다. 실제로는 `[ESI]`를 `[EDI]`와 비교하며,
    `CMP [ESI],[EDI]`를 실행한 것처럼 플래그가 설정된다.

**4. When the Direction flag is clear and SCASB has found a matching
character, where does EDI point?**

-   답: 일치한 문자의 바로 다음 위치(일치한 문자 + 1)를 가리킨다. 그래서
    일치한 문자의 주소가 필요하면 `DEC EDI`로 되돌려야 한다.

**5. When scanning an array for the first occurrence of a particular
character, which repeat prefix would be best?**

-   답: `REPNE`(`REPNZ`). 값이 같지 않은 동안 반복하다가 처음 일치하는
    문자를 만나면 멈춘다.

**6. What Direction flag setting is used in the Str_trim procedure from
Section 9.3?**

-   답: 방향 플래그를 설정하지 않는다. `Str_trim`은 문자열 기본 명령어를
    쓰지 않고 `DEC EDI`로 직접 뒤로 이동한다. 뒤로 이동한다는 점에서 DF
    = 1(`STD`)과 같은 방향이다.

**7. Why does the Str_trim procedure from Section 9.3 use the JNE
instruction?**

-   답: 문자열 끝에서부터 거꾸로 검사하다가 제거할 문자가 아닌 첫 문자를
    만나면 반복을 멈추기 위해서이다. 그 위치(L2)로 점프하여 바로 뒤에 널
    바이트를 넣는다.

**8. What happens in the Str_ucase procedure from Section 9.3 if the
target string contains a digit?**

-   답: 아무 변화가 없다. 숫자의 ASCII 코드(30h\~39h)는 `'a'`(61h)보다
    작아서 `JB`로 변환을 건너뛴다.

**9. If the Str_length procedure from Section 9.3 used SCASB, which
repeat prefix would be most appropriate?**

-   답: `REPNE`. AL = 0으로 두고 널 바이트와 같아질 때까지 반복한다.

**10. If the Str_length procedure from Section 9.3 used SCASB, how would
it calculate and return the string length?**

-   답: ECX를 최댓값(0FFFFFFFFh)으로 두고 널 바이트를 찾을 때까지
    스캔한다. 널 바이트까지 (길이 + 1)번 스캔하므로
    `ECX = 0FFFFFFFEh - 길이`가 되고, `길이 = 0FFFFFFFEh - ECX`를 EAX로
    반환한다.

``` asm
mov edi,pString
mov al,0                    ; 찾을 문자: 널 바이트
mov ecx,0FFFFFFFFh          ; 최대 검색 횟수
cld
repne scasb                 ; 널 바이트를 찾을 때까지 반복
mov eax,0FFFFFFFEh
sub eax,ecx                 ; EAX = 문자열 길이
```

**11. What is the maximum number of comparisons needed by the binary
search algorithm when an array contains 1,024 elements?**

-   답: 10번. 비교할 때마다 검색 범위가 절반으로 줄어들고
    (`\log`{=tex}\_2(1024)=10)이다. (교재 Table 9-6 기준)

**12. In the FillArray procedure from the Binary Search example in
Section 9.5, why must the Direction flag be cleared by the CLD
instruction?**

-   답: `STOSD`가 EDI를 DF에 따라 증가 또는 감소시키기 때문이다. DF =
    0이어야 EDI가 배열의 앞에서 뒤로 증가하며 채워지고, DF = 1이면 배열
    앞쪽의 메모리를 덮어쓰게 된다.

**13. In the BinarySearch procedure from Section 9.5, why could the
statement at label L2 be removed without affecting the outcome?**

-   답: L2의 `CMP EDX,EDI`는 바로 앞에서 실행한 `CMP EDX,EDI`와 같은
    비교이다. 그 사이의 `JGE`는 플래그를 바꾸지 않으므로 이전 비교의
    플래그가 그대로 남아 있어 `JLE`가 그 플래그를 그대로 쓸 수 있다.

**14. In the BinarySearch procedure from Section 9.5, how might the
statement at label L4 be eliminated?**

-   답: L4는 `JMP L1`이다. L4로 점프하던 두 `JMP L4`를 `JMP L1`로 바꾸면
    L4 문장이 필요 없다.

------------------------------------------------------------------------

### 9.9.2 Algorithm Workbench

**1. Show an example of a base-index operand in 32-bit mode.**

-   답: 두 레지스터를 더한 주소를 사용한다.

``` asm
mov al,[ebx + esi]
```

**2. Show an example of a base-index-displacement operand in 32-bit
mode.**

-   답: 배열 이름(변위)에 베이스와 인덱스 레지스터를 더한다.

``` asm
mov eax,tableD[ebx + esi*TYPE tableD]
```

**3. Suppose a two-dimensional array of doublewords has three logical
rows and four logical columns. Write an expression using ESI and EDI
that addresses the third column in the second row.**

-   답: ESI에는 두 번째 행의 오프셋(1 × 4열 × 4바이트 = 16), EDI에는 세
    번째 열의 인덱스(2)를 넣고 `[ESI + EDI*4]`로 접근한다.

``` asm
mov esi,OFFSET myArray
add esi,16                   ; 두 번째 행의 시작 주소
mov edi,2                    ; 세 번째 열의 인덱스
mov eax,[esi + edi*4]        ; 배열의 세 번째 열
```

**4. Write instructions using CMPSW that compare two arrays of 16-bit
values named sourcew and targetw.**

-   답: DF를 지우고 `REPE CMPSW`로 값이 같은 동안 비교한다. 끝난 뒤 ZF =
    1이면 두 배열이 같다.

``` asm
cld
mov esi,OFFSET sourcew
mov edi,OFFSET targetw
mov ecx,LENGTHOF sourcew
repe cmpsw
```

**5. Write instructions that use SCASW to scan for the 16-bit value
0100h in an array named wordArray, and copy the offset of the matching
member into the EAX register.**

-   답: `REPNE SCASW`로 검색한다. 일치하면 EDI가 일치한 원소의 다음
    위치를 가리키므로 2를 빼서 EAX에 복사한다.

``` asm
cld
mov edi,OFFSET wordArray
mov ax,0100h
mov ecx,LENGTHOF wordArray
repne scasw
jnz notFound                ; 못 찾음
sub edi,2                   ; 일치한 원소로 되돌림
mov eax,edi                 ; 일치한 원소의 오프셋
notFound:
```

**6. Write a sequence of instructions that use the Str_compare procedure
to determine the larger of two input strings and write it to the console
window.**

-   답: `Str_compare`는 CMP처럼 플래그를 설정한다. `JA`로 string1 \>
    string2이면 string1을, 아니면 string2를 출력한다.

``` asm
.data
string1 BYTE "Apple",0
string2 BYTE "Banana",0
.code
    INVOKE Str_compare, ADDR string1, ADDR string2
    ja L1                       ; string1 > string2
    mov edx,OFFSET string2
    jmp L2
L1: mov edx,OFFSET string1
L2: call WriteString
    call Crlf
```

**7. Show how to call the Str_trim procedure and remove all trailing "@"
characters from a string.**

-   답:

``` asm
INVOKE Str_trim, ADDR myString, '@'
```

**8. Show how to modify the Str_ucase procedure from the Irvine32
library so it changes all characters to lower case.**

-   답: 검사 범위를 `'A'`\~`'Z'`로 바꾸고, 비트 5를 AND로 지우는 대신
    OR로 1로 설정한다.

``` asm
Str_lcase PROC USES eax esi,
    pString:PTR BYTE
    mov esi,pString
L1:
    mov al,[esi]
    cmp al,0                    ; 문자열 끝?
    je L3
    cmp al,'A'
    jb L2
    cmp al,'Z'
    ja L2
    or BYTE PTR [esi],00100000b ; 소문자로 변환
L2: inc esi
    jmp L1
L3: ret
Str_lcase ENDP
```

**9. Create a 64-bit version of the Str_trim procedure.**

-   답: Irvine64 방식으로 스택 매개변수 대신 레지스터를 사용한다. RCX는
    문자열 주소, DL은 제거할 문자이다. `Str_length`(64비트)는 RCX로
    주소를 받고 RAX로 길이를 반환한다.

``` asm
Str_trim PROC USES rbx rdi
    mov rdi,rcx
    mov bl,dl                   ; 제거할 문자 보관
    call Str_length             ; RAX = 문자열 길이
    cmp rax,0
    je L3                       ; 빈 문자열
    mov rcx,rax
    dec rax
    add rdi,rax                 ; 마지막 문자를 가리킴
L1:
    mov al,[rdi]
    cmp al,bl                   ; 제거할 문자인가?
    jne L2
    dec rdi
    loop L1
L2:
    mov BYTE PTR [rdi+1],0      ; 널 바이트 삽입
L3:
    ret
Str_trim ENDP
```

**10. Show an example of a base-index operand in 64-bit mode.**

-   답: 64비트 모드에서는 64비트 레지스터를 사용해야 한다.

``` asm
mov rax,[rbx + rsi]
```

**11. Assuming that EBX contains a row index into a two-dimensional
array of 32-bit integers named myArray and EDI contains the index of a
column, write a single statement that moves the content of the given
array element into the EAX register.**

-   답: 배열 이름을 변위로, EBX를 행 오프셋(행 번호 × 행 크기)으로,
    EDI를 열 인덱스로 사용하고 32비트 정수이므로 TYPE(4)을 곱한다.

``` asm
mov eax,myArray[ebx + edi*TYPE myArray]
```

**12. Assuming that RBX contains a row index into a two-dimensional
array of 64-bit integers named myArray and RDI contains the index of a
column, write a single statement that moves the content of the given
array element into the RAX register.**

-   답: 64비트 정수이므로 TYPE은 8이다.

``` asm
mov rax,myArray[rbx + rdi*TYPE myArray]
```

------------------------------------------------------------------------

## 9.10 Programming Exercises

각 문자열 처리 프로시저는 널 종료 문자열(null-terminated string)을
사용한다고 가정한다. 문제에서 별도로 요구하지 않더라도 새 프로시저를
테스트하는 짧은 드라이버 프로그램을 작성한다.

### 1. ★ Improved Str_copy Procedure

**문제 요약**

기존 `Str_copy`는 복사할 문자 수를 제한하지 않는다. 최대 복사 문자 수를
나타내는 입력 매개변수를 추가한 `Str_copyN`을 작성한다.

-   답: 원본 길이와 최대 문자 수 중 작은 값만큼 복사하고 널 바이트를
    붙인다.
-   대상 버퍼는 최대 문자 수 + 1바이트 이상이어야 한다.
-   예제의 호출은 최대 8문자를 복사한다.

``` asm
Str_copyN PROTO,
    source:PTR BYTE,
    target:PTR BYTE,
    maxChars:DWORD

.data
src BYTE "Assembly Language",0
dst BYTE 20 DUP(?)

.code
main PROC
    INVOKE Str_copyN, ADDR src, ADDR dst, 8
    mov edx,OFFSET dst
    call WriteString
    call Crlf
    exit
main ENDP

Str_copyN PROC USES eax ecx esi edi,
    source:PTR BYTE,
    target:PTR BYTE,
    maxChars:DWORD
    INVOKE Str_length, source   ; EAX = 원본 길이
    mov ecx,maxChars
    cmp eax,ecx
    jae L1                      ; 원본이 더 길면 maxChars만 복사
    mov ecx,eax                 ; 원본이 더 짧으면 원본 길이만큼
L1:
    mov esi,source
    mov edi,target
    cld
    rep movsb                   ; ECX = 0이면 복사하지 않음
    mov BYTE PTR [edi],0        ; 널 바이트 추가
    ret
Str_copyN ENDP
```

**실행 과정** 1. `Str_length`로 원본 문자열의 길이를 EAX에 구한다. 2.
ECX에 최대 복사 문자 수를 저장한다. 3. 원본 길이가 최대 문자 수보다
크거나 같으면 ECX의 최대 문자 수를 유지한다. 4. 원본 길이가 더 짧으면
ECX를 원본 길이로 변경한다. 5. `REP MOVSB`로 지정된 문자 수만큼
복사한다. 6. 복사한 문자열 끝에 널 바이트를 추가한다.

### 2. ★★ Str_concat Procedure

**문제 요약**

`Str_concat`은 source 문자열을 target 문자열의 끝에 이어 붙인다.
target에는 새 문자열을 저장할 충분한 공간이 있어야 하며, 두 문자열의
주소를 전달한다.

``` asm
.data
targetStr BYTE "ABCDE",10 DUP(0)
sourceStr BYTE "FGH",0
.code
INVOKE Str_concat, ADDR targetStr, ADDR sourceStr
```

-   답: target의 널 바이트 위치를 구한 뒤, source를 널 바이트까지 그
    위치에 복사한다.
-   실행 결과: `ABCDEFGH`

``` asm
Str_concat PROTO,
    pTarget:PTR BYTE,
    pSource:PTR BYTE

.data
targetStr BYTE "ABCDE",10 DUP(0)
sourceStr BYTE "FGH",0

.code
main PROC
    INVOKE Str_concat, ADDR targetStr, ADDR sourceStr
    mov edx,OFFSET targetStr
    call WriteString
    call Crlf
    exit
main ENDP

Str_concat PROC USES eax ecx esi edi,
    pTarget:PTR BYTE,
    pSource:PTR BYTE
    INVOKE Str_length, pTarget
    mov edi,pTarget
    add edi,eax                 ; EDI = target의 널 바이트 위치
    INVOKE Str_length, pSource
    mov ecx,eax
    inc ecx                     ; 널 바이트까지 복사
    mov esi,pSource
    cld
    rep movsb
    ret
Str_concat ENDP
```

**실행 과정** 1. target 문자열 길이를 구한다. 2. target 시작 주소에
길이를 더해 기존 널 바이트 위치를 찾는다. 3. source 문자열 길이를 구하고
널 바이트까지 복사하도록 ECX를 1 증가시킨다. 4. `REP MOVSB`로 source
문자열 전체를 target 끝에 복사한다.

### 3. ★★ Str_remove Procedure

**문제 요약**

`Str_remove`는 문자열에서 지정한 위치부터 n개의 문자를 제거한다. 삭제
시작 위치의 주소와 삭제할 문자 수를 전달한다.

``` asm
.data
target BYTE "abcxxxxdefghijklmop",0
.code
INVOKE Str_remove, ADDR [target+3], 4
```

-   답: 삭제 위치 + n부터 널 바이트까지를 삭제 위치로 앞당겨 복사한다.
-   남은 길이가 n 이하이면 그 위치에 널 바이트만 넣는다.
-   실행 결과: `abcdefghijklmop`

``` asm
Str_remove PROTO,
    pStart:PTR BYTE,
    nChars:DWORD

.data
target BYTE "abcxxxxdefghijklmop",0

.code
main PROC
    INVOKE Str_remove, ADDR [target+3], 4
    mov edx,OFFSET target
    call WriteString
    call Crlf
    exit
main ENDP

Str_remove PROC USES eax ecx esi edi,
    pStart:PTR BYTE,
    nChars:DWORD
    INVOKE Str_length, pStart   ; EAX = 삭제 위치부터 남은 길이
    mov edi,pStart
    mov ecx,nChars
    cmp ecx,eax
    jb L1                       ; n < 남은 길이
    mov BYTE PTR [edi],0        ; 남은 문자를 모두 삭제
    jmp L2
L1:
    mov esi,edi
    add esi,ecx                 ; ESI = 삭제 구간 바로 뒤
    sub eax,ecx                 ; 남는 문자 수
    inc eax                     ; 널 바이트 포함
    mov ecx,eax
    cld
    rep movsb                   ; 앞으로 당겨 복사
L2:
    ret
Str_remove ENDP
```

**실행 과정** 1. 삭제 시작 위치부터 문자열 끝까지의 길이를 구한다. 2.
삭제할 문자 수가 남은 길이보다 크거나 같으면 삭제 위치에 널 바이트를
넣어 나머지를 모두 제거한다. 3. 삭제할 문자 수가 더 작으면 ESI를 삭제
구간 바로 뒤로 이동한다. 4. 삭제 후 남는 문자 수에 널 바이트를 더해 복사
횟수를 계산한다. 5. `REP MOVSB`로 뒤쪽 문자열을 삭제 위치 앞으로
복사한다.

### 4. ★★★ Str_find Procedure

**문제 요약**

`Str_find`는 target 문자열 안에서 source 문자열이 처음 나타나는 위치를
검색한다.

-   일치하면 Zero Flag를 설정하고 EAX에 target 안의 일치 위치를
    반환한다.
-   일치하지 않으면 Zero Flag를 해제하고 EAX는 정의되지 않는다.

``` asm
.data
target BYTE "123ABC342432",0
source BYTE "ABC",0
pos    DWORD ?
.code
INVOKE Str_find, ADDR source, ADDR target
jnz notFound
mov pos,eax                  ; store the position value
```

-   답: target의 각 시작 위치(0부터 target 길이 - source 길이까지)에서
    `REPE CMPSB`로 source 길이만큼 비교한다.
-   일치하면 EAX에 그 위치를 넣고 ZF를 1로, 못 찾으면 ZF를 0으로 만든다.
-   source는 빈 문자열이 아니라고 가정한다.
-   예제에서 일치하는 위치는 target의 `A`가 시작되는 주소이다.

``` asm
Str_find PROTO,
    pSource:PTR BYTE,
    pTarget:PTR BYTE

.data
target BYTE "123ABC342432",0
source BYTE "ABC",0
pos    DWORD ?

.code
main PROC
    INVOKE Str_find, ADDR source, ADDR target
    jnz notFound
    mov pos,eax                 ; 일치 위치 (target + 3)
    mov edx,eax
    call WriteString
    call Crlf
notFound:
    exit
main ENDP

Str_find PROC USES ebx ecx edx esi edi,
    pSource:PTR BYTE,
    pTarget:PTR BYTE
    INVOKE Str_length, pSource
    mov edx,eax                 ; EDX = source 길이
    INVOKE Str_length, pTarget
    sub eax,edx                 ; 마지막 시작 위치 = target 길이 - source 길이
    jb NotFound                 ; source가 더 길면 실패
    inc eax                     ; EAX = 시작 가능한 위치 수
    mov ebx,pTarget             ; EBX = 현재 비교 시작 위치
L1:
    mov esi,pSource
    mov edi,ebx
    mov ecx,edx                 ; source 길이만큼 비교
    cld
    repe cmpsb
    je Found                    ; 모두 일치 (ZF = 1)
    inc ebx                     ; 다음 위치
    dec eax
    jnz L1
NotFound:
    or eax,1                    ; ZF = 0
    ret
Found:
    mov eax,ebx                 ; 일치한 위치
    cmp eax,eax                 ; ZF = 1 보장
    ret
Str_find ENDP
```

**실행 과정** 1. source와 target의 문자열 길이를 각각 구한다. 2.
target에서 source가 시작할 수 있는 마지막 위치를 계산한다. 3. target의
첫 위치부터 source 길이만큼 `REPE CMPSB`로 비교한다. 4. 일치하면 EAX에
현재 target 위치를 저장하고 반환한다. 5. 일치하지 않으면 다음 target
위치로 이동하여 다시 비교한다. 6. 가능한 위치를 모두 확인해도 일치하지
않으면 실패 상태로 반환한다.

## 5. ★★ Str_nextWord Procedure

**문제:** 문자열에서 구분 문자를 찾으면 널 바이트로 바꾸고, EAX에 구분
문자 다음 문자의 주소를 반환한다. 찾으면 ZF=1, 못 찾으면 ZF=0이다.

``` asm
Str_nextWord PROC USES edi,
    pString:PTR BYTE, delimiter:BYTE
    mov edi,pString
    mov al,delimiter
L1:
    cmp BYTE PTR [edi],0
    je L2
    cmp BYTE PTR [edi],al
    je L3
    inc edi
    jmp L1
L2:
    cmp BYTE PTR [edi],1       ; ZF=0
    ret
L3:
    mov BYTE PTR [edi],0
    lea eax,[edi+1]
    cmp eax,eax                ; ZF=1
    ret
Str_nextWord ENDP
```

**호출 예시**

``` asm
.data
target BYTE "Johnson,Calvin",0
.code
INVOKE Str_nextWord, ADDR target, ','
jnz notFound
mov edx,OFFSET target
call WriteString              ; Johnson
mov edx,eax
call WriteString              ; Calvin
```

**설명:** EDI로 문자열을 한 글자씩 검사한다. 구분 문자를 만나면 그
자리에 0을 저장해 문자열을 둘로 나누고, EAX에 다음 단어의 주소를 넣는다.

------------------------------------------------------------------------

## 6. ★★ Constructing a Frequency Table

**문제:** 문자열에 포함된 각 문자의 등장 횟수를 ASCII 코드에 해당하는
인덱스에 저장한다. 빈도 테이블은 DWORD 256개이다.

``` asm
Get_frequencies PROC USES eax ebx esi edi,
    pString:PTR BYTE, pTable:PTR DWORD
    mov esi,pString
    mov edi,pTable
L1:
    movzx eax,BYTE PTR [esi]
    cmp eax,0
    je L2
    mov ebx,eax
    shl ebx,2                  ; ASCII 코드 * DWORD 크기(4)
    inc DWORD PTR [edi+ebx]
    inc esi
    jmp L1
L2:
    ret
Get_frequencies ENDP
```

**호출 예시**

``` asm
.data
target BYTE "AAEBDCFBBC",0
freqTable DWORD 256 DUP(0)
.code
INVOKE Get_frequencies, ADDR target, ADDR freqTable
; A의 빈도는 freqTable[41h*4]에 저장
```

**설명:** 문자열의 문자를 하나씩 읽어 ASCII 코드로 바꾸고, 해당 인덱스의
DWORD 값을 1 증가시킨다. 널 바이트를 만나면 종료한다. 예시 문자열에서
A는 2회, B는 3회 등장한다.

------------------------------------------------------------------------

## 7. ★★★ Sieve of Eratosthenes

**문제:** 에라토스테네스의 체로 2\~65,000의 소수를 찾는다. BYTE 배열을
만들고 `STOSB`로 0을 채운 뒤 소수의 배수 위치를 1로 표시한다.

``` asm
.data
sieve BYTE 65001 DUP(?)
.code
main PROC
    cld
    mov edi,OFFSET sieve
    mov ecx,65001
    mov al,0
    rep stosb                  ; 배열을 0으로 초기화

    mov sieve[0],1
    mov sieve[1],1             ; 0과 1은 소수가 아님
    mov ebx,2

Outer:
    mov eax,ebx
    mul ebx                    ; EAX = EBX * EBX
    cmp eax,65000
    ja PrintPrimes
    mov edi,eax                ; 배수 표시를 EBX의 제곱부터 시작

Inner:
    cmp edi,65000
    ja NextNumber
    mov sieve[edi],1
    add edi,ebx
    jmp Inner

NextNumber:
    inc ebx
    jmp Outer

PrintPrimes:
    mov esi,2
PrintLoop:
    cmp esi,65000
    ja Done
    cmp sieve[esi],0
    jne Skip
    mov eax,esi
    call WriteDec
    call Crlf
Skip:
    inc esi
    jmp PrintLoop
Done:
    exit
main ENDP
```

**설명:** 2부터 각 수의 배수에 1을 표시한다. 마지막에 값이 0으로 남은
인덱스만 소수로 출력한다. 배수 표시를 해당 수의 제곱부터 시작하면 앞에서
이미 표시한 배수 작업을 줄일 수 있다.

------------------------------------------------------------------------

## 8. ★ Bubble Sort

**문제:** 안쪽 반복에서 값이 교환되면 플래그를 1로 설정한다. 한 번의
전체 pass에서 교환이 없으면 이미 정렬된 것이므로 조기 종료한다.

``` asm
BubbleSort PROC USES eax ebx ecx esi,
    pArray:PTR DWORD, Count:DWORD
    mov ecx,Count
    dec ecx
    jle Done
L1:
    mov ebx,0                  ; exchange flag
    push ecx
    mov esi,pArray
L2:
    mov eax,[esi]
    cmp eax,[esi+4]
    jle L3
    xchg eax,[esi+4]
    mov [esi],eax
    mov ebx,1                  ; 교환 발생
L3:
    add esi,4
    loop L2
    pop ecx
    cmp ebx,0
    je Done                    ; 교환이 없으면 종료
    loop L1
Done:
    ret
BubbleSort ENDP
```

**설명:** 매 pass 시작 시 EBX를 0으로 초기화한다. 교환이 발생하면 1로
바꾸고, pass가 끝난 뒤에도 0이면 정렬이 끝난 것이다.

------------------------------------------------------------------------

## 9. ★★ Binary Search

**문제:** `first`, `last`, `mid`를 메모리 변수가 아닌 레지스터로
관리한다. EAX는 찾은 인덱스 또는 -1을 반환한다.

-   ESI: first
-   EDI: last
-   EBX: mid

``` asm
BinarySearch PROC USES ebx esi edi edx,
    pArray:PTR DWORD, Count:DWORD, searchVal:DWORD
    mov esi,0
    mov edi,Count
    dec edi
L1:
    cmp esi,edi
    jg NotFound
    mov ebx,esi
    add ebx,edi
    shr ebx,1                  ; mid = (first + last) / 2

    mov edx,ebx
    shl edx,2                  ; mid * 4
    add edx,pArray
    mov eax,[edx]

    cmp eax,searchVal
    je Found
    jl RightHalf
    mov edi,ebx
    dec edi                    ; last = mid - 1
    jmp L1
RightHalf:
    mov esi,ebx
    inc esi                    ; first = mid + 1
    jmp L1
Found:
    mov eax,ebx
    ret
NotFound:
    mov eax,-1
    ret
BinarySearch ENDP
```

**설명:** 중간 원소와 검색 값을 비교한다. 중간 값이 작으면 오른쪽, 크면
왼쪽 절반만 검색한다. 검색 범위가 없어지면 -1을 반환한다.

------------------------------------------------------------------------

## 10. ★★★ Letter Matrix

**문제:** 모음이 선택될 확률이 50%인 대문자 4×4 행렬을 만들고 다섯 번
출력한다.

``` asm
.data
matrix BYTE 16 DUP(?)
vowels BYTE "AEIOU"
.code
MakeMatrix PROC USES eax ebx esi
    mov esi,0
L1:
    mov eax,2
    call RandomRange
    cmp eax,0
    jne Consonant

    mov eax,5
    call RandomRange
    mov bl,vowels[eax]
    jmp StoreChar

Consonant:
TryAgain:
    mov eax,26
    call RandomRange
    add al,'A'
    cmp al,'A'
    je TryAgain
    cmp al,'E'
    je TryAgain
    cmp al,'I'
    je TryAgain
    cmp al,'O'
    je TryAgain
    cmp al,'U'
    je TryAgain
    mov bl,al
StoreChar:
    mov matrix[esi],bl
    inc esi
    cmp esi,16
    jb L1
    ret
MakeMatrix ENDP
```

**호출 및 출력 구조**

``` asm
mov ecx,5
L1:
    push ecx
    call MakeMatrix
    ; matrix의 16개 문자를 4개씩 줄을 바꾸어 출력
    pop ecx
    loop L1
```

**설명:** 먼저 모음 또는 자음을 선택할지 50% 확률로 결정한다. 모음이면
`AEIOU` 중 하나를 고르고, 자음이면 A\~Z 중 모음이 아닌 문자를 다시
뽑는다. 생성된 16개 문자를 4×4 형태로 출력한다.

------------------------------------------------------------------------

## 11. ★★★★ Letter Matrix / Sets with Vowels

**문제:** 4×4 행렬의 각 행, 각 열, 두 대각선에서 네 글자씩 뽑는다.
모음이 정확히 두 개인 네 글자 집합만 출력한다.

**검사 프로시저**

``` asm
; ESI = 검사할 네 문자의 주소
CheckSet PROC USES eax ebx ecx esi
    mov ebx,0                  ; 모음 개수
    mov ecx,4
L1:
    mov al,[esi]
    cmp al,'A'
    je IsVowel
    cmp al,'E'
    je IsVowel
    cmp al,'I'
    je IsVowel
    cmp al,'O'
    je IsVowel
    cmp al,'U'
    jne NextChar
IsVowel:
    inc ebx
NextChar:
    inc esi
    loop L1
    cmp ebx,2                  ; ZF=1이면 모음이 정확히 2개
    ret
CheckSet ENDP
```

**행·열·대각선에 해당하는 인덱스** \| 집합 \| 행렬 인덱스 \|
\|---\|---\| \| 1행 \| 0, 1, 2, 3 \| \| 2행 \| 4, 5, 6, 7 \| \| 3행 \|
8, 9, 10, 11 \| \| 4행 \| 12, 13, 14, 15 \| \| 1열 \| 0, 4, 8, 12 \| \|
2열 \| 1, 5, 9, 13 \| \| 3열 \| 2, 6, 10, 14 \| \| 4열 \| 3, 7, 11, 15
\| \| 대각선 ↘ \| 0, 5, 10, 15 \| \| 대각선 ↙ \| 3, 6, 9, 12 \|

**설명:** 각 집합의 네 문자를 연속된 임시 공간에 모은 뒤 `CheckSet`을
호출한다. 반환 후 ZF=1이면 모음이 정확히 두 개이므로 그 네 문자를
출력한다. 행렬의 행은 연속된 메모리이지만 열은 4칸 간격으로 떨어져
있으므로 열은 임시 배열에 모아 검사한다.

------------------------------------------------------------------------

## 12. ★★★★ Calculating the Sum of an Array Row

**문제:** BYTE, WORD, DWORD 2차원 배열에서 지정한 한 행의 합을 계산한다.
스택 매개변수는 배열 주소, 행 크기(바이트), 원소 크기(1/2/4), 행
인덱스이며 결과는 EAX로 반환한다.

**BYTE 배열용 예시**

``` asm
.data
table BYTE 1,2,3,4
      BYTE 5,6,7,8
      BYTE 9,10,11,12
.code
; 두 번째 행의 합: 5+6+7+8 = 26
INVOKE calc_row_sum, ADDR table, 4, 1, 1

calc_row_sum PROC USES ebx ecx edx esi,
    pArray:PTR BYTE, rowSize:DWORD,
    elemSize:DWORD, rowIndex:DWORD

    mov esi,pArray
    mov eax,rowIndex
    mul rowSize                ; 행 시작 바이트 오프셋
    add esi,eax
    mov ecx,rowSize            ; BYTE 원소 개수
    xor eax,eax
L1:
    movzx edx,BYTE PTR [esi]
    add eax,edx
    inc esi
    loop L1
    ret
calc_row_sum ENDP
```

**설명:** 행 인덱스 × 행 크기로 해당 행의 시작 주소를 구한 다음, 그 행의
원소를 차례로 더한다.

> 주의: 위 코드는 BYTE 배열용 구현이다. WORD/DWORD 배열까지 처리하려면
> `elemSize`에 따라 원소 읽기 명령과 주소 이동 크기를 2 또는 4로 바꾸고,
> 행 크기와 원소 개수의 의미를 일관되게 처리해야 한다. 교재 문제는 세
> 자료형을 모두 테스트하도록 요구한다.

------------------------------------------------------------------------

## 13. ★★★ Trimming Leading Characters

**문제:** 문자열의 앞쪽에 연속해서 나타나는 지정 문자를 제거한다. 예:
`###ABC`에서 `#` 제거 → `ABC`.

``` asm
Str_trimLeading PROC USES eax esi edi,
    pString:PTR BYTE, charToRemove:BYTE
    mov esi,pString
    mov al,charToRemove
L1:
    cmp BYTE PTR [esi],al
    jne L2
    inc esi
    jmp L1
L2:
    mov edi,pString
L3:
    mov al,[esi]
    mov [edi],al
    inc esi
    inc edi
    cmp al,0
    jne L3
    ret
Str_trimLeading ENDP
```

**호출 예시**

``` asm
.data
target BYTE "###ABC",0
.code
INVOKE Str_trimLeading, ADDR target, '#'
```

**설명:** 문자열 앞에서 제거할 문자가 연속되는 동안 ESI를 이동한다. 제거
대상이 아닌 문자부터 널 바이트까지 원래 문자열의 시작 위치로 복사한다.

------------------------------------------------------------------------

## 14. ★★★ Trimming a Set of Characters

**문제:** 문자열 끝에서 필터 문자열에 포함된 문자들을 모두 제거한다. 예:
`ABC#$&`에서 필터 `%#!;$&*`에 해당하는 끝 문자를 제거하면 `ABC`가 된다.

``` asm
Str_trimSet PROC USES eax ebx esi edi,
    pString:PTR BYTE, pFilter:PTR BYTE
    mov edi,pString
L1:                              ; 널 바이트 찾기
    cmp BYTE PTR [edi],0
    je L2
    inc edi
    jmp L1
L2:
    dec edi                     ; 마지막 문자
CheckLast:
    cmp edi,pString
    jb Done
    mov al,[edi]
    mov esi,pFilter
CheckFilter:
    mov bl,[esi]
    cmp bl,0
    je KeepChar                 ; 필터에 없는 문자
    cmp al,bl
    je RemoveChar
    inc esi
    jmp CheckFilter
RemoveChar:
    dec edi
    jmp CheckLast
KeepChar:
    mov BYTE PTR [edi+1],0      ; 마지막 유효 문자 뒤에 널 바이트
Done:
    ret
Str_trimSet ENDP
```

**호출 예시**

``` asm
.data
target BYTE "ABC#$&",0
filter BYTE "%#!;$&*",0
.code
INVOKE Str_trimSet, ADDR target, ADDR filter
```

**설명:** 문자열의 마지막 문자부터 검사한다. 필터 문자열 안에서 해당
문자를 찾으면 한 칸 앞으로 이동해 다시 검사한다. 필터에 없는 문자를
만나면 그 바로 뒤에 널 바이트를 넣어 문자열을 끝낸다.
