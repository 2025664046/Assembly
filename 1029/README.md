# 7장. Integer Arithmetic

## 1. 시프트와 회전 명령어 (Shift and Rotate Instructions)

시프트(Shift)와 회전(Rotate) 명령어는 레지스터 또는 메모리에 저장된
비트들을 왼쪽이나 오른쪽으로 이동시키는 명령어이다.

-   **Shift**: 비트를 한쪽 방향으로 이동시킨다. 이동 과정에서 피연산자의
    끝에 있던 비트는 밖으로 밀려날 수 있다.
-   **Rotate**: 비트를 한쪽 방향으로 회전시킨다. 한쪽 끝에서 밀려난
    비트가 반대쪽 끝으로 들어가므로 비트가 사라지지 않는다.

### 1.1 논리 시프트와 산술 시프트 (Logical Shift and Arithmetic Shift)

시프트 명령어는 논리 시프트와 산술 시프트로 구분된다.

  -----------------------------------------------------------------------
  구분                                설명
  ----------------------------------- -----------------------------------
  Logical Shift                       비트를 이동시키고 새로 생긴
                                      빈자리를 0으로 채운다.

  Arithmetic Shift                    부호 있는 정수의 부호를 고려하여
                                      이동한다. 오른쪽 산술 시프트에서는
                                      기존 최상위 비트를 유지한다.
  -----------------------------------------------------------------------

### 1.2 SHL 명령어 (Shift Left)

-   목적지 피연산자의 비트를 왼쪽으로 이동시킨다.
-   오른쪽에 새로 생기는 최하위 비트(LSB)는 0으로 채운다.
-   왼쪽 끝에서 밀려난 비트는 Carry Flag로 이동한다.
-   논리적 왼쪽 시프트를 수행한다.

``` asm
; 예시: 8비트 값을 왼쪽으로 1비트 이동
mov al, 10110101b
shl al, 1
```

### 1.3 SHR 명령어 (Shift Right)

-   목적지 피연산자의 비트를 오른쪽으로 이동시킨다.
-   왼쪽에 새로 생기는 최상위 비트(MSB)는 0으로 채운다.
-   오른쪽 끝에서 밀려난 비트는 Carry Flag로 이동한다.
-   논리적 오른쪽 시프트를 수행한다.

``` asm
; 예시: 8비트 값을 오른쪽으로 1비트 이동
mov al, 10110101b
shr al, 1
```

### 1.4 SAL과 SAR 명령어

  -----------------------------------------------------------------------
  명령어                  전체 이름               동작
  ----------------------- ----------------------- -----------------------
  SAL                     Shift Arithmetic Left   SHL과 동일하게 왼쪽으로
                                                  이동하고 오른쪽
                                                  빈자리를 0으로 채운다.

  SAR                     Shift Arithmetic Right  오른쪽으로 산술
                                                  이동하며 왼쪽 빈자리에
                                                  기존 최상위 비트를
                                                  복사한다.
  -----------------------------------------------------------------------

-   **SAL**은 SHL과 같은 방식으로 동작한다.
-   **SAR**은 오른쪽 이동 시 부호 비트를 유지한다. 따라서 부호 있는
    정수의 오른쪽 산술 시프트에 사용한다.

### 1.5 회전 명령어 (Rotate Instructions)

회전 명령어는 이동 과정에서 끝으로 밀려난 비트를 반대쪽 끝으로 다시
넣는다. 따라서 비트가 손실되지 않는다.

  -----------------------------------------------------------------------
  명령어                  전체 이름               동작
  ----------------------- ----------------------- -----------------------
  ROL                     Rotate Left             왼쪽으로 회전한다.
                                                  최상위 비트를 Carry
                                                  Flag와 최하위 비트
                                                  위치에 복사한다.

  ROR                     Rotate Right            오른쪽으로 회전한다.
                                                  최하위 비트를 Carry
                                                  Flag와 최상위 비트
                                                  위치에 복사한다.

  RCL                     Rotate Carry Left       Carry Flag를 포함하여
                                                  왼쪽으로 회전한다. 기존
                                                  Carry Flag는 LSB로,
                                                  기존 MSB는 Carry Flag로
                                                  이동한다.

  RCR                     Rotate Carry Right      Carry Flag를 포함하여
                                                  오른쪽으로 회전한다.
                                                  기존 Carry Flag는
                                                  MSB로, 기존 LSB는 Carry
                                                  Flag로 이동한다.
  -----------------------------------------------------------------------

