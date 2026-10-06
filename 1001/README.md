# 4장. Data Transfers, Addressing, and Arithmetic

## 4.1 Data Transfer Instructions (데이터 전송 명령어)

### 4.1.1 명령문 형식과 오퍼랜드 종류

```
[label:] mnemonic [operands] [ ; comment ]
```

| 형태 | 예 |
|---|---|
| 오퍼랜드 0개 | `mnemonic` |
| 오퍼랜드 1개 | `mnemonic [destination]` |
| 오퍼랜드 2개 | `mnemonic [destination],[source]` |
| 오퍼랜드 3개 | `mnemonic [destination],[source-1],[source-2]` |

**오퍼랜드 3종류**
- **Immediate**: 숫자 리터럴 표현식
- **Register**: CPU의 이름 있는 레지스터
- **Memory**: 메모리 위치 참조

**오퍼랜드 표기법 (Table 4-1, 32비트 모드)**

| 표기 | 의미 |
|---|---|
| `reg8` | 8비트 범용 레지스터 (AH, AL, BH, BL, CH, CL, DH, DL) |
| `reg16` | 16비트 범용 레지스터 (AX, BX, CX, DX, SI, DI, SP, BP) |
| `reg32` | 32비트 범용 레지스터 (EAX, EBX, ECX, EDX, ESI, EDI, ESP, EBP) |
| `reg` | 임의의 범용 레지스터 |
| `sreg` | 16비트 세그먼트 레지스터 (CS, DS, SS, ES, FS, GS) |
| `imm` / `imm8` / `imm16` / `imm32` | 즉시값 (크기 미지정 / 8 / 16 / 32비트) |
| `reg/mem8`, `reg/mem16`, `reg/mem32` | 해당 크기의 레지스터 또는 메모리 |
| `mem` | 8/16/32비트 메모리 오퍼랜드 |

### 4.1.3 Direct Memory Operands
- 변수 이름은 **데이터 세그먼트 내부의 오프셋**에 대한 참조.
- 예: `var1 BYTE 10h`가 오프셋 `10400h`에 있다면
  `mov al,var1` → 기계어 `A0 00010400`

### 4.1.4 MOV Instruction
```asm
MOV destination, source      ; dest = source;
```
**규칙**
1. 두 오퍼랜드는 **같은 크기**여야 한다.
2. 두 오퍼랜드가 **모두 메모리일 수 없다**.
3. 명령 포인터(IP, EIP, RIP)는 **목적지가 될 수 없다**.

**가능한 조합**: `reg,reg` / `mem,reg` / `reg,mem` / `mem,imm` / `reg,imm`

**메모리 → 메모리 이동**은 MOV 한 번으로 불가 → 레지스터를 거쳐야 한다.
```asm
.data
var1 WORD ?
var2 WORD ?
.code
mov ax,var1
mov var2,ax
```

**Overlapping Values** (AL ⊂ AX ⊂ EAX)
```asm
oneByte  BYTE  78h
oneWord  WORD  1234h
oneDword DWORD 12345678h

mov eax,0            ; EAX = 00000000h
mov al,oneByte       ; EAX = 00000078h
mov ax,oneWord       ; EAX = 00001234h
mov eax,oneDword     ; EAX = 12345678h
mov ax,0             ; EAX = 12340000h   ← 상위 16비트는 유지
```

### 4.1.5 Zero / Sign Extension (작은 값 → 큰 레지스터)
작은 값을 큰 레지스터로 `mov` 하면 **남은 상위 비트는 그대로 유지**된다.
```asm
signedVal SWORD -16        ; FFF0h
mov ecx,0
mov cx,signedVal           ; ECX = 0000FFF0h (+65,520)  ← 부호 의미 상실

mov ecx,0FFFFFFFFh
mov cx,signedVal           ; ECX = FFFFFFF0h (-16)      ← 우연히 맞음
```
→ 확장을 안전하게 하려면 `MOVZX` / `MOVSX`를 사용.

### MOVZX (Move with Zero-Extend)
- 상위 비트를 **0으로 채워** 16/32비트로 확장 → **부호 없는 수**용
```asm
MOVZX reg32, reg/mem8
MOVZX reg32, reg/mem16
MOVZX reg16, reg/mem8
```
```asm
mov bx,0A69Bh
movzx eax,bx     ; EAX = 0000A69Bh
movzx edx,bl     ; EDX = 0000009Bh
movzx cx,bl      ; CX  = 009Bh
```

