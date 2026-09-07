# 0903 과제 - Chapter 1 문제 및 풀이
## 1.7.1 Short Answer

**1.** In an 8-bit binary number, which is the most significant bit (MSB)?  

가장 왼쪽에 있는 비트인 **비트 7**이다.

```text
b7 b6 b5 b4 b3 b2 b1 b0
↑
MSB
```

---


**2.** What is the decimal representation of each of the following unsigned binary integers?  
> a. `00110101`  
> b. `10010110`  
> c. `11001100`  
>

| 항목 | 이진수 | 계산 | 답 |
|---|---:|---|---:|
| a | `00110101` | $32+16+4+1$ | **53** |
| b | `10010110` | $128+16+4+2$ | **150** |
| c | `11001100` | $128+64+8+4$ | **204** |

---


**3.** What is the sum of each pair of binary integers?  
> a. `10101111 + 11011011`  
> b. `10010111 + 11111111`  
> c. `01110101 + 10101100`  
>

| 항목 | 계산 | 결과 |
|---|---|---|
| a | `10101111 + 11011011` | **`110001010`** |
| b | `10010111 + 11111111` | **`110010110`** |
| c | `01110101 + 10101100` | **`100100001`** |

8비트 레지스터만 사용한다면 각 결과의 맨 왼쪽 비트는 **캐리(carry)** 이다.

| 항목 | 8비트 결과 | Carry |
|---|---|---:|
| a | `10001010` | 1 |
| b | `10010110` | 1 |
| c | `00100001` | 1 |

---


**4.** Calculate binary `00001101` minus `00000111`.  

```text
  00001101
- 00000111
----------
  00000110
```

따라서 답은 **`00000110`**이다.

---


**5.** How many bits are used by each of the following data types?  
> a. word  
> b. doubleword  
> c. quadword  
> d. double quadword  
>

| 자료형 | 바이트 | 비트 |
|---|---:|---:|
| Word | 2 | **16비트** |
| Doubleword | 4 | **32비트** |
| Quadword | 8 | **64비트** |
| Double quadword | 16 | **128비트** |

---


**6.**  What is the minimum number of binary bits needed to represent each of the following unsigned decimal integers?  
> a. `4095`  
> b. `65534`  
> c. `42319`  
>

양의 정수 $n$에 필요한 최소 비트 수는 다음과 같다.

$$\lfloor \log_2 n \rfloor+1$$

| 항목 | 값 | 근거 | 답 |
|---|---:|---|---:|
| a | 4095 | $2^{11}<4095<2^{12}$ | **12비트** |
| b | 65534 | $2^{15}<65534<2^{16}$ | **16비트** |
| c | 42319 | $2^{15}<42319<2^{16}$ | **16비트** |

---


**7.** What is the hexadecimal representation of each of the following binary numbers?  
> a. `0011 0101 1101 1010`  
> b. `1100 1110 1010 0011`  
> c. `1111 1110 1101 1011`  
>

4비트씩 묶어 변환한다.

| 항목 | 이진수 | 16진수 |
|---|---|---|
| a | `0011 0101 1101 1010` | **`35DA`** |
| b | `1100 1110 1010 0011` | **`CEA3`** |
| c | `1111 1110 1101 1011` | **`FEDB`** |

---


**8.** What is the binary representation of the following hexadecimal numbers?  
> a. `0126F9D4`  
> b. `6ACDFA95`  
> c. `F69BDC2A`  
>

| 항목 | 16진수 | 이진수 |
|---|---|---|
| a | `0126F9D4` | **`0000 0001 0010 0110 1111 1001 1101 0100`** |
| b | `6ACDFA95` | **`0110 1010 1100 1101 1111 1010 1001 0101`** |
| c | `F69BDC2A` | **`1111 0110 1001 1011 1101 1100 0010 1010`** |

---


**9.** What is the unsigned decimal representation of each of the following hexadecimal integers?  
> a. `3A`  
> b. `1BF`  
> c. `1001`  
>

| 항목 | 16진수 | 계산 | 답 |
|---|---:|---|---:|
| a | `3A` | $3(16)+10$ | **58** |
| b | `1BF` | $1(256)+11(16)+15$ | **447** |
| c | `1001` | $1(16^3)+1$ | **4097** |

---


**10.** What is the unsigned decimal representation of each of the following hexadecimal integers?  
> a. `62`  
> b. `4B3`  
> c. `29F`  
>

| 항목 | 16진수 | 계산 | 답 |
|---|---:|---|---:|
| a | `62` | $6(16)+2$ | **98** |
| b | `4B3` | $4(256)+11(16)+3$ | **1203** |
| c | `29F` | $2(256)+9(16)+15$ | **671** |