#### ROL과 ROR

-   **ROL**: 최상위 비트가 왼쪽으로 밀려나면서 Carry Flag에 복사되고,
    동시에 최하위 비트 위치로 들어간다.
-   **ROR**: 최하위 비트가 오른쪽으로 밀려나면서 Carry Flag에 복사되고,
    동시에 최상위 비트 위치로 들어간다.

#### RCL과 RCR

-   **RCL**: Carry Flag를 비트열의 일부처럼 취급하여 왼쪽으로
    회전시킨다.
-   **RCR**: Carry Flag를 비트열의 일부처럼 취급하여 오른쪽으로
    회전시킨다.
-   ROL/ROR과 달리 Carry Flag의 기존 값도 회전 결과에 포함된다.

### 1.6 Overflow Flag

-   부호 있는 정수를 1비트 시프트하거나 회전했을 때 결과가 목적지
    피연산자의 부호 있는 정수 범위를 벗어나면 Overflow Flag가 설정된다.
-   시프트 또는 회전 횟수가 1보다 크면 Overflow Flag의 값은 정의되지
    않는다.

### 1.7 SHLD와 SHRD (Double-Precision Shift)

SHLD와 SHRD는 목적지 피연산자를 이동시키면서 원본 피연산자의 비트를
빈자리에 채우는 명령어이다.

  -----------------------------------------------------------------------
  명령어                              동작
  ----------------------------------- -----------------------------------
  SHLD                                목적지 피연산자를 왼쪽으로
                                      이동시키고, 새로 생긴 빈자리를 원본
                                      피연산자의 최상위 비트들로 채운다.

  SHRD                                목적지 피연산자를 오른쪽으로
                                      이동시키고, 새로 생긴 빈자리를 원본
                                      피연산자의 최하위 비트들로 채운다.
  -----------------------------------------------------------------------

-   두 명령어 모두 지정한 비트 수만큼 목적지 피연산자를 이동시킨다.
-   원본 피연산자는 변경되지 않는다.
-   PDF에서는 SHLD 실행 시 Sign, Zero, Auxiliary, Parity, Carry Flag가
    영향을 받는다고 설명한다.

------------------------------------------------------------------------

## 2. 조건부 제어 흐름 지시어 (Conditional Control Flow Directives)

조건부 제어 흐름은 조건에 따라 프로그램의 실행 순서를 바꾸는 방법이다.

-   프로그램은 조건에 따라 서로 다른 명령어를 실행할 수 있다.
-   조건부 제어 흐름을 사용하면 특정 조건을 만족할 때만 다음 명령어 또는
    다른 위치의 명령어를 실행하도록 구성할 수 있다.
-   PDF에서는 조건부 제어 흐름과 관련된 어셈블리 프로그램을 제시하고,
    프로그램의 실행 과정을 설명하는 문제를 다룬다.

------------------------------------------------------------------------

## 3. 시프트와 회전 명령어의 활용 (Shift and Rotate Applications)

시프트와 회전 명령어는 단순한 비트 이동 외에도 배열의 비트 이동, 이진수
문자열 변환, 파일 날짜 정보 확인 등에 활용할 수 있다.

### 3.1 바이트 배열 시프트 (Shift an Array of Bytes)

바이트 배열에 저장된 모든 비트를 오른쪽으로 1비트 이동시키는 과정이다.

-   배열의 각 바이트를 순서대로 처리한다.
-   한 바이트에서 오른쪽으로 밀려난 비트가 다음 바이트의 빈자리에
    연결되도록 Carry Flag를 이용한다.
-   각 바이트를 차례로 처리하면 배열 전체의 비트를 하나의 큰 비트열처럼
    오른쪽으로 이동시킬 수 있다.
-   PDF의 단계별 그림에서는 각 단계를 거쳐 배열의 모든 비트가 오른쪽으로
    1자리 이동하는 과정을 보여준다.

### 3.2 이진 정수를 ASCII 이진 문자열로 변환 (Binary Integer to ASCII Binary String)

