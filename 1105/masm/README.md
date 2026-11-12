# 32-bit MASM 학생 정보 출력 코드 및 설명

## 소스 코드

```assembly
.386
.model flat, stdcall
option casemap :none

GetStdHandle PROTO :DWORD
WriteConsoleW PROTO :DWORD, :PTR WORD, :DWORD, :PTR DWORD, :DWORD
ExitProcess  PROTO :DWORD

STD_OUTPUT_HANDLE EQU -11

.data
    student_info WORD '2','0','2','5','6','6','4','0','4','6',' ',0CD5Ch,0ACC4h,0C601h,13,10,0
    info_len     DWORD ($ - student_info) / 2 - 1

.data?
    hStdOut      DWORD ?
    bytesWritten DWORD ?

.code
main PROC
    INVOKE GetStdHandle, STD_OUTPUT_HANDLE
    MOV hStdOut, EAX

    INVOKE WriteConsoleW, hStdOut, ADDR student_info, info_len, ADDR bytesWritten, 0

    INVOKE ExitProcess, 0
main ENDP

END main
```

---

## 코드 설명

### 1. 기본 환경 및 어셈블러 설정
* **`.386`**: Intel 80386 이상의 32비트 명령어와 32비트 범용 레지스터(`EAX` 등)를 사용하도록 지정합니다.
* **`.model flat, stdcall`**: 
  * `flat`: 32비트 Flat 메모리 모델(4GB 단일 주소 공간)을 사용합니다.
  * `stdcall`: Win32 API의 표준 함수 호출 규약을 사용하며, 호출된 함수 내부에서 스택 메모리를 정리하도록 설정합니다.
* **`option casemap :none`**: 변수, 라벨, API 함수명에 대해 대소문자를 엄격히 구분하도록 지정합니다.

### 2. Win32 API 프로토타입 및 상수 선언
* **`GetStdHandle PROTO :DWORD`**: 입출력 핸들을 가져오는 API 함수 원형입니다.
* **`WriteConsoleW PROTO ...`**: 콘솔 화면에 UTF-16 유니코드 문자열을 출력하는 API 함수 원형입니다.
* **`ExitProcess PROTO :DWORD`**: 현재 프로세스를 종료하는 API 함수 원형입니다.
* **`STD_OUTPUT_HANDLE EQU -11`**: 표준 출력(콘솔 화면) 장치를 나타내는 Win32 시스템 상수 정의입니다.

### 3. 데이터 세그먼트 (`.data` / `.data?`)
* **`student_info`**:
  * 2바이트 크기의 `WORD` 배열로 UTF-16LE 문자열을 정의합니다.
  * 구성 요소: 학번(`'2'`~`'6'`), 공백(`' '`), 한글 유니코드(`0CD5Ch`='최', `0ACC4h`='계', `0C601h`='원'), CR(`13`), LF(`10`), NULL 종료 문자(`0`).
* **`info_len`**:
  * `$`(현재 위치 주소)에서 `student_info`(시작 주소)를 빼 전체 바이트 크기(34바이트)를 구합니다.
  * 1글자가 2바이트(`WORD`)이므로 `2`로 나누어 총 원소 개수(17개)를 얻습니다.
  * 마지막 NULL 문자(`0`) 1개는 출력 대상에서 제외하기 위해 `- 1`을 수행하여 최종 16글자의 길이를 계산합니다.
* **`hStdOut`, `bytesWritten`**:
  * 초기화되지 않은 데이터 영역(`.data?`)에 선언된 4바이트(`DWORD`) 변수입니다.
  * 각각 구한 콘솔 출력 핸들과 실제 출력된 문자 수를 저장하기 위한 공간입니다.

### 4. 코드 세그먼트 (`.code`)
* **`INVOKE GetStdHandle, STD_OUTPUT_HANDLE`**: 콘솔 출력 핸들을 요청하며, 반환된 핸들 값(`EAX`)을 `hStdOut` 변수에 저장합니다.
* **`INVOKE WriteConsoleW, ...`**: `hStdOut` 핸들을 이용하여 `student_info`에 저장된 유니코드 문자열을 `info_len`만큼 화면에 출력합니다.
* **`INVOKE ExitProcess, 0`**: OS에 종료 코드 `0`을 반환하고 프로그램을 안전하게 종료합니다.
