# 9월 3일 수업내용
# Chapter 1. Basic Concepts

## 1. Welcome to Assembly Language

### 1.1 언어의 계층 (Language Spectrum)

프로그래밍 언어는 하드웨어에 가까운 순서로 다음과 같이 나뉜다.

| 구분 | 특징 |
| --- | --- |
| **Machine Language** | 가장 초기 형태. 하드웨어와 직접 상호작용하는 2진 코드 |
| **Assembly Language** | 니모닉(mnemonic)을 사용해 기계어를 사람이 읽을 수 있게 만든 형태 |
| **High Level Language** | 가장 추상적이고 사용자 친화적. 간단한 문법으로 복잡한 연산 수행 |

### 1.2 1장에서 다루는 기초 개념

- **Language Spectrum** — 다른 언어들 사이에서 어셈블리어가 갖는 위치
- **Virtual Machine** — 소프트웨어와 하드웨어 계층 간의 관계
- **Numbering Systems** — 2진수·16진수 체계, 변환과 산술
- **Boolean Operations** — 이후 장에서 필요한 기본 불 연산

### 1.3 학습 환경

```
Assembly Language
├── Processors ......... Intel, AMD
├── Operating Systems . 32-bit Windows, 64-bit Windows
└── Assemblers ........ MASM, MASM32, NASM, GAS, TASM 등
                        (본 수업은 Visual Studio + MASM 사용)
```

### 1.4 어셈블리어를 배우는 이유 (Educational Value)

- Microcomputer Assembly Language
- Assembly Language Programming
- Introduction to Computer Architecture
- Fundamentals of Computer Systems
- Embedded Systems Programming

### 1.5 학습 성장 단계

| 단계 | 상태 |
| --- | --- |
| Beginner | 어셈블리 지식 없음 |
| Learn Basics | 컴퓨터 구조와 기계어 이해 |
| Assembly Language | 마이크로프로세서에서 테스트 가능한 수준 |
| MASM Assembler | 실무용 어셈블러 사용 능력 |
| Assembly Programmer | Intel 프로세서 패밀리에 대한 지식 보유 |

### 1.6 Questions You Might Ask

- 어셈블러와 링커란 무엇인가?
- MASM으로 어떤 종류의 프로그램을 만들 수 있는가?
- 어셈블리어는 기계어와 어떤 관계인가?
- C++, Java는 어셈블리어와 어떤 관계인가?
- 어셈블리어는 이식성(portable)이 있는가?
- 왜 어셈블리어를 배워야 하는가?

---

## 2. Virtual Machine Concept

> **Virtual Machine**: 다른 물리적 혹은 가상 컴퓨터의 기능을 모방(emulate)하는 소프트웨어 프로그램

### 2.1 Virtual Machine Levels

| Level | 계층 |
| --- | --- |
| **Level 4** | High-level language |
| **Level 3** | Assembly language |
| **Level 2** | Instruction set architecture (ISA) |
| **Level 1** | Digital logic |

각 계층은 아래 계층 위에 구현되며, 상위 계층은 하위 계층의 복잡함을 감춘다.

### 2.2 실제 변환 과정 예시

동일한 하나의 동작이 계층마다 어떻게 표현되는지 비교하면 개념이 명확해진다.

| 계층 | 표현 | 설명 |
| --- | --- | --- |
| **L2** Assembly language | `MOV AL, 97` | 기계어를 단순 번역한 형태 |
| **L1** Machine language | `10110000 01100001` | 하드웨어가 직접 실행하는 2진 명령 |
| **L0** Hardware | CPU, 메모리, 레지스터 | 전기 신호로 0과 1을 처리하는 실제 부품 |

- `10110000` → `MOV AL,` 에 해당하는 opcode
- `01100001` → 10진수 97 (= 16진수 61)
- 즉 **"값 97을 AL 레지스터에 넣어라"** 라는 하나의 명령

---

## 3. Data Representation

### 3.1 Number System Conversion

| System | Base | Possible Digits |
| --- | --- | --- |
| Binary | 2 | 0 1 |
| Octal | 8 | 0 1 2 3 4 5 6 7 |
| Decimal | 10 | 0 1 2 3 4 5 6 7 8 9 |
| Hexadecimal | 16 | 0 1 2 3 4 5 6 7 8 9 A B C D E F |

- **MSB** (Most Significant Bit): 가장 왼쪽 비트 (가장 큰 자리값)
- **LSB** (Least Significant Bit): 가장 오른쪽 비트 (자리 번호 0)
- 16비트 수의 비트 번호는 왼쪽 15번부터 오른쪽 0번까지

**2진수 → 10진수**: 각 비트에 $2^{\text{비트번호}}$ 를 곱해 합산

$$
1011_2 = 1 \times 2^3 + 0 \times 2^2 + 1 \times 2^1 + 1 \times 2^0 = 11_{10}
$$

