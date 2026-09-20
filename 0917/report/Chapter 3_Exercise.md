# 0917 과제 - Chapter 3 Review Questions 풀이

## 3.9 Review Questions and Exercises

### 3.9.1 Short Answer

**1. Provide examples of three different instruction mnemonics.**

니모닉(Mnemonic)은 기계어 명령어를 프로그래머가 읽고 쓰기 쉽게 기호로 나타낸 약어이다. 데이터를 이동시키거나 산술 연산을 하는 명령어들이 이에 해당한다.

**`MOV`, `ADD`, `SUB`, `JMP` 등**

**2. What is a calling convention, and how is it used in assembly language declarations?**

호출 규칙(Calling convention)은 프로시저(함수)를 호출할 때 매개변수 전달 방식과 스택 정리 주체를 정해놓은 약속. 어셈블리에서 `INVOKE`를 사용할 때 이 규칙(예: `stdcall`, `cdecl`)을 참고.

서브루틴 호출 시 **매개변수를 어떤 레지스터나 스택에 넣어 전달할지, 반환 시 스택을 호출자가 정리할지 호출된 함수가 정리할지 결정하는 규칙**이다.

**3. How do you reserve space for the stack in a program?**

스택 메모리 공간을 할당하려면 특정 디렉티브(지시어)를 사용해야 한다.

**`.STACK` 디렉티브를 사용하여 스택 크기를 예약한다. (예: `.STACK 4096`)**

**4. Explain why the term assembler language is not quite correct.**

어셈블러는 코드를 기계어로 번역하는 도구(소프트웨어)의 이름이고, 언어 자체의 이름은 다르다.

언어 그 자체를 칭할 때는 **'어셈블리 언어(Assembly Language)'**라고 부르는 것이 올바르며, **어셈블러(Assembler)는 번역 프로그램 자체를 의미**하기 때문이다.

**5. Explain the difference between big endian and little endian. Also, look up the origins of this term on the Web.**

다중 바이트 데이터를 메모리에 배치하는 방식의 차이다. 유래는 조나단 스위프트의 '걸리버 여행기'에서 달걀의 넓은 쪽(Big)과 좁은 쪽(Little) 중 어디부터 깰지 다투는 이야기에서 파생되었다.

**빅 엔디안(Big-endian)은 데이터의 최상위 바이트(MSB)를 가장 낮은 메모리 주소에 저장**하고, **리틀 엔디안(Little-endian)은 데이터의 최하위 바이트(LSB)를 가장 낮은 메모리 주소에 저장**한다.

**6. Why might you use a symbolic constant rather than an integer literal in your code?**

코드 내에 직접 숫자를 적는 하드코딩은 나중에 수정하기 어렵게 만들고 코드의 의미를 파악하기 힘들게 한다.

값에 이름을 부여하여 **코드의 가독성을 높이고, 값이 변경될 때 선언부 한 곳만 수정하면 되므로 유지보수성이 크게 향상**되기 때문이다.

**7. How is a source file different from a listing file?**

소스 파일은 사람이 직접 작성한 코드이고, 리스팅 파일은 번역 과정에서 생성되는 메타데이터가 담긴 결과물이다.

**소스 파일은 프로그래머가 작성한 어셈블리 코드 파일**이고, **리스팅 파일은 어셈블러가 번역을 수행한 뒤 생성하는 파일로 기계어 코드, 메모리 주소, 원본 코드, 기호 테이블 등이 모두 포함**되어 있다.

**8. How are data labels and code labels different?**

데이터 레이블은 변수를 가리키고, 코드 레이블은 실행 흐름(분기)의 타겟이 된다. 구문 작성법에도 차이가 있다.

**데이터 레이블은 데이터 영역의 오프셋(변수 이름)을 나타내며 이름 뒤에 콜론을 쓰지 않지만**, **코드 레이블은 분기(`JMP` 등)의 대상이 되는 위치를 나타내며 이름 뒤에 반드시 콜론(`:`)을 붙여야** 한다.

**9. (True/False): An identifier cannot begin with a numeric digit.**

식별자(변수명 등)의 첫 글자로는 숫자를 사용할 수 없다.

**True**

**10. (True/False): A hexadecimal literal may be written as 0x3A.**

C언어 계열에서는 `0x` 접두사를 쓰지만, 일반적인 x86 어셈블러(MASM)는 접미사 표기를 따른다. MASM에서는 일반적으로 숫자 뒤에 `h`를 붙여 `3Ah`와 같이 표기한다.

**False**

**11. (True/False): Assembly language directives execute at runtime.**

어셈블리 디렉티브(지시어)는 프로그램이 실행될 때(runtime)가 아니라 어셈블러가 코드를 번역할 때(assembly time) 동작한다.

**False**

**12. (True/False): Assembly language directives can be written in any combination of uppercase and lowercase letters.**

MASM의 디렉티브는 기본적으로 대소문자를 구분하지 않으므로 섞어서 사용할 수 있다.

**True**

**13. Name the four basic parts of an assembly language instruction.**