### MOVSX (Move with Sign-Extend)
- 원본의 **최상위 비트(부호 비트)를 복사해** 채움 → **부호 있는 수**용
```asm
mov bx,0A69Bh
movsx eax,bx     ; EAX = FFFFA69Bh
movsx edx,bl     ; EDX = FFFFFF9Bh
mov bl,7Bh
movsx cx,bl      ; CX  = 007Bh      ← 부호 비트가 0이면 0으로 채움
```

### 4.1.6 LAHF / SAHF
| 명령 | 동작 |
|---|---|
| `LAHF` | EFLAGS **하위 바이트 → AH** |
| `SAHF` | **AH → EFLAGS 하위 바이트** |

```asm
lahf                 ; 플래그를 AH로
mov saveflags,ah     ; 변수에 저장
...
mov ah,saveflags     ; 저장했던 플래그 로드
sahf                 ; 플래그 레지스터로 복원
```

### 4.1.7 XCHG (Exchange)
- 두 오퍼랜드의 내용을 교환. 형태: `reg,reg` / `reg,mem` / `mem,reg` (**mem,mem 불가**)
```asm
xchg ax,bx        ; 16비트 레지스터 교환
xchg ah,al        ; 8비트 레지스터 교환
xchg var1,bx      ; 16비트 메모리와 BX 교환
xchg eax,ebx      ; 32비트 레지스터 교환
```
**두 메모리 값 교환 요령**
```asm
mov  ax,val1
xchg ax,val2
mov  val1,ax
```

### 4.1.8 Direct-Offset Operands
- 레이블이 없는 메모리 위치에 접근: **변수 이름 + 바이트 오프셋**
```asm
arrayB BYTE 10h,20h,30h,40h,50h
mov al,arrayB          ; AL = 10h
mov al,[arrayB+1]      ; AL = 20h
mov al,[arrayB+2]      ; AL = 30h

arrayW WORD 100h,200h,300h
mov ax,arrayW          ; AX = 100h
mov ax,[arrayW+2]      ; AX = 200h        ← WORD는 2바이트씩

arrayD DWORD 10000h,20000h
mov eax,arrayD         ; EAX = 10000h
mov eax,[arrayD+4]     ; EAX = 20000h     ← DWORD는 4바이트씩
mov eax,[arrayD+TYPE arrayD]   ; EAX = 20000h
```
> 💡 오프셋은 **원소 번호가 아니라 바이트 수**.

---

## 4.2 Addition and Subtraction

### INC / DEC
```asm
INC reg/mem      ; +1
DEC reg/mem      ; -1
```
```asm
myWord WORD 1000h
inc myWord       ; myWord = 1001h
mov bx,myWord
dec bx           ; BX = 1000h
```

### ADD
```asm
ADD dest, source     ; dest = dest + source (같은 크기)
```
- Source는 변하지 않고, 합이 destination에 저장된다.
- **CF, ZF, SF, OF, AC, PF**가 결과값에 따라 변경됨.
```asm
mov eax,var1       ; EAX = 10000h
add eax,var2       ; EAX = 30000h
```

### SUB / NEG
- `SUB dest, source` : dest = dest − source
- `NEG reg/mem` : **2의 보수**로 변환해 부호를 뒤집음 (플래그 CF, ZF, SF, OF, AC, PF 변경)

### 산술식 구현
`Rval = -Xval + (Yval - Zval);` (Xval=26, Yval=30, Zval=40)
```asm
mov eax,Xval
neg eax            ; EAX = -26
mov ebx,Yval
sub ebx,Zval       ; EBX = -10
add eax,ebx
mov Rval,eax       ; Rval = -36
```

### 상태 플래그 (Status Flags)

| 플래그 | 의미 |
|---|---|
| **CF** Carry | **부호 없는** 정수 오버플로 |
| **ZF** Zero | 결과가 0 |
| **SF** Sign | 결과가 음수 (최상위 비트 = 1) |
| **OF** Overflow | **부호 있는** 정수 오버플로 |
| **AC** Auxiliary Carry | 비트 3에서 올림/빌림 발생 |
| **PF** Parity | 결과 **최하위 바이트**의 1 비트 개수가 짝수 |

#### Zero Flag
```asm
mov ecx,1
sub ecx,1          ; ECX = 0, ZF = 1
mov eax,0FFFFFFFFh
inc eax            ; EAX = 0, ZF = 1
inc eax            ; EAX = 1, ZF = 0
dec eax            ; EAX = 0, ZF = 1
```
> ⚠️ **INC/DEC는 Carry flag에 영향을 주지 않는다.**
> ⚠️ **NEG를 0이 아닌 값에 적용하면 항상 CF = 1.**