### 3.2 Binary Addition

기본 규칙은 네 가지뿐이다.

| 연산 | 결과 |
| --- | --- |
| 0 + 0 | 0 |
| 0 + 1 | 1 |
| 1 + 0 | 1 |
| 1 + 1 | **10** (자리올림 발생) |

**예시: 4 + 7 = 11**

```
Carry:        1
       0 0 0 0 0 1 0 0    (4)
    +  0 0 0 0 0 1 1 1    (7)
    ---------------------
       0 0 0 0 1 0 1 1    (11)
Bit :  7 6 5 4 3 2 1 0
```

### 3.3 Integer Storage Sizes

| 명칭 | 비트 수 |
| --- | --- |
| Byte | 8 |
| Word | 16 |
| Doubleword | 32 |
| Quadword | 64 |
| Double quadword | 128 |

**저장 단위 (2의 거듭제곱)**

| 단위 | 크기 | 바이트 수 |
| --- | --- | --- |
| Kilobyte | $2^{10}$ | 1,024 |
| Megabyte | $2^{20}$ | 1,048,576 |
| Gigabyte | $2^{30}$ | 1,073,741,824 |
| Terabyte | $2^{40}$ | 1,099,511,627,776 |
| Petabyte | $2^{50}$ | 1,125,899,906,842,624 |
| Exabyte | $2^{60}$ | 1,152,921,504,606,846,976 |
| Zettabyte | $2^{70}$ | — |
| Yottabyte | $2^{80}$ | — |

### 3.4 Hexadecimal Integers

| Binary | Decimal | Hex | Binary | Decimal | Hex |
| --- | --- | --- | --- | --- | --- |
| 0000 | 0 | 0 | 1000 | 8 | 8 |
| 0001 | 1 | 1 | 1001 | 9 | 9 |
| 0010 | 2 | 2 | 1010 | 10 | A |
| 0011 | 3 | 3 | 1011 | 11 | B |
| 0100 | 4 | 4 | 1100 | 12 | C |
| 0101 | 5 | 5 | 1101 | 13 | D |
| 0110 | 6 | 6 | 1110 | 14 | E |
| 0111 | 7 | 7 | 1111 | 15 | F |

> **포인트**: 4비트가 정확히 16진수 1자리에 대응하므로, 2진수 ↔ 16진수 변환은 4비트 단위로 끊으면 즉시 가능하다.

### 3.5 Hexadecimal Addition

각 자리를 더하고, 16 이상이면 상위 자리로 1을 올린다.

| | | | |
| --- | --- | --- | --- |
| **Carry** | 1 | | |
| **X** | 6 | A | 2 |
| **Y** | 4 | 9 | A |
| **S** | B | 3 | C |

- 최하위: $2 + A = 12_{10} = C$
- 중간: $A + 9 = 19_{10}$ → 자리올림 1, 남은 값 $3$
- 최상위: $6 + 4 + 1 = 11_{10} = B$

### 3.6 Two's Complement Representation

- **Sign bit**: 최상위 비트가 `1`이면 음수, `0`이면 양수

**변환 절차 (양수 → 음수)**

| 단계 | 값 |
| --- | --- |
| Starting value | `00000001` |
| Step 1: 모든 비트 반전 | `11111110` |
| Step 2: 1 더하기 | `11111110 + 00000001` |
| Sum: 2의 보수 표현 | `11111111` |

즉 `00000001`(+1)의 2의 보수는 `11111111`(−1).

### 3.7 Converting Signed Binary to Decimal

음수(sign bit = 1)로 판단되면 다시 2의 보수를 취해 절댓값을 구한다.

| 단계 | 값 |
| --- | --- |
| Starting value | `11110000` |
| Step 1: 비트 반전 | `00001111` |
| Step 2: 1 더하기 | `00001111 + 1` |
| Step 3: 2의 보수 생성 | `00010000` |
| Step 4: 10진수 변환 | 16 |

따라서 `11110000` = **−16**

### 3.8 Maximum and Minimum Values

| Type | Range | Storage Size (bits) |
| --- | --- | --- |
| Signed byte | $-2^{7}$ ~ $+2^{7}-1$ | 8 |
| Signed word | $-2^{15}$ ~ $+2^{15}-1$ | 16 |
| Signed doubleword | $-2^{31}$ ~ $+2^{31}-1$ | 32 |
| Signed quadword | $-2^{63}$ ~ $+2^{63}-1$ | 64 |
| Signed double quadword | $-2^{127}$ ~ $+2^{127}-1$ | 128 |

> 음수 범위가 양수보다 1 넓은 이유: `0`이 양수 쪽에 포함되기 때문

### 3.9 Binary Subtraction