어셈블리 명령어의 기본 구조를 이루는 4가지 요소가 있다.

**레이블(Label), 니모닉(Mnemonic), 피연산자(Operand), 주석(Comment)**

**14. (True/False): MOV is an example of an instruction mnemonic.**

MOV는 데이터를 복사/이동시키는 명령어의 니모닉이다.

**True**

**15. (True/False): A code label is followed by a colon (:), but a data label does not end with a colon.**

코드 레이블 뒤에는 콜론이 붙고 데이터 레이블 뒤에는 붙지 않는다.

**True**

**16. Show an example of a block comment.**

여러 줄의 주석을 달 때는 `COMMENT` 디렉티브와 사용자 정의 기호(예: `!`, `@` 등)를 사용하여 블록을 감싼다.

**`COMMENT !`**  
**(이곳에 주석 내용 작성)**  
**`!`**

**17. Why is it not a good idea to use numeric addresses when writing instructions that access variables?**

메모리 주소는 코드를 수정하면 위치가 언제든 변경될 수 있다.

새로운 명령어나 변수가 추가/삭제될 때마다 **모든 데이터의 물리적 메모리 주소가 변동**될 수 있으므로, 숫자 주소를 하드코딩하면 프로그램이 엉뚱한 데이터를 참조하여 심각한 오류가 발생한다.

**18. What type of argument must be passed to the ExitProcess procedure?**

프로그램이 종료될 때 운영체제에 성공 또는 에러 상태를 알려야 한다.

운영체제에 반환할 **종료 코드(Return code, 일반적으로 정상 종료 시 `0`)**를 전달해야 한다.

**19. Which directive ends a procedure?**

프로시저(함수)가 끝남을 알리는 디렉티브이다.

**ENDP**

**20. In 32-bit mode, what is the purpose of the identifier in the END directive?**

`END main`과 같이 END 뒤에 붙는 식별자는 프로그램이 처음 실행될 위치를 나타낸다.

**프로그램의 시작점(엔트리 포인트)을 지정하는 역할을 한다.**

**21. What is the purpose of the PROTO directive?**

`PROTO`는 다른 모듈(파일)에 있는 함수를 가져다 쓸 때 함수의 구조를 미리 알려주는 역할을 한다.

**프로시저의 프로토타입을 선언하여 매개변수와 반환 타입을 어셈블러에 미리 알려준다.**

**22. (True/False): An Object file is produced by the Linker.**

오브젝트 파일(Object file)은 링커가 아니라 어셈블러가 코드를 기계어로 번역하여 생성하는 파일이다. 링커는 이 파일을 엮어 실행 파일(Executable)을 만든다.

**False**

**23. (True/False): A Listing file is produced by the Assembler.**

리스팅 파일은 어셈블러가 어셈블리 과정의 상세 정보(기계어, 주소 등)를 기록하여 만들어내는 파일이다.

**True**

**24. (True/False): A link library is added to a program just before producing an Executable file.**

링커는 실행 파일을 최종적으로 만들기 직전에 링크 라이브러리를 포함하여 하나의 프로그램으로 완성한다.

**True**

**25. Which data directive creates a 32-bit signed integer variable?**

32비트 크기의 부호 있는(signed) 정수형 데이터를 생성하는 디렉티브이다.

**SDWORD**

**26. Which data directive creates a 16-bit signed integer variable?**

16비트 크기의 부호 있는 정수형 데이터를 생성하는 디렉티브이다.

**SWORD**

**27. Which data directive creates a 64-bit unsigned integer variable?**

64비트 크기의 부호 없는(unsigned) 정수형 데이터를 생성하는 디렉티브이다.

**QWORD**

**28. Which data directive creates an 8-bit signed integer variable?**

8비트 크기의 부호 있는 정수형 데이터를 생성하는 디렉티브이다.

**SBYTE**

**29. Which data directive creates a 10-byte packed BCD variable?**

10바이트 크기의 팩 10진수(Packed BCD) 데이터를 생성하는 디렉티브이다.

**TBYTE**

---

### 3.9.2 Algorithm Workbench

**1. Define four symbolic constants that represent integer 25 in decimal, binary, octal, and hexadecimal formats.**

10진수 25를 각각 10진수, 2진수, 8진수, 16진수로 표현하는 기호 상수를 선언한다. MASM 문법에 맞게 접미사를 사용한다.

```assembly
DEC_VAL = 25
BIN_VAL = 00011001b
OCT_VAL = 31o  ; (또는 31q)
HEX_VAL = 19h

```

**2. Find out, by trial and error, if a program can have multiple code and data segments.**

어셈블러(MASM)는 프로그램을 작성할 때 여러 개의 데이터 세그먼트(`.data`)와 코드 세그먼트(`.code`)를 반복해서 선언하고 배치하는 것을 허용합니다.

**네, 하나의 프로그램 내에 여러 개의 데이터 세그먼트와 코드 세그먼트를 가질 수 있습니다.**

**3. Create a data definition for a doubleword that stored it in memory in big endian format.**