#### Carry Flag
- **덧셈**: 결과가 목적지 크기를 넘으면 CF = 1
- **뺄셈**: 작은 부호 없는 수에서 큰 수를 빼면 CF = 1
```asm
mov al,0FFh
add al,1           ; AL = 00h, CF = 1

mov ax,00FFh
add ax,1           ; AX = 0100h, CF = 0   (16비트라 넘치지 않음)
mov ax,0FFFFh
add ax,1           ; AX = 0000h, CF = 1

mov al,1
sub al,2           ; AL = FFh, CF = 1
```

#### Auxiliary Carry / Parity
```asm
mov al,0Fh
add al,1           ; AC = 1   (비트 3 → 비트 4 올림)

mov al,10001100b
add al,00000010b   ; AL = 10001110b, PF = 1  (1이 4개 → 짝수)
sub al,10000000b   ; AL = 00001110b, PF = 0  (1이 3개 → 홀수)
```

#### Sign Flag
```asm
mov eax,4
sub eax,5          ; EAX = -1, SF = 1
mov bl,1
sub bl,2           ; BL = FFh (-1), SF = 1
```

#### Overflow Flag
- 부호 있는 연산의 결과가 목적지 범위를 넘거나(overflow) 모자랄 때(underflow) 설정.
```asm
mov al,+127
add al,1           ; OF = 1  (127+1 = 128 → 범위 초과)
mov al,-128
sub al,1           ; OF = 1
```
**The Addition Test**
- 양수 + 양수 = 음수 → 오버플로
- 음수 + 음수 = 양수 → 오버플로

**하드웨어의 OF 검출**: 최상위 비트에서 **밖으로 나가는 캐리**와 **최상위 비트로 들어오는 캐리**를 **XOR**한 값이 OF.

#### NEG와 Overflow
- 목적지에 올바르게 저장할 수 없으면 잘못된 결과 + OF = 1
```asm
mov al,-128
neg al             ; AL = 10000000b (그대로), OF = 1   ← +128은 8비트 부호 있는 수로 표현 불가
mov al,+127
neg al             ; AL = 10000001b (-127), OF = 0
```

> 💡 **CF vs OF**: 같은 연산에서 CF는 *unsigned*, OF는 *signed* 관점의 오류를 알려 준다. 어떤 해석으로 쓸지는 프로그래머가 결정.

### Example Program: AddSubTest (요약)
INC/DEC → 산술식 `Rval = -Xval + (Yval - Zval)` → ZF/SF/CF/OF 예제를 순서대로 실행하며 플래그 변화를 확인하는 프로그램.

---

## 4.3 Data-Related Operators and Directives

| 연산자/지시어 | 역할 |
|---|---|
| `OFFSET` | 변수의 **오프셋(주소)** 반환 |
| `ALIGN` | 변수를 특정 **경계에 정렬** |
| `PTR` | 오퍼랜드의 **기본 크기를 재정의** |
| `TYPE` | 원소 하나의 **크기(바이트)** |
| `LENGTHOF` | 배열의 **원소 개수** |
| `SIZEOF` | 배열이 차지하는 **전체 바이트 수** |
| `LABEL` | 저장 공간 할당 없이 **레이블 + 크기 속성** 부여 |

### OFFSET
- 데이터 세그먼트 시작에서 해당 레이블까지의 **바이트 거리**.
```asm
bVal  BYTE  ?      ; 00404000h
wVal  WORD  ?      ; 00404001h
dVal  DWORD ?      ; 00404003h
dVal2 DWORD ?      ; 00404007h

mov esi,OFFSET bVal     ; ESI = 00404000h
mov esi,OFFSET dVal2    ; ESI = 00404007h

myArray WORD 1,2,3,4,5
mov esi,OFFSET myArray + 4     ; ESI → 세 번째 원소

bigArray DWORD 500 DUP(?)
pArray   DWORD bigArray        ; pArray는 bigArray의 시작을 가리킴
```

### ALIGN
```asm
ALIGN bound      ; 1(byte), 2(word), 4(dword), 16(paragraph)
```
```asm
bVal  BYTE  ?     ; 00404000h
ALIGN 2
wVal  WORD  ?     ; 00404002h   (1바이트 건너뜀)
bVal2 BYTE  ?     ; 00404004h
ALIGN 4
dVal  DWORD ?     ; 00404008h
dVal2 DWORD ?     ; 0040400Ch
```
- **왜 정렬?** CPU는 짝수(정렬된) 주소의 데이터를 홀수 주소보다 더 빨리 처리한다.