---


**11.** What is the 16-bit hexadecimal representation of each of the following signed decimal integers?  
> a. `-24`  
> b. `-331`  
>

음수는 16비트 2의 보수로 표현한다.

| 항목 | 10진수 | 16비트 16진수 |
|---|---:|---|
| a | -24 | **`FFE8`** |
| b | -331 | **`FEB5`** |

검산:

- $65536-24=65512=\texttt{FFE8}_{16}$
- $65536-331=65205=\texttt{FEB5}_{16}$

---


**12.** What is the 16-bit hexadecimal representation of each of the following signed decimal integers?  
> a. `-21`  
> b. `-45`  
>

| 항목 | 10진수 | 16비트 16진수 |
|---|---:|---|
| a | -21 | **`FFEB`** |
| b | -45 | **`FFD3`** |

---


**13.** The following 16-bit hexadecimal numbers represent signed integers. Convert each to decimal.  
> a. `6BF9`  
> b. `C123`  
>

| 항목 | 16진수 | 판정 및 계산 | 답 |
|---|---:|---|---:|
| a | `6BF9` | MSB가 0이므로 양수 | **27641** |
| b | `C123` | $49443-65536$ | **-16093** |

---


**14.** The following 16-bit hexadecimal numbers represent signed integers. Convert each to decimal.  
> a. `4CD2`  
> b. `8230`  
>

| 항목 | 16진수 | 판정 및 계산 | 답 |
|---|---:|---|---:|
| a | `4CD2` | MSB가 0이므로 양수 | **19666** |
| b | `8230` | $33328-65536$ | **-32208** |

---


**15.** What is the decimal representation of each of the following signed binary numbers?  
> a. `10110101`  
> b. `00101010`  
> c. `11110000`  
>

2의 보수 표현으로 해석한다.

| 항목 | 이진수 | 답 |
|---|---|---:|
| a | `10110101` | **-75** |
| b | `00101010` | **42** |
| c | `11110000` | **-16** |

예를 들어 `10110101`은 부호 없는 값으로 181이므로 다음과 같다.

$$181-256=-75$$

---


**16.** What is the decimal representation of each of the following signed binary numbers?  
> a. `10000000`  
> b. `11001100`  
> c. `10110111`  
>

| 항목 | 이진수 | 답 |
|---|---|---:|
| a | `10000000` | **-128** |
| b | `11001100` | **-52** |
| c | `10110111` | **-73** |

---