x86 아키텍처는 기본적으로 리틀 엔디안(Little-endian)을 사용합니다. 따라서 더블워드 데이터(예: `12345678h`)를 빅 엔디안 순서로 메모리에 배치하려면 바이트 단위로 쪼개서 순서를 직접 역순 지정해야 합니다.

```assembly
myBigEndian BYTE 12h, 34h, 56h, 78h
```

**4. Find out if you can declare a variable of type DWORD and assign it a negative value. What does this tell you about the assembler's type checking?**

`DWORD`는 부호 없는 32비트 자료형이지만, 음수 값을 할당하면 어셈블러가 에러를 발생시키지 않고 이를 2의 보수(2's complement)로 자동 변환하여 저장합니다.

**DWORD 변수에 음수 값을 할당할 수 있습니다. 이는 어셈블러가 데이터의 부호 유무(타입)를 엄격하게 검사하지 않고, 크기만 맞으면 값을 2의 보수 형태로 변환하여 그대로 메모리에 저장한다는 것을 의미합니다.**

**5. Write a program that contains two instructions: (1) add the number 5 to the EAX register, and (2) add 5 to the EDX register. Generate a listing file and examine the machine code generated by the assembler. What differences, if any, did you find between the two instructions?**

EAX에 5를 더하는 명령어(`add eax, 5`)와 EDX에 5를 더하는 명령어(`add edx, 5`)를 어셈블리하여 리스팅 파일을 확인해 보면, 명령의 전체적인 기계어 형태는 동일하나 레지스터를 나타내는 비트 값이 다르게 나타납니다.

**두 명령어는 기계어 코드가 매우 유사하지만, 피연산자로 사용된 특정 레지스터(EAX와 EDX)를 식별하는 기계어 내의 비트 필드(ModR/M 바이트 등) 값이 서로 다르게 생성됩니다.**

**6. Given the number 456789ABh, list out its byte values in little-endian order.**

리틀 엔디안 방식은 데이터의 최하위 바이트(LSB)부터 먼저 낮은 주소의 메모리에 저장합니다. 주어진 숫자를 1바이트씩 나누면 `45`, `67`, `89`, `AB`이며 이를 역순으로 배치합니다.

**`ABh, 89h, 67h, 45h`**

**7. Declare an array of 120 uninitialized unsigned doubleword values.**

초기화되지 않은 120개의 부호 없는 32비트 데이터(더블워드)를 배열로 선언합니다. 할당 시 초기화 값이 없으므로 `DUP(?)` 연산자를 사용합니다.

```assembly
myArray DWORD 120 DUP(?)
```

**8. Declare an array of byte and initialize it to the first 5 letters of the alphabet.**

바이트 크기의 배열을 선언하고 알파벳 첫 5글자인 A, B, C, D, E로 초기화합니다.

```assembly
letters BYTE 'A', 'B', 'C', 'D', 'E'
```

**9. Declare a 32-bit signed integer variable and initialize it with the smallest possible negative decimal value. (Hint: Refer to integer ranges in Chapter 1.)**

32비트 부호 있는 정수(`SDWORD`)가 표현할 수 있는 값의 범위는 -2,147,483,648부터 2,147,483,647까지입니다. 따라서 가장 작은 음숫값으로 변수를 초기화합니다.

```assembly
minVal SDWORD -2147483648
```

**10. Declare an unsigned 16-bit integer variable named wArray that uses three initializers.**

초기값이 3개 할당된 부호 없는 16비트(`WORD`) 정수형 배열 변수 `wArray`를 선언합니다.

```assembly
wArray WORD 10, 20, 30
```

**11. Declare a string variable containing the name of your favorite color. Initialize it as a nullterminated string.**

문자열은 바이트 배열로 생성하며, 널 종료 문자열(Null-terminated string) 형식을 맞추기 위해 배열 끝에 널 문자(`0`)를 붙여줍니다.

```assembly
myColor BYTE "Blue", 0
```

**12. Declare an uninitialized array of 50 signed doublewords named dArray.**

50개의 부호 있는 더블워드(`SDWORD`) 크기 데이터를 배열로 할당하되, 초기화하지 않기 위해 `DUP(?)` 연산자를 활용합니다.

```assembly
dArray SDWORD 50 DUP(?)
```

**13. Declare a string variable containing the word "TEST" repeated 500 times.**

동일한 문자열을 500번 반복해서 저장하려면 `DUP` 지시어와 함께 반복할 문자열을 지정해 줍니다.

```assembly
testString BYTE 500 DUP("TEST")
```

**14. Declare an array of 20 unsigned bytes named bArray and initialize all elements to zero.**

20개의 부호 없는 바이트 크기 배열을 생성하고, 모든 배열 요소의 값을 0으로 초기화합니다.

```assembly
bArray BYTE 20 DUP(0)
```

**15. Show the order of individual bytes in memory (lowest to highest) for the following double-word variable: `val1 DWORD 87654321h`**

메모리에 데이터가 담길 때는 리틀 엔디안 규칙을 따르므로 가장 오른쪽의 최하위 바이트부터 역순으로 들어갑니다.

**`21h, 43h, 65h, 87h`**