### PTR
- 선언된 크기와 다른 크기로 접근할 때 사용.
```asm
myDouble DWORD 12345678h
mov ax,myDouble                 ; ❌ 크기 불일치 오류
mov ax,WORD PTR myDouble        ; ✅ AX = 5678h  (하위 워드)
mov bl,BYTE PTR myDouble        ; BL = 78h
mov ax,WORD PTR [myDouble+2]    ; AX = 1234h
mov WORD PTR myDouble,4321h     ; 하위 워드에 저장
```
**리틀 엔디안 메모리 배치 (`myDouble`)**

| 오프셋 | 값 |
|---|---|
| +0 | 78h |
| +1 | 56h |
| +2 | 34h |
| +3 | 12h |

### TYPE
| 표현식 | 값 |
|---|---|
| `TYPE var1` (BYTE) | 1 |
| `TYPE var2` (WORD) | 2 |
| `TYPE var3` (DWORD) | 4 |
| `TYPE var4` (QWORD) | 8 |

### LENGTHOF
- **같은 줄에 나타난 값들**로 정의된 배열의 원소 개수.

| 선언 | LENGTHOF |
|---|---|
| `byte1 BYTE 10,20,30` | 3 |
| `array1 WORD 30 DUP(?),0,0` | 30 + 2 |
| `array2 WORD 5 DUP(3 DUP(?))` | 5 × 3 |
| `array3 DWORD 1,2,3,4` | 4 |
| `digitStr BYTE "12345678",0` | 9 |

### SIZEOF
- `SIZEOF = LENGTHOF × TYPE`
```asm
intArray WORD 32 DUP(0)
mov eax,SIZEOF intArray      ; EAX = 64
```

### LABEL
- 저장 공간을 **새로 할당하지 않고** 같은 위치에 다른 크기 속성의 이름을 부여.
```asm
val16 LABEL WORD
val32 DWORD 12345678h
mov ax,val16            ; AX = 5678h
mov dx,[val16+2]        ; DX = 1234h

LongValue LABEL DWORD
val1 WORD 5678h
val2 WORD 1234h
mov eax,LongValue       ; EAX = 12345678h
```

---

## 4.4 Indirect Addressing (간접 주소 지정)

### Indirect Operands
- 레지스터에 **주소**를 담고 `[ ]`로 역참조(dereference).
```asm
byteVal BYTE 10h
mov esi,OFFSET byteVal
mov al,[esi]                 ; AL = 10h

inc [esi]                    ; ❌ 오류: operand must have size
inc BYTE PTR [esi]           ; ✅ 크기를 PTR로 명시
```

### Arrays 순회
```asm
; BYTE 배열: 포인터를 1씩 증가
arrayB BYTE 10h,20h,30h
mov esi,OFFSET arrayB
mov al,[esi]      ; 10h
inc esi
mov al,[esi]      ; 20h
inc esi
mov al,[esi]      ; 30h

; WORD 배열: 2씩 증가
arrayW WORD 1000h,2000h,3000h
mov esi,OFFSET arrayW
mov ax,[esi]      ; 1000h
add esi,2
mov ax,[esi]      ; 2000h
add esi,2
mov ax,[esi]      ; 3000h
```
**32비트 정수 합 (DWORD → 4씩 증가)**
```asm
arrayD DWORD 10000h,20000h,30000h
mov esi,OFFSET arrayD
mov eax,[esi]        ; 첫 번째
add esi,4
add eax,[esi]        ; 두 번째
add esi,4
add eax,[esi]        ; 세 번째  → EAX = 60000h
```

### Indexed Operands
- **상수 + 레지스터**로 유효 주소(effective address)를 만든다.
```
constant[reg]     ≡     [constant + reg]
arrayB[esi]       ≡     [arrayB + esi]
```
```asm
arrayB BYTE 10h,20h,30h
mov esi,0
mov al,arrayB[esi]       ; AL = 10h
```
**Displacement 더하기**
```asm
mov esi,OFFSET arrayW
mov ax,[esi]       ; 1000h
mov ax,[esi+2]     ; 2000h
mov ax,[esi+4]     ; 3000h
```
**16비트 레지스터 사용**
```asm
mov al,arrayB[si]
mov ax,arrayW[di]
mov eax,arrayD[bx]
```