32비트 이진 정수를 화면에 출력할 수 있는 ASCII 문자열로 변환하는
작업이다.

-   입력: EAX에는 변환할 32비트 이진 정수가 저장되고, ESI는 문자열을
    저장할 버퍼를 가리킨다.
-   반환: 버퍼에 32개의 ASCII 이진 숫자가 저장된다.
-   ECX에 32를 저장하고, EAX의 비트를 하나씩 확인하면서 반복한다.
-   SHL 명령어로 EAX를 왼쪽으로 1비트 이동시킨다. 이때 기존 최상위
    비트가 Carry Flag로 이동한다.
-   우선 버퍼에 문자 `'0'`을 저장한다.
-   Carry Flag가 1이면 문자 `'1'`을 저장한다.
-   ESI를 증가시켜 다음 버퍼 위치로 이동한다.
-   32번 반복하여 32비트 전체를 문자열로 변환한다.
-   ECX와 ESI는 작업 전에 스택에 저장하고, 작업이 끝나면 복원한다.

``` asm
; BinToAsc
; 32비트 이진 정수를 ASCII 이진 문자열로 변환
; 입력: EAX = 이진 정수, ESI = 버퍼 주소
; 반환: 버퍼에 ASCII 이진 숫자 저장

BinToAsc PROC
    push ecx
    push esi
    mov ecx,32

L1:
    shl eax,1
    mov BYTE PTR [esi],'0'
    jnc L2
    mov BYTE PTR [esi],'1'

L2:
    inc esi
    loop L1

    pop esi
    pop ecx
    ret
BinToAsc ENDP
```

**코드에서 사용하는 레지스터**

  레지스터     역할
  ------------ ---------------------------------------------
  EAX          변환할 32비트 이진 정수
  ESI          ASCII 문자열을 저장할 버퍼의 현재 위치
  ECX          반복 횟수. 32비트이므로 32회 반복
  Carry Flag   SHL로 밀려난 기존 최상위 비트를 임시로 보관

### 3.3 파일 날짜 정보 (File Date Stamp)

파일의 마지막 수정 날짜는 DX 레지스터의 비트들에 저장될 수 있다.

-   PDF에서는 1999년 3월 10일에 마지막으로 수정된 파일의 날짜 정보가 DX
    레지스터에 어떻게 표시되는지 설명한다.
-   날짜 정보에 포함된 연도는 1980년을 기준으로 한 상대적인 값이다.
-   비트 단위로 저장된 날짜 정보를 확인할 때 비트 이동 및 비트 연산을
    활용할 수 있다.

------------------------------------------------------------------------

## 4. 곱셈과 나눗셈 명령어 (Multiplication and Division Instructions)

곱셈과 나눗셈 명령어는 부호 없는 정수와 부호 있는 정수에 따라 구분된다.

### 4.1 MUL 명령어 (Unsigned Multiplication)

MUL은 부호 없는 정수의 곱셈을 수행한다.

-   곱하는 값인 multiplier와 multiplicand는 항상 같은 크기여야 한다.
-   곱셈 결과의 크기는 두 피연산자 크기의 2배이다.
-   피연산자 크기에 따라 결과가 저장되는 레지스터가 달라진다.

  곱셈 크기   첫 번째 피연산자   두 번째 피연산자              결과 저장 위치
  ----------- ------------------ ----------------------------- ----------------
  8비트       AL                 8비트 레지스터 또는 메모리    AX
  16비트      AX                 16비트 레지스터 또는 메모리   DX:AX
  32비트      EAX                32비트 레지스터 또는 메모리   EDX:EAX

-   8비트 곱셈의 결과는 AX에 저장된다.
-   16비트 곱셈의 결과는 DX:AX에 저장된다.
-   32비트 곱셈의 결과는 EDX:EAX에 저장된다.
-   MUL 실행 후 Carry Flag를 확인하면 곱셈 결과의 상위 절반을 무시해도
    되는지 판단할 수 있다.
-   결과의 상위 절반이 0이 아니면 Carry Flag가 설정된다.

### 4.2 IMUL 명령어 (Signed Multiplication)

IMUL은 부호 있는 정수의 곱셈을 수행한다.

IMUL에는 1-operand, 2-operand, 3-operand 형식이 있다.

