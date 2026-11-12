# 32-bit MASM 5개 정수 평균 계산기 (Windows 11 / Win32 API)

이 프로젝트는 **Visual Studio** 환경에서 32비트 MASM(Microsoft Macro Assembler)을 사용하여 작성된 x86 어셈블리 프로그램입니다.  
외부 라이브러리(`Irvine32` 등)를 사용하지 않고, Windows 기본 C 런타임 및 Win32 API (`kernel32.lib`)의 UTF-16 콘솔 입출력 함수(`ReadConsoleW`, `WriteConsoleW`)를 이용해 5개의 정수를 입력받고 그 평균을 구합니다.

## 📌 주요 특징 (Key Features)

* **순수 Win32 API 사용**: `Irvine32` 같은 별도 라이브러리 설치 없이 `kernel32.lib`만으로 동작합니다.
* **UTF-16 유니코드 지원**: 한글 안내 메시지 출력을 위해 `WriteConsoleW` 및 UTF-16 문자 코드를 사용합니다.
* **부호 있는 정수 처리**: 양수(`+`) 및 음수(`-`) 정수 입력을 지원하며, 부호 있는 나눗셈 명령어(`cdq`, `idiv`)를 통해 정확한 정수 평균값을 계산합니다.
* **자체 문자열 변환 프로시저 구현**:
  * `WStrToInt`: UTF-16 입력 문자열을 32비트 정수(`SDWORD`)로 변환
  * `IntToWStr`: 32비트 정수를 출력용 UTF-16 문자열로 변환

## 🛠️ 개발 및 실행 환경 (Environment)

* **운영체제**: Windows 11 (64-bit / 32-bit)
* **개발 도구**: Visual Studio 2019 / 2022 이상
* **아키텍처**: x86 (32비트)
* **어셈블러**: Microsoft Macro Assembler (MASM)

## ⚙️ Visual Studio 프로젝트 설정 방법

1. **프로젝트 생성**
   * Visual Studio를 실행하고 `C++ 빈 프로젝트`를 생성합니다.

2. **MASM 빌드 사용자 지정 (Build Customizations)**
   * 솔루션 탐색기에서 프로젝트 이름을 **우클릭** -> **빌드 의존성(Build Dependencies)** -> **빌드 사용자 지정(Build Customizations...)**을 선택합니다.
   * 목록에서 `masm (.targets, .props)`에 체크 후 **확인**을 클릭합니다.

3. **소스 파일 추가**
   * 프로젝트의 `소스 파일` 폴더 우클릭 -> **추가** -> **새 항목**.
   * 파일 이름을 `main.asm`으로 지정하고 추가합니다.

4. **빌드 플랫폼 설정 (중요)**
   * 상단 툴바의 빌드 플랫폼 설정을 `x64`에서 `x86`으로 변경합니다.

5. **프로젝트 속성 설정**
   * 프로젝트 우클릭 -> **속성(Properties)**으로 이동합니다.
   * **링커(Linker)** -> **시스템(System)**:
     * `하위 시스템(Subsystem)` -> **`콘솔 (/SUBSYSTEM:CONSOLE)`** 선택
   * **링커(Linker)** -> **고급(Advanced)**:
     * `진입점(Entry Point)` -> **`main`** 입력 (필요시)

## 🚀 실행 예시 (Usage)

프로젝트를 빌드 후 실행(`Ctrl + F5`)하면 아래와 같이 콘솔 창에서 5개의 정수를 순차적으로 입력받고 평균을 출력합니다.

```text
정수 입력 (1/5): 10
정수 입력 (2/5): -20
정수 입력 (3/5): 30
정수 입력 (4/5): 40
정수 입력 (5/5): -10
평균값: 10
```

## 📐 소스 코드 구조 요약 (Code Structure)

```assembly
.386
.model flat, stdcall
option casemap :none

includelib kernel32.lib  ; Win32 API 링킹

; Win32 API 프로토타입 선언
GetStdHandle  PROTO :DWORD
ReadConsoleW  PROTO :DWORD, :PTR WORD, :DWORD, :PTR DWORD, :DWORD
WriteConsoleW PROTO :DWORD, :PTR WORD, :DWORD, :PTR DWORD, :DWORD
ExitProcess   PROTO :DWORD

.data
    ; 유니코드 안내 문구 및 변수 선언

.code
WStrToInt PROC
    ; UTF-16 문자열 -> 32비트 정수 변환 로직
WStrToInt ENDP

IntToWStr PROC
    ; 32비트 정수 -> UTF-16 문자열 변환 로직
IntToWStr ENDP

main PROC
    ; 1. Standard Input/Output 핸들 획득
    ; 2. Loop를 이용해 5회 정수 입력 받기 (ReadConsoleW -> WStrToInt)
    ; 3. sum에 누적 후 5로 나눗셈 (idiv)
    ; 4. 평균값 출력 (IntToWStr -> WriteConsoleW)
    ; 5. 프로세스 종료
main ENDP
END main
```