### Scale Factors (배율)
- 인덱스 연산은 **원소 크기**를 고려해야 한다.
```asm
arrayD DWORD 100h,200h,300h,400h
mov esi,3 * TYPE arrayD        ; arrayD[3]의 오프셋 = 12
mov eax,arrayD[esi]            ; EAX = 400h

arrayD DWORD 1,2,3,4
mov esi,3                      ; 첨자(subscript)
mov eax,arrayD[esi*4]          ; EAX = 4
mov eax,arrayD[esi*TYPE arrayD]; EAX = 4   ← 이식성 좋음
```

### Pointers
- **다른 변수의 주소를 담는 변수**.
```asm
arrayB BYTE  10h,20h,30h,40h
arrayW WORD  1000h,2000h,3000h
ptrB   DWORD arrayB            ; = DWORD OFFSET arrayB
ptrW   DWORD arrayW
```

### TYPEDEF
- 사용자 정의 타입 생성 — 포인터 변수 정의에 특히 유용.
```asm
PBYTE  TYPEDEF PTR BYTE
PWORD  TYPEDEF PTR WORD
PDWORD TYPEDEF PTR DWORD

arrayB BYTE  10h,20h,30h
arrayW WORD  1,2,3
arrayD DWORD 4,5,6

ptr1 PBYTE  arrayB
ptr2 PWORD  arrayW
ptr3 PDWORD arrayD

mov esi,ptr1
mov al,[esi]      ; 10h
mov esi,ptr2
mov ax,[esi]      ; 1
mov esi,ptr3
mov eax,[esi]     ; 4
```

---

## 4.5 JMP and LOOP Instructions

### 제어 이동의 종류
- **Unconditional Transfer**: 항상 새 위치로 이동 (`JMP`)
- **Conditional Transfer**: 조건에 따라 이동 (분기 로직)

### JMP
```asm
JMP destination      ; 코드 레이블 → 어셈블러가 오프셋으로 변환
```
```asm
top:
    ...
    jmp top          ; 무한 루프
```

### LOOP
- 정식 이름: *Loop According to ECX Counter*.
- **ECX를 자동으로 카운터**로 사용, 반복할 때마다 감소 → 0이 아니면 `destination`으로 점프.
```asm
mov ax,0
mov ecx,5
L1:
    inc ax
    loop L1          ; AX = 5
```

**Nested Loops** — 안쪽 루프가 ECX를 쓰므로 **바깥 카운트를 변수에 저장/복원**해야 한다.
```asm
.data
count DWORD ?
.code
    mov ecx,100          ; 바깥 루프 횟수
L1:
    mov count,ecx        ; 바깥 카운트 저장
    mov ecx,20           ; 안쪽 루프 횟수
L2:
    ...
    loop L2              ; 안쪽 반복
    mov ecx,count        ; 바깥 카운트 복원
    loop L1              ; 바깥 반복
```

### Summing an Integer Array
**절차**: ① 배열 주소를 레지스터에 → ② 루프 카운터 = 배열 길이 → ③ sum = 0 → ④ 루프 시작 레이블 → ⑤ 원소 더하기 → ⑥ 다음 원소로 포인터 이동 → ⑦ `LOOP`로 반복
```asm
.data
intarray DWORD 10000h,20000h,30000h,40000h
.code
main proc
    mov edi,OFFSET intarray   ; 1: EDI = 배열 주소
    mov ecx,LENGTHOF intarray ; 2: 루프 카운터
    mov eax,0                 ; 3: sum = 0
L1:                           ; 4: 루프 시작
    add eax,[edi]             ; 5: 정수 더하기
    add edi,TYPE intarray     ; 6: 다음 원소
    loop L1                   ; 7: ECX = 0 될 때까지
    invoke ExitProcess,0      ; EAX = 100000h
main endp
end main
```

### Copying a String
```asm
.data
source byte "This is the source string",0
target byte SIZEOF source DUP(0),0
.code
main proc
    mov esi,0                 ; 인덱스 레지스터
    mov ecx,SIZEOF source     ; 루프 카운터
L1:
    mov al,source[esi]        ; source에서 문자 읽기
    mov target[esi],al        ; target에 저장
    inc esi                   ; 다음 문자
    loop L1                   ; 문자열 끝까지 반복
    invoke ExitProcess,0
main endp
end main
```
> 메모리→메모리 복사가 안 되므로 **AL을 중간 저장소**로 사용.