#### 1-operand 형식

-   8비트 곱셈 결과는 AX에 저장된다.
-   16비트 곱셈 결과는 DX:AX에 저장된다.
-   32비트 곱셈 결과는 EDX:EAX에 저장된다.
-   결과가 피연산자 크기의 2배인 레지스터 쌍에 저장된다.

#### 2-operand 형식

-   목적지 피연산자와 다른 피연산자를 곱한다.
-   결과는 목적지 피연산자의 크기에 맞춰 저장된다.
-   결과의 중요한 숫자(비트)가 손실되면 Overflow Flag와 Carry Flag가
    설정된다.
-   따라서 2-operand 형식의 IMUL 실행 후에는 Overflow Flag 또는 Carry
    Flag를 확인해야 한다.

#### 3-operand 형식

-   두 피연산자를 곱한 결과를 목적지 피연산자에 저장한다.
-   목적지 피연산자의 크기에 맞춰 결과가 저장된다.
-   결과의 중요한 숫자(비트)가 손실되면 Overflow Flag와 Carry Flag가
    설정된다.
-   3-operand 형식도 실행 후 Flag를 확인해야 한다.

#### IMUL 형식 비교

  -----------------------------------------------------------------------
  형식                    결과 저장 방식          확인할 내용
  ----------------------- ----------------------- -----------------------
  1-operand               AX, DX:AX 또는          피연산자 크기에 따라
                          EDX:EAX에 전체 결과     결과 레지스터가 달라짐
                          저장                    

  2-operand               목적지 피연산자 크기로  중요한 비트가 손실되면
                          결과를 저장             OF와 CF가 설정됨

  3-operand               목적지 피연산자 크기로  중요한 비트가 손실되면
                          결과를 저장             OF와 CF가 설정됨
  -----------------------------------------------------------------------

-   2-operand와 3-operand 형식은 목적지 피연산자의 크기가 곱셈 결과를
    저장할 수 있는 크기보다 작을 수 있다.
-   따라서 부호 있는 정수의 Overflow가 발생할 수 있으므로 Overflow
    Flag를 확인해야 한다.

### 4.3 부호 확장 (Sign Extension)

부호 확장은 부호 있는 정수의 크기를 더 큰 크기로 확장하는 과정이다.

-   정수의 크기를 확장할 때 기존 부호를 유지해야 한다.
-   상위 비트를 단순히 0으로 채우는 것이 아니라 부호 비트를 확장한다.
-   PDF에서는 다음 세 가지 명령어를 제시한다.

  명령어   동작
  -------- -----------------------------------
  CBW      Byte를 Word로 부호 확장
  CWD      Word를 Doubleword로 부호 확장
  CDQ      Doubleword를 Quadword로 부호 확장

-   CBW는 AL의 부호를 AX로 확장한다.
-   CWD는 AX의 부호를 DX:AX로 확장한다.
-   CDQ는 EAX의 부호를 EDX:EAX로 확장한다.
-   부호 있는 나눗셈을 실행하기 전에 피제수의 크기에 맞는 부호 확장이
    필요하다.

### 4.4 DIV 명령어 (Unsigned Division)

DIV는 부호 없는 정수의 나눗셈을 수행한다.

-   나눗셈에 사용되는 피제수는 제수의 크기에 따라 정해진 레지스터에
    저장되어 있어야 한다.
-   나눗셈 결과인 몫과 나머지는 각각 지정된 레지스터에 저장된다.

  제수 크기   피제수    제수                          몫    나머지
  ----------- --------- ----------------------------- ----- --------
  8비트       AX        8비트 레지스터 또는 메모리    AL    AH
  16비트      DX:AX     16비트 레지스터 또는 메모리   AX    DX
  32비트      EDX:EAX   32비트 레지스터 또는 메모리   EAX   EDX

-   8비트 DIV는 AX를 피제수로 사용한다.
-   16비트 DIV는 DX:AX를 피제수로 사용한다.
-   32비트 DIV는 EDX:EAX를 피제수로 사용한다.
-   몫과 나머지는 표에 지정된 레지스터에 저장된다.

### 4.5 IDIV 명령어 (Signed Division)

IDIV는 부호 있는 정수의 나눗셈을 수행한다.