**17.** What is the 8-bit binary (two's-complement) representation of each of the following signed decimal integers?  
> a. `-5`  
> b. `-42`  
> c. `-16`  
>

| 항목 | 10진수 | 8비트 2의 보수 |
|---|---:|---|
| a | -5 | **`11111011`** |
| b | -42 | **`11010110`** |
| c | -16 | **`11110000`** |

---


**18.** What is the 8-bit binary (two's-complement) representation of each of the following signed decimal integers?  
> a. `-72`  
> b. `-98`  
> c. `-26`  
>

| 항목 | 10진수 | 8비트 2의 보수 |
|---|---:|---|
| a | -72 | **`10111000`** |
| b | -98 | **`10011110`** |
| c | -26 | **`11100110`** |

---


**19.** What is the sum of each pair of hexadecimal integers?  
> a. `6B4 + 3FE`  
> b. `A49 + 6BD`  
>

| 항목 | 계산 | 답 |
|---|---|---|
| a | `6B4 + 3FE` | **`AB2`** |
| b | `A49 + 6BD` | **`1106`** |

---


**20.** What is the sum of each pair of hexadecimal integers?  
> a. `7C4 + 3BE`  
> b. `B69 + 7AD`  
>

| 항목 | 계산 | 답 |
|---|---|---|
| a | `7C4 + 3BE` | **`B82`** |
| b | `B69 + 7AD` | **`1316`** |

---


**21.** What are the hexadecimal and decimal representations of the ASCII character capital B?  

| 문자 | 16진수 | 10진수 |
|---|---:|---:|
| `B` | **`42`** | **66** |

---


**22.** What are the hexadecimal and decimal representations of the ASCII character capital G?  

| 문자 | 16진수 | 10진수 |
|---|---:|---:|
| `G` | **`47`** | **71** |

---


**23.** Challenge: What is the largest decimal value you can represent, using a 129-bit unsigned integer?  

$n$비트 부호 없는 정수의 최댓값은 $2^n-1$이다.

$$2^{129}-1=680564733841876926926749214863536422911$$

**답:** `680564733841876926926749214863536422911`

---


**24.** Challenge: What is the largest decimal value you can represent, using an 86-bit signed integer?  

2의 보수 $n$비트 부호 있는 정수의 범위는 다음과 같다.

$$-2^{n-1}\le x\le 2^{n-1}-1$$

따라서 최댓값은 다음과 같다.

$$2^{85}-1=38685626227668133590597631$$

**답:** `38685626227668133590597631`

---


**25.** Create a truth table to show all possible inputs and outputs for the Boolean function described by $\neg(A\lor B)$.  

| $A$ | $B$ | $A\lor B$ | $\neg(A\lor B)$ |
|---:|---:|---:|---:|
| 0 | 0 | 0 | **1** |
| 0 | 1 | 1 | **0** |
| 1 | 0 | 1 | **0** |
| 1 | 1 | 1 | **0** |

---


**26.** Create a truth table to show all possible inputs and outputs for the Boolean function described by $\neg A\land\neg B$. How would you describe the rightmost column of this table in relation to the table from question 25? Have you heard of De Morgan's Theorem?  

| $A$ | $B$ | $\neg A$ | $\neg B$ | $\neg A\land\neg B$ |
|---:|---:|---:|---:|---:|
| 0 | 0 | 1 | 1 | **1** |
| 0 | 1 | 1 | 0 | **0** |
| 1 | 0 | 0 | 1 | **0** |
| 1 | 1 | 0 | 0 | **0** |

25번과 26번의 마지막 열은 완전히 같다. 이는 **드모르간 법칙** 때문이다.

$$\neg(A\lor B)=\neg A\land\neg B$$

---


**27.** If a Boolean function has four inputs, how many rows are required for its truth table?  

입력이 $n$개이면 가능한 입력 조합은 $2^n$개이다.

$$2^4=16$$

**답: 16행**

---


**28.** How many selector bits are required for a four-input multiplexer?  

선택 비트가 $n$개이면 $2^n$개의 입력을 선택할 수 있다.

$$2^n=4\Rightarrow n=2$$

**답: 2비트**

---

# 1.7.2 Algorithm Workbench

다음 코드는 자동 진법 변환 함수인 `int(text, base)`, `bin()`, `hex()`, `format()` 등을 사용하지 않고 직접 구현한 예시이다.

---


**1.** Write a function that receives a string containing a 16-bit binary integer. The function must return the string's integer value.  

```python
def binary16_to_int(bits: str) -> int:
    if len(bits) != 16:
        raise ValueError("문자열은 정확히 16비트여야 합니다.")

    value = 0
    for ch in bits:
        if ch != "0" and ch != "1":
            raise ValueError("0과 1만 사용할 수 있습니다.")
        value = value * 2 + (1 if ch == "1" else 0)

    return value


print(binary16_to_int("0000000000110101"))  # 53
```

각 문자를 읽을 때 기존 값에 2를 곱하고 현재 비트를 더한다.

$$\text{value}\leftarrow \text{value}\times2+\text{bit}$$

> 위 함수는 문자열을 **부호 없는 정수**로 해석한다.

---


**2.** Write a function that receives a string containing a 32-bit hexadecimal integer. The function must return the string's integer value.  

```python
def hex_digit_value(ch: str) -> int:
    if "0" <= ch <= "9":
        return ord(ch) - ord("0")

    ch = ch.upper()
    if "A" <= ch <= "F":
        return ord(ch) - ord("A") + 10

    raise ValueError("잘못된 16진수 문자입니다.")


def hex32_to_int(text: str) -> int:
    if len(text) != 8:
        raise ValueError("32비트 16진수는 정확히 8자리여야 합니다.")

    value = 0
    for ch in text:
        value = value * 16 + hex_digit_value(ch)

    return value


print(hex32_to_int("000001BF"))  # 447
```

---


**3.** Write a function that receives an integer. The function must return a string containing the binary representation of the integer.  

```python
def integer_to_binary(number: int) -> str:
    if number == 0:
        return "0"

    negative = number < 0
    if negative:
        number = -number

    digits = []

    while number > 0:
        remainder = number % 2
        digits.append("1" if remainder == 1 else "0")
        number //= 2

    digits.reverse()
    result = "".join(digits)

    return "-" + result if negative else result


print(integer_to_binary(53))   # 110101
print(integer_to_binary(-53))  # -110101
```

> 음수는 비트 수가 지정되지 않았으므로 앞에 `-`를 붙인 형태로 반환한다. 고정 비트 2의 보수 표현이 필요하면 비트 폭을 별도로 지정해야 한다.

---


**4.** Write a function that receives an integer. The function must return a string containing the hexadecimal representation of the integer.  

```python
HEX_DIGITS = "0123456789ABCDEF"


def integer_to_hex(number: int) -> str:
    if number == 0:
        return "0"

    negative = number < 0
    if negative:
        number = -number

    digits = []

    while number > 0:
        remainder = number % 16
        digits.append(HEX_DIGITS[remainder])
        number //= 16

    digits.reverse()
    result = "".join(digits)

    return "-" + result if negative else result


print(integer_to_hex(447))   # 1BF
print(integer_to_hex(-447))  # -1BF
```

---


**5.** Write a function that adds two digit strings in base $b$, where $2\le b\le10$. Each string may contain as many as 1,000 digits. Return the sum in a string that uses the same number base.  

각 문자열은 최대 1,000자리라고 가정한다.

```python
def add_base_strings(left: str, right: str, base: int) -> str:
    if base < 2 or base > 10:
        raise ValueError("base는 2 이상 10 이하여야 합니다.")

    i = len(left) - 1
    j = len(right) - 1
    carry = 0
    result = []

    while i >= 0 or j >= 0 or carry:
        a = ord(left[i]) - ord("0") if i >= 0 else 0
        b = ord(right[j]) - ord("0") if j >= 0 else 0

        if a < 0 or a >= base or b < 0 or b >= base:
            raise ValueError("해당 진법에서 사용할 수 없는 숫자입니다.")

        total = a + b + carry
        result.append(chr(ord("0") + total % base))
        carry = total // base

        i -= 1
        j -= 1

    result.reverse()
    return "".join(result)


print(add_base_strings("1011", "1101", 2))  # 11000
print(add_base_strings("777", "1", 8))      # 1000
```

시간 복잡도는 두 문자열 중 더 긴 길이를 $n$이라고 할 때 $O(n)$이다.

---


**6.** Write a function that adds two hexadecimal strings, each as long as 1,000 digits. Return a hexadecimal string that represents the sum of the inputs.  

```python
HEX_DIGITS = "0123456789ABCDEF"


def hex_value(ch: str) -> int:
    ch = ch.upper()

    if "0" <= ch <= "9":
        return ord(ch) - ord("0")
    if "A" <= ch <= "F":
        return ord(ch) - ord("A") + 10

    raise ValueError("잘못된 16진수 문자입니다.")


def add_hex_strings(left: str, right: str) -> str:
    i = len(left) - 1
    j = len(right) - 1
    carry = 0
    result = []

    while i >= 0 or j >= 0 or carry:
        a = hex_value(left[i]) if i >= 0 else 0
        b = hex_value(right[j]) if j >= 0 else 0

        total = a + b + carry
        result.append(HEX_DIGITS[total % 16])
        carry = total // 16

        i -= 1
        j -= 1

    result.reverse()
    return "".join(result)


print(add_hex_strings("A49", "6BD"))  # 1106
```

---


**7.** Write a function that multiplies a single hexadecimal digit by a hexadecimal digit string as long as 1,000 digits. Return a hexadecimal string that represents the product.  

```python
HEX_DIGITS = "0123456789ABCDEF"


def hex_value(ch: str) -> int:
    ch = ch.upper()

    if "0" <= ch <= "9":
        return ord(ch) - ord("0")
    if "A" <= ch <= "F":
        return ord(ch) - ord("A") + 10

    raise ValueError("잘못된 16진수 문자입니다.")


def multiply_hex_digit(digit: str, number: str) -> str:
    if len(digit) != 1:
        raise ValueError("첫 번째 인수는 한 자리여야 합니다.")

    multiplier = hex_value(digit)
    carry = 0
    result = []

    for i in range(len(number) - 1, -1, -1):
        product = multiplier * hex_value(number[i]) + carry
        result.append(HEX_DIGITS[product % 16])
        carry = product // 16

    while carry > 0:
        result.append(HEX_DIGITS[carry % 16])
        carry //= 16

    while len(result) > 1 and result[-1] == "0":
        result.pop()

    result.reverse()
    return "".join(result)


print(multiply_hex_digit("F", "10"))   # F0
print(multiply_hex_digit("A", "123"))  # B5E
```

---


**8.** Write a Java program that contains the calculation shown below. Then, use the `javap -c` command to disassemble your code. Add comments to each line that provide your best guess as to its purpose.
>
> ```java
> int Y;
> int X = (Y + 4) * 3;
> ```
>

원문의 계산식은 다음과 같다.

```java
int Y;
int X = (Y + 4) * 3;
```

Java의 지역 변수는 초기화하지 않고 읽을 수 없으므로, 실행 가능한 프로그램에서는 `Y`에 초기값을 지정해야 한다.

### Java 코드

```java
public class Calculation {
    public static void main(String[] args) {
        int Y = 0;
        int X = (Y + 4) * 3;
        System.out.println(X);
    }
}
```

### 컴파일 및 역어셈블

```bash
javac Calculation.java
javap -c Calculation
```

컴파일러 버전에 따라 세부 주소는 달라질 수 있지만 핵심 바이트코드는 다음과 비슷하다.

```text
0:  iconst_0      // 정수 상수 0을 피연산자 스택에 넣음
1:  istore_1      // 스택의 0을 지역 변수 Y에 저장
2:  iload_1       // Y를 스택에 넣음
3:  iconst_4      // 정수 상수 4를 스택에 넣음
4:  iadd           // Y와 4를 더함
5:  iconst_3      // 정수 상수 3을 스택에 넣음
6:  imul           // (Y + 4)에 3을 곱함
7:  istore_2      // 결과를 지역 변수 X에 저장
```

출력문을 포함하면 이후에 대략 다음 명령들이 추가된다.

```text
getstatic       // System.out 객체를 스택에 넣음
iload_2         // X를 스택에 넣음
invokevirtual   // println(int)을 호출
return          // main 메서드를 종료
```

---


**9.** Devise a way of subtracting unsigned binary integers. Test your technique by subtracting binary `00000101` from binary `10001000`, producing `10000011`. Test your technique with at least two other sets of integers, in which a smaller value is always subtracted from a larger one.  

### 방법 1: 자리별 빌림

오른쪽 비트부터 뺀다.

- 현재 비트가 충분하면 바로 뺀다.
- 피감수 비트가 감수 비트보다 작으면 왼쪽 자리에서 1을 빌린다.
- 이진수에서 왼쪽의 1을 빌리면 현재 자리에는 `10₂`, 즉 2가 더해진다.

문제의 예:

```text
  10001000
- 00000101
----------
  10000011
```

10진수로 확인하면 다음과 같다.

$$136-5=131$$

그리고 `10000011₂`은 131이다.

### 추가 예제 1

```text
  00001101
- 00000111
----------
  00000110
```

$$13-7=6$$

### 추가 예제 2

```text
  00110100
- 00010011
----------
  00100001
```

$$52-19=33$$

### 2의 보수를 이용하는 방법

$n$비트 환경에서 $A-B$는 다음처럼 계산할 수도 있다.

$$A-B=A+(\text{B의 2의 보수})$$

예를 들어 `10001000 - 00000101`에서 `00000101`의 2의 보수는 다음과 같다.

```text
00000101  원래 수
11111010  비트 반전
11111011  1을 더한 2의 보수
```

덧셈:

```text
  10001000
+ 11111011
-----------
1 10000011
```

고정된 8비트 계산에서는 맨 앞의 캐리를 버리므로 결과는 **`10000011`**이다.

---

# 최종 답 요약

| 번호 | 답 |
|---:|---|
| 1 | 비트 7, 가장 왼쪽 비트 |
| 2 | 53, 150, 204 |
| 3 | `110001010`, `110010110`, `100100001` |
| 4 | `00000110` |
| 5 | 16, 32, 64, 128비트 |
| 6 | 12, 16, 16비트 |
| 7 | `35DA`, `CEA3`, `FEDB` |
| 8 | `00000001001001101111100111010100`, `01101010110011011111101010010101`, `11110110100110111101110000101010` |
| 9 | 58, 447, 4097 |
| 10 | 98, 1203, 671 |
| 11 | `FFE8`, `FEB5` |
| 12 | `FFEB`, `FFD3` |
| 13 | 27641, -16093 |
| 14 | 19666, -32208 |
| 15 | -75, 42, -16 |
| 16 | -128, -52, -73 |
| 17 | `11111011`, `11010110`, `11110000` |
| 18 | `10111000`, `10011110`, `11100110` |
| 19 | `AB2`, `1106` |
| 20 | `B82`, `1316` |
| 21 | `42`₁₆, 66₁₀ |
| 22 | `47`₁₆, 71₁₀ |
| 23 | 680564733841876926926749214863536422911 |
| 24 | 38685626227668133590597631 |
| 25–26 | 두 식의 출력이 동일함 |
| 27 | 16행 |
| 28 | 선택 비트 2개 |