**핵심 아이디어**: 뺄셈은 *"음수를 더하는 것"* 으로 바꿔 처리한다.

```
  0 1 1 0 1    (+13)
  1 1 0 0 1    ( -7)   ← 00111의 2의 보수
  ---------
  0 0 1 1 0    ( +6)
```

$13 - 7 = 13 + (-7) = 6$

이 방식 덕분에 CPU는 **뺄셈 회로를 따로 두지 않고 덧셈기만으로** 뺄셈을 수행할 수 있다.

### 3.10 Character Storage

**ASCII vs Extended ASCII**

| Feature | ASCII | Extended ASCII |
| --- | --- | --- |
| Bit Length | 7-bit (0–127) | 8-bit (0–255) |
| Character Set | 영문자, 숫자, 구두점, 제어문자 | ASCII + 추가 기호·그래픽 문자 |
| Number of Chars | 128 | 256 |
| Language Support | 영어만 | 일부 유럽 언어 (프랑스어, 독일어 등) |
| Usage | 초기 컴퓨터, 기본 텍스트 파일 | MS-DOS 코드 페이지, ISO 8859 |
| Limitations | 비영어권 문자 표현 불가 | 전 세계 언어를 모두 담지 못함 |
| Evolution | 이후 표준의 전신 | 현재는 대부분 Unicode로 대체 |

**Unicode**

| Feature | 내용 |
| --- | --- |
| Full Name | Universal Coded Character Set |
| Bit Length | 인코딩에 따라 가변 |
| Character Range | 149,000자 이상 (Unicode 15.0, 2022 기준) |
| Coverage | 사실상 모든 문자 체계 + 기호 + 이모지 |
| Number of Planes | 17개 (BMP + 16개 보조 평면) |
| Advantages | 범용성, 플랫폼 간 일관성, 다국어 지원 |
| Limitations | ASCII보다 저장 용량 큼, 인코딩 방식 복잡 |

**인코딩 방식 비교**

| 인코딩 | 바이트 | 특징 |
| --- | --- | --- |
| **UTF-8** | 1–4 | ASCII 하위 호환, 웹 표준, 라틴 문자에 효율적. 가변 길이라 인덱싱이 느릴 수 있음 |
| **UTF-16** | 2 또는 4 | 한중일 문자를 2바이트로 저장. ASCII 비호환, 엔디안 처리 필요. Windows·Java에서 사용 |
| **UTF-32** | 4 (고정) | 인덱싱이 매우 단순·빠름. 메모리 비효율적이라 저장·전송에는 드물게 사용 |

---

## 4. Boolean Expressions

### 4.1 표기법

| Expression | Description |
| --- | --- |
| $\lnot X$ | NOT X |
| $X \land Y$ | X AND Y |
| $X \lor Y$ | X OR Y |
| $\lnot X \lor Y$ | (NOT X) OR Y |
| $\lnot (X \land Y)$ | NOT (X AND Y) |
| $X \land \lnot Y$ | X AND (NOT Y) |

### 4.2 Truth Tables

**NOT**

| X | $\lnot X$ |
| --- | --- |
| F | T |
| T | F |

**AND** — 둘 다 참일 때만 참

| X | Y | $X \land Y$ |
| --- | --- | --- |
| F | F | F |
| F | T | F |
| T | F | F |
| T | T | T |

**OR** — 하나라도 참이면 참

| X | Y | $X \lor Y$ |
| --- | --- | --- |
| F | F | F |
| F | T | T |
| T | F | T |
| T | T | T |

### 4.3 Order of Operations

| Expression | 연산 순서 |
| --- | --- |
| $\lnot X \lor Y$ | NOT → OR |
| $\lnot (X \lor Y)$ | OR → NOT |
| $X \lor (Y \land Z)$ | AND → OR |

> 괄호가 없으면 **NOT → AND → OR** 순서로 평가된다.

---

## 5. 핵심 요약

| 주제 | 반드시 기억할 것 |
| --- | --- |
| 언어 계층 | High-level → Assembly → ISA → Digital logic (4단계) |
| 어셈블리어의 위치 | 기계어와 1:1 대응되는 니모닉 표현 |
| 2진 ↔ 16진 | 4비트 = 16진수 1자리 |
| 부호 표현 | 최상위 비트(sign bit)가 1이면 음수 |
| 2의 보수 | 비트 반전 후 +1 |
| 뺄셈 | 2의 보수를 더하는 방식으로 처리 |
| 저장 단위 | Byte 8 / Word 16 / Dword 32 / Qword 64 |
| 문자 인코딩 | ASCII(7bit) → Extended ASCII(8bit) → Unicode |
| 불 연산 우선순위 | NOT → AND → OR |

---

## 참고

- 교재: *Assembly Language for x86 Processors* (Kip R. Irvine)
- 개발 환경: Visual Studio + MASM