-   DIV와 동일한 피연산자 형식을 사용한다.
-   부호 있는 피제수를 올바르게 표현하기 위해 나눗셈 전에 부호 확장을
    수행해야 한다.
-   특히 8비트 나눗셈을 실행하기 전에는 피제수 AX가 완전히 부호 확장되어
    있어야 한다.
-   DIV와 IDIV 실행 후에는 모든 산술 상태 Flag의 값이 정의되지 않는다.

### 4.6 나눗셈 Overflow (Division Overflow)

-   나눗셈 결과인 몫이 목적지 피연산자에 저장될 수 없는 크기이면
    Division Overflow가 발생한다.
-   Division Overflow가 발생하면 프로세서 예외가 발생하고 현재
    프로그램이 중단된다.
-   PDF에서는 나눗셈 Overflow가 발생할 가능성을 줄이는 방법으로 32비트
    제수와 64비트 피제수를 사용하는 방법을 제안한다.

### 4.7 0으로 나누기 방지 (Division by Zero)

-   제수가 0이면 나눗셈을 수행할 수 없다.
-   따라서 DIV 또는 IDIV를 실행하기 전에 제수가 0인지 검사해야 한다.
-   제수가 0인 경우 나눗셈 명령어를 실행하지 않도록 처리한다.

------------------------------------------------------------------------

## 5. 확장 덧셈과 뺄셈 (Extended Addition and Subtraction)

여러 레지스터에 걸쳐 큰 정수를 계산할 때는 앞선 연산에서 발생한 Carry를
다음 연산에 전달해야 한다. ADC와 SBB는 Carry Flag를 계산에 포함하는
명령어이다.

### 5.1 ADC 명령어 (Add with Carry)

-   목적지 피연산자에 원본 피연산자를 더한다.
-   여기에 Carry Flag의 값도 함께 더한다.
-   이전 덧셈에서 발생한 Carry를 다음 덧셈에 전달할 수 있다.
-   여러 워드 또는 여러 바이트로 이루어진 큰 정수의 덧셈에 사용한다.

**연산 형태**

``` asm
ADC destination, source
```

### 5.2 SBB 명령어 (Subtract with Borrow)

-   목적지 피연산자에서 원본 피연산자를 뺀다.
-   여기에 Carry Flag의 값도 함께 뺀다.
-   이전 뺄셈에서 발생한 빌림(Borrow)을 다음 뺄셈에 전달할 수 있다.
-   여러 워드 또는 여러 바이트로 이루어진 큰 정수의 뺄셈에 사용한다.

**연산 형태**

``` asm
SBB destination, source
```

### 5.3 ADC와 SBB 비교

  명령어   전체 이름              연산
  -------- ---------------------- -------------------------------------
  ADC      Add with Carry         목적지 = 목적지 + 원본 + Carry Flag
  SBB      Subtract with Borrow   목적지 = 목적지 - 원본 - Carry Flag

------------------------------------------------------------------------

## 6. ASCII 및 Unpacked Decimal 산술 (ASCII and Unpacked Decimal Arithmetic)

### 6.1 ASCII Decimal과 Unpacked Decimal

Unpacked Decimal과 ASCII Decimal은 10진수 한 자리를 저장하는 방식에서
차이가 있다.

  형식               상위 4비트   하위 4비트
  ------------------ ------------ ---------------------------
  Unpacked Decimal   항상 0       10진수 숫자
  ASCII Decimal      `0011b`      10진수 숫자에 해당하는 값

-   Unpacked Decimal 정수의 상위 4비트는 항상 0이다.
-   ASCII Decimal 숫자의 상위 4비트는 `0011b`이다.
-   따라서 두 형식은 하위 4비트에 숫자를 저장하더라도 상위 4비트에서
    차이가 난다.

### 6.2 AAA 명령어 (ASCII Adjust After Addition)

-   AAA는 ADD 또는 ADC 명령어로 수행한 덧셈의 이진 결과를 조정한다.
-   Unpacked Decimal 형식의 숫자를 더한 뒤 결과를 조정할 때 사용한다.
-   PDF의 ASCII 덧셈 예제에서는 AAA를 실행한 뒤 AH에 Carry가 저장되는
    과정을 이용한다.

### 6.3 ASCII 숫자 문자열 덧셈 (ASCII Addition)

PDF의 `ASCII_add.asm` 예제는 소수점 위치가 고정되어 있는 ASCII 숫자
문자열 두 개를 더한다.

**예제 데이터**

  변수             저장된 문자열            의미
  ---------------- ------------------------ -------------------------------------------------
  decimal_one      `"100123456789765"`      1001234567.89765
  decimal_two      `"900402076502015"`      9004020765.02015
  sum              결과를 저장하는 문자열   두 문자열의 덧셈 결과
  DECIMAL_OFFSET   5                        문자열 오른쪽에서 소수점 위치를 나타내는 오프셋

**처리 과정**

1.  ESI를 첫 번째 숫자 문자열의 마지막 숫자 위치로 설정한다.
2.  EDI를 결과 문자열의 마지막 숫자를 저장할 위치로 설정한다.
3.  ECX에 문자열의 길이를 저장한다.
4.  BH를 0으로 설정하여 이전 자리에서 전달된 Carry를 초기화한다.
5.  첫 번째 문자열의 현재 숫자를 AL로 가져온다.
6.  이전 자리에서 전달된 Carry를 AL에 더한다.
7.  AAA를 실행하여 덧셈 결과를 조정하고 AH에 저장된 Carry를 보관한다.
8.  두 번째 문자열의 같은 위치에 있는 숫자를 더하고 AAA를 다시 실행한다.
9.  두 번의 조정 과정에서 발생한 Carry를 결합한다.
10. 결과 숫자를 ASCII 문자로 변환하여 sum에 저장한다.
11. ESI와 EDI를 감소시켜 다음 자리로 이동한다.
12. 문자열의 모든 자리를 처리한 뒤 마지막 Carry를 결과 문자열에
    저장한다.

**사용 레지스터**

  레지스터   역할
  ---------- -----------------------------------
  ESI        첫 번째 숫자 문자열의 현재 위치
  EDI        결과 문자열의 현재 저장 위치
  ECX        반복할 문자열의 길이
  AL         현재 숫자 및 덧셈 결과
  AH         AAA 실행 후 Carry가 저장되는 위치
  BH         이전 자리에서 전달된 Carry를 보관

**PDF 예제 코드**

``` asm
; ASCII Addition (ASCII_add.asm)
; Perform ASCII arithmetic on strings having
; an implied fixed decimal point.

INCLUDE Irvine32.inc

DECIMAL_OFFSET = 5

.data
decimal_one BYTE "100123456789765"
decimal_two BYTE "900402076502015"
sum BYTE (SIZEOF decimal_one + 1) DUP(0),0

.code
main PROC
    ; Start at the last digit position.
    mov esi,SIZEOF decimal_one - 1
    mov edi,SIZEOF decimal_one
    mov ecx,SIZEOF decimal_one
    mov bh,0

L1:
    mov ah,0
    mov al,decimal_one[esi]
    add al,bh
    aaa
    mov bh,ah
    or bh,30h
    add al,decimal_two[esi]
    aaa
    or bh,ah
    or bh,30h
    or al,30h
    mov sum[edi],al
    dec esi
    dec edi
    loop L1

    mov sum[edi],bh

    ; Display the sum as a string.
    mov edx,OFFSET sum
    call WriteString
    call Crlf
    exit
main ENDP
END main
```

### 6.4 AAS 명령어 (ASCII Adjust After Subtraction)

-   AAS는 SUB 또는 SBB 명령어 뒤에 사용한다.
-   SUB 또는 SBB로 Unpacked Decimal 값 하나에서 다른 값을 빼고, 결과가
    AL에 저장된 뒤 실행한다.
-   뺄셈 결과를 조정하는 명령어이다.

### 6.5 AAM 명령어 (ASCII Adjust After Multiplication)

-   AAM은 MUL 명령어로 생성된 이진 곱셈 결과를 Unpacked Decimal 형식으로
    변환한다.
-   곱셈 결과를 Unpacked Decimal 형태로 표현할 때 사용한다.

### 6.6 AAD 명령어 (ASCII Adjust Before Division)

-   AAD는 DIV 명령어를 실행하기 전에 사용한다.
-   AX에 저장된 Unpacked Decimal 피제수를 이진수로 변환한다.
-   변환된 피제수를 이용하여 DIV 명령어를 실행할 수 있다.

### 6.7 ASCII 및 Unpacked Decimal 명령어 정리

  -----------------------------------------------------------------------
  명령어                  전체 이름               사용 목적
  ----------------------- ----------------------- -----------------------
  AAA                     ASCII Adjust After      ADD 또는 ADC 뒤에 덧셈
                          Addition                결과 조정

  AAS                     ASCII Adjust After      SUB 또는 SBB 뒤에 뺄셈
                          Subtraction             결과 조정

  AAM                     ASCII Adjust After      MUL의 이진 곱셈 결과를
                          Multiplication          Unpacked Decimal로 변환

  AAD                     ASCII Adjust Before     DIV 실행 전에 Unpacked
                          Division                Decimal 피제수를
                                                  이진수로 변환
  -----------------------------------------------------------------------

------------------------------------------------------------------------

## 7. Packed Decimal 산술 (Packed Decimal Arithmetic)

Packed Decimal은 10진수 숫자를 압축하여 저장하는 형식이다. PDF에서는 ADD
또는 ADC의 결과를 Packed Decimal 형식으로 조정하는 DAA와, SUB 또는 SBB의
결과를 조정하는 DAS를 설명한다.

### 7.1 DAA 명령어 (Decimal Adjust After Addition)

-   DAA는 ADD 또는 ADC 명령어로 AL에 생성된 이진 덧셈 결과를 Packed
    Decimal 형식으로 변환한다.
-   Packed Decimal 덧셈을 수행한 뒤 결과를 올바른 10진수 형식으로 조정할
    때 사용한다.

### 7.2 Packed Decimal 덧셈 예제 (AddPacked.asm)

PDF의 `AddPacked.asm` 예제는 Packed Decimal 형식으로 저장된 두 값을
더한다.

**예제 데이터**

  변수       초기값      설명
  ---------- ----------- ---------------------------
  packed_1   `4536h`     첫 번째 Packed Decimal 값
  packed_2   `7207h`     두 번째 Packed Decimal 값
  sum        `DWORD ?`   덧셈 결과 저장 공간

**처리 과정**

1.  sum을 0으로 초기화하고 ESI를 0으로 설정한다.
2.  첫 번째 바이트를 가져와 ADD로 더한다.
3.  DAA를 실행하여 결과를 Packed Decimal 형식으로 조정한다.
4.  조정된 결과를 sum의 현재 바이트에 저장한다.
5.  ESI를 증가시켜 다음 바이트 위치로 이동한다.
6.  다음 바이트는 ADC로 더하여 앞선 계산에서 발생한 Carry를 포함한다.
7.  다시 DAA를 실행하고 결과를 sum에 저장한다.
8.  마지막 Carry가 있는지 확인하기 위해 0과 ADC를 수행한다.
9.  최종 결과를 WriteHex로 출력한다.

**Example**

``` asm
; Packed Decimal Example (AddPacked.asm)
; Demonstrate packed decimal addition.

INCLUDE Irvine32.inc

.data
packed_1 WORD 4536h
packed_2 WORD 7207h
sum DWORD ?

.code
main PROC
    ; Initialize sum and index.
    mov sum,0
    mov esi,0

    ; Add low bytes.
    mov al,BYTE PTR packed_1[esi]
    add al,BYTE PTR packed_2[esi]
    daa
    mov BYTE PTR sum[esi],al

    ; Add high bytes, include carry.
    inc esi
    mov al,BYTE PTR packed_1[esi]
    adc al,BYTE PTR packed_2[esi]
    daa
    mov BYTE PTR sum[esi],al

    ; Add final carry, if any.
    inc esi
    mov al,0
    adc al,0
    mov BYTE PTR sum[esi],al

    ; Display the sum in hexadecimal.
    mov eax,sum
    call WriteHex
    call Crlf
    exit
main ENDP
END main
```

### 7.3 DAS 명령어 (Decimal Adjust After Subtraction)

-   DAS는 SUB 또는 SBB 명령어로 AL에 생성된 이진 뺄셈 결과를 Packed
    Decimal 형식으로 변환한다.
-   Packed Decimal 형식의 뺄셈 결과를 조정할 때 사용한다.
