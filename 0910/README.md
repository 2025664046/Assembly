# Chapter 2. x86 Processor Architecture

---

## 2.1 General Concepts
### 2.1.1 Basic Microcomputer Design

- **CPU**: 연산·제어의 중심
  - **ALU(Arithmetic Logic Unit)**: 산술/논리 연산 수행
  - **CU(Control Unit)**: 데이터·명령 흐름 제어
  - **Clock**: CPU와 내부 구성요소의 동작 동기화 (1 cycle = 클럭 1주기)
  - **Registers**: CPU 내부의 초고속 저장 공간
- **Memory storage unit**: 프로그램(코드)과 데이터를 보관
- **Bus(버스)**: 병렬 전송 선로 묶음
  - **Data bus**: 데이터 전송
  - **Address bus**: 접근할 주소 전달
  - **Control bus**: 읽기/쓰기 등 제어 신호 전달

### 2.1.2 Instruction Execution Cycle

명령어 하나가 처리되는 순서:

1. **Fetch Instruction** — 메모리에서 명령어를 가져온다.
2. **Increment Instruction Pointer** — IP(EIP/RIP)를 다음 명령어로 갱신한다.
3. **Decode Instruction** — 명령어의 비트 패턴을 해석한다.
4. **Fetch Operands** — 레지스터/메모리에서 피연산자를 읽는다.
5. **Execute Instruction** — 실제 연산을 수행한다.
6. **Update Status Flags** — Zero, Carry, Overflow 등 플래그를 갱신한다.
7. **Store Result** — 결과를 출력 피연산자에 저장한다.

#### 예제: `MOV AX, 1234h` = `B8 34 12`

| 단계 | 동작 | IP 변화 |
|---|---|---|
| 1 | 첫 바이트 `B8` fetch | 1000 → 1001 |
| 2 | opcode `B8` decode → `MOV AX, imm16` 인식, **즉시값 2바이트 필요** 판단 | - |
| 3 | 첫 operand 바이트 `34` fetch | 1001 → 1002 |
| 4 | 두 번째 operand 바이트 `12` fetch | 1002 → 1003 |
| 5 | `B8 34 12` 전체 해독 완료 → `MOV AX, 1234h` 확정 | - |
| 6 | Execute: `AX ← 1234h` | - |

### Simplified CPU Block Diagram

- **Code cache / Data cache**: 명령어와 데이터를 미리 담아 속도 향상
- **Instruction decoder**: 명령어 해석 후 제어 신호 생성
- **FPU**: 실수 연산 전담

### 2.1.3 Reading from Memory (Memory Read Sequence)

1. **Place Address on Bus** — 원하는 메모리 주소를 주소 버스에 올린다.
2. **Assert RD Pin** — RD 핀을 활성화해 읽기 동작임을 알린다.
3. **Wait for Response** — 메모리 칩이 응답할 때까지 대기한다.
4. **Copy Data** — 데이터 버스의 값을 목적지 피연산자로 복사한다.

### 2.1.4 Loading and Executing a Program

1. **Search for Program** — OS가 디렉터리에서 프로그램 파일을 찾는다.
2. **Retrieve File Information** — 파일 크기·위치 정보를 얻는다.
3. **Load Program into Memory** — 메모리에 적재하고 공간을 할당한다.
4. **Begin Execution** — 프로그램 실행을 시작한다.
5. **Track Process** — 프로세스를 추적하고 자원을 관리한다.
6. **End Process** — 종료 시 메모리에서 프로세스를 제거한다.

---

## 2.2 32-Bit x86 Processors

### 2.2.1 Modes of Operation

| 모드 | 설명 |
|---|---|
| **Protected Mode** | 전체 명령어 집합과 메모리 보호 제공. 현대 OS의 기본 모드 |
| **Virtual-8086 Mode** | 보호된 환경에서 real-address mode 소프트웨어 실행 |
| **Real-Address Mode** | 시스템 메모리·하드웨어에 직접 접근. 특수 하드웨어 제어용 |
| **System Management Mode (SMM)** | 전원 관리·시스템 보안 기능. 제조사가 커스터마이즈 |

#### 메모리 주소 지정 능력

| 모드 | 주소 공간 |
|---|---|
| Protected Mode | 4 GB 선형 주소 공간 |
| Real-Address Mode | 1 MB 로 제한 |
| Virtual-8086 Mode | 프로그램당 1 MB 영역 제공 |
| Extended Physical Addressing | 최대 64 GB 물리 주소 지정 |

#### 모드 비교

| 특성 | Real-Address | Protected | Virtual-8086 |
|---|---|---|---|
| 메모리 접근 | 임의 위치 직접 접근 | 제한적 접근 + 메모리 보호 | 보호 모드 안에서 real mode 모사 |
| 메모리 한계 | 1 MB | 프로세스당 4 GB | 1 MB 가상 공간 |
| 프로그램 실행 | 한 번에 하나 | 여러 프로그램 동시 | 다중 가상 머신 |
| OS 지원 | MS-DOS, Windows 95/98 | MS-Windows, Linux | Windows NT/2000/XP (DOS용) |
| 하드웨어 접근 | 직접 접근 | 제한적 접근 | 제한적, 일부 프로그램 실행 불가 |

### 2.2.2 Basic Execution Environment

#### 레지스터 구성

- **32비트 범용 레지스터(8개)**: EAX, EBX, ECX, EDX, EBP, ESP, ESI, EDI
- **16비트 세그먼트 레지스터(6개)**: CS, SS, DS, ES, FS, GS
- **특수 레지스터**: EFLAGS, EIP

#### 레지스터 분할 (예: EAX)

| 32-Bit | 16-Bit | 8-Bit (High) | 8-Bit (Low) |
|---|---|---|---|
| EAX | AX | AH | AL |
| EBX | BX | BH | BL |
| ECX | CX | CH | CL |
| EDX | DX | DH | DL |

| 32-Bit | 16-Bit |
|---|---|
| ESI | SI |
| EDI | DI |
| EBP | BP |
| ESP | SP |

> ESI, EDI, EBP, ESP는 **8비트 단위 접근이 불가능**하다.

#### 레지스터별 특수 용도

| 레지스터 | 주 용도 |
|---|---|
| **EAX** | 곱셈·나눗셈 시 자동 사용 (누산기, Accumulator) |
| **ECX** | 루프 카운터 |
| **ESP** | 스택 데이터 주소 지정 (Stack Pointer) |
| **EBP** | 함수 매개변수·지역 변수 참조 (Base Pointer) |
| **ESI / EDI** | 고속 메모리 전송(문자열 연산)용 인덱스 |

#### 세그먼트 레지스터

| 레지스터 | 역할 |
|---|---|
| **CS** (Code Segment) | 명령어, 코드 실행 |
| **DS** (Data Segment) | 변수, 데이터 접근 |
| **SS** (Stack Segment) | 스택 프레임, 매개변수, 지역 변수 |
| **ES** (Extra Segment) | 문자열 연산, 추가 데이터 |
| **FS** | 스레드 로컬 저장소(TLS), 컨텍스트 관리 |
| **GS** | OS 고유 데이터, 시스템 콜 |

#### EIP (Instruction Pointer)

- **무엇인가?** CPU가 실행할 **다음 명령어의 주소**를 담는다.
- **어떻게 동작?** 명령어 실행에 따라 순차적으로 자동 갱신된다.
- **변경 가능?** `JMP`, `CALL`, `RET`, 조건 분기 명령이 EIP를 변경해 분기를 일으킨다.

#### EFLAGS Register

- **Status Flags**: CPU의 산술·논리 연산 결과를 반영
- **Control Flags**: 프로그램이 CPU 동작을 제어
- 특정 명령어(`CLC`, `STC` 등)로 플래그를 직접 조작 가능

| Status Flag | 의미 |
|---|---|
| **Carry (CF)** | 부호 없는 결과가 목적지보다 큼 |
| **Overflow (OF)** | 부호 있는 결과가 목적지 범위를 벗어남 |
| **Sign (SF)** | 결과가 음수 |
| **Zero (ZF)** | 결과가 0 |
| **Auxiliary Carry (AC)** | 비트 3 → 비트 4 자리올림 (8비트) |
| **Parity (PF)** | 결과의 1 비트 개수가 짝수 |

Control Flags: Interrupt Flag, Direction Flag, Instruction Break(Trap), Arithmetic Overflow Interrupt, Protected Mode / Virtual-8086 Mode 관련 플래그 등

### MMX Technology

- **MMX Registers**: 64비트 × 8개, SIMD 용도
- **SIMD Instructions**: 하나의 명령으로 여러 데이터를 동시 처리
- **FPU Sharing**: 부동소수점 레지스터와 하드웨어를 공유
- **Multimedia Processing**: 비디오·오디오·그래픽 성능 향상

### Floating-Point Unit (FPU)

- 역할: 고속 부동소수점 연산 수행
- 발전 과정: **별도 코프로세서 칩 → Intel486에서 통합 → 현대 프로세서의 표준 구성요소**

| 구분 | 구성 |
|---|---|
| 80-Bit Data Registers | ST(0) ~ ST(7) (스택 구조, 8개) |
| 48-Bit Pointer Registers | FPU instruction pointer, FPU data pointer |
| 16-Bit Control Registers | Tag register, Control register, Status register |
| 기타 | Opcode register |

---

## 2.3 64-Bit x86-64 Processors

### Key Features

| 특징 | 내용 |
|---|---|
| 64-bit Registers | 64비트 정수 피연산자 사용 가능 |
| 64-bit Addresses | 매우 큰 가상 주소 공간 |
| 48-bit Physical Address Space | 최대 256 TB RAM 지원 |
| Additional Registers | x86보다 많은 범용 레지스터 제공 |
| Backward Compatibility | 기존 x86 명령어 집합과 호환 |

### 2.3.1 64-Bit Operation Modes (IA-32e)

- **Compatibility Mode**: 기존 16비트·32비트 애플리케이션을 재컴파일 없이 실행. 단, **16비트 Windows·DOS 애플리케이션은 지원하지 않음**
- **64-Bit Mode**: 64비트 명령어 피연산자와 64비트 선형 주소 공간 사용. 네이티브 64비트 앱용

### 2.3.2 Basic 64-Bit Execution Environment

#### 32-bit vs 64-bit 비교

| Feature | 32-bit | 64-bit |
|---|---|---|
| Address Size | 32 bits | 48 bits(실제) / 64 bits(이론) |
| General Purpose Registers | 8개 | 16개 |
| Floating-Point Registers | 80비트 8개 | 80비트 8개 |
| Status Flags Register | 32-bit (EFLAGS) | 64-bit (RFLAGS) |
| Instruction Pointer | 32-bit (EIP) | 64-bit (RIP) |
| MMX Registers | 64비트 8개 | 64비트 8개 |
| XMM Registers | 128비트 8개 | 128비트 16개 |

#### 범용 레지스터와 REX Prefix

- **Operand Sizes**: 8 / 16 / 32 / 64비트 피연산자 접근 가능
- **64-bit Mode**: 기본 피연산자 크기는 32비트, 기본 8개 레지스터 사용
- **REX Prefix**: 64비트 피연산자를 추가하고 사용 가능 레지스터를 16개로 확장
- **Numbered Registers**: 기존 32비트 레지스터에 더해 **R8 ~ R15** 추가

**Table 2-1. Operand Sizes in 64-Bit Mode When REX Is Enabled**

| Operand Size | Available Registers |
|---|---|
| 8 bits | AL, BL, CL, DL, DIL, SIL, BPL, SPL, R8L~R15L |
| 16 bits | AX, BX, CX, DX, DI, SI, BP, SP, R8W~R15W |
| 32 bits | EAX, EBX, ECX, EDX, EDI, ESI, EBP, ESP, R8D~R15D |
| 64 bits | RAX, RBX, RCX, RDX, RDI, RSI, RBP, RSP, R8~R15 |

---

## 2.4 Components of a Typical x86 Computer

### 구성 요소 개요

| 구성 | 설명 |
|---|---|
| Motherboard Configuration | 메인보드의 물리적 배치와 부품 |
| Memory | 시스템의 저장·검색 메커니즘 |
| I/O Ports | 외부 장치 연결 인터페이스 |
| Device Interfaces | 장치 간 통신 표준 |
| Assembly Language I/O | 하드웨어와 상호작용하는 프로그래밍 기법 |

### 2.4.1 Motherboard

**핵심 부품**

| 부품 | 역할 |
|---|---|
| CPU Socket | 프로세서 장착 |
| Chipset | CPU 동작 보조 |
| Main Memory (Memory Slots) | 데이터 고속 접근·메모리 보드 장착 |
| BIOS Chip | 시스템 소프트웨어 보관 |
| CMOS RAM | 시스템 설정 저장 (배터리 백업) |
| Mass-Storage Connectors | 저장 장치 연결 |
| USB Connectors | 외부 장치 연결 |
| Keyboard / Mouse Ports | 입력 장치 연결 |
| PCI Bus Connectors | 확장 카드 연결 |
| Expansion Slots | 추가 하드웨어 장착 |
| Power Supply Connectors | 전원 공급 |
| Bus | 메인보드 상 구성요소 연결 |

**선택적(Optional) 구성요소**: Sound Processor, Device Connectors, Network Adapter, AGP Bus Connector(고속 비디오 카드)

**프로세서를 보조하는 구성요소**

| 구성 | 역할 |
|---|---|
| Floating-Point Unit | 부동소수점·확장 정수 연산 처리 |
| Clock Generator | CPU와 구성요소 동기화 |
| Interrupt Controller | 하드웨어 장치의 외부 인터럽트 관리 |
| Interval Timer | 시스템 날짜·시계 갱신, 메모리 리프레시 |
| Parallel Port | 컴퓨터와 데이터 송수신 |

**버스 아키텍처**

- **PCI Bus**: CPU와 여러 시스템 장치를 효율적으로 연결
- **PCI Express Bus**: 고속 직렬 연결 제공
- **Graphics Controllers**: 그래픽 처리를 위한 고속 데이터 전송 지원

**Intel P965 Express Chipset** (Figure 2-6)

- **MCH (Memory Controller Hub)**: CPU(8.5 GB/s), DDR2 메모리(12.8 GB/s), PCI Express x16 Graphics(8 GB/s) 연결
- **ICH8 (I/O Controller Hub)**: USB 2.0 10포트, PCI Express x1 6개, Serial ATA 6포트(각 3 Gb/s), GbE LAN, HD Audio, BIOS/Firmware(LPC or SPI) 연결
- MCH ↔ ICH8 간 DMI 2 GB/s
- 부가 기술: Intel Fast Memory Access, Intel Quiet System Technology, Intel Matrix Storage Technology

### 2.4.2 Memory Types

| 종류 | 특징 |
|---|---|
| **ROM** | 영구적으로 기록되어 지울 수 없는 메모리 |
| **EPROM** | 자외선(UV)으로 지우고 재프로그래밍 가능 |
| **DRAM** | 주기적 리프레시가 필요한 주 메모리 |
| **SRAM** | 리프레시가 필요 없는 고속 캐시 메모리 |
| **VRAM** | 비디오 데이터 보관, 화면의 연속적 리프레시 지원 |
| **CMOS RAM** | 시스템 설정 정보 저장, 배터리 백업 |

---

## 2.5 Input–Output System

### 2.5.1 Levels of I/O Access

```
Level 3 : Application program   (응용 프로그램)
              ↓
Level 2 : OS function           (고수준 API)
              ↓
Level 1 : BIOS function         (장치별 제어)
              ↓
Level 0 : Hardware              (직접 제어)
```

| 계층 | 특징 |
|---|---|
| **High-Level Language Functions** | 이식성 높은 I/O 함수 |
| **Operating System (API)** | API를 통한 고수준 연산 |
| **BIOS** | 하드웨어와 직접 통신 |
| **Hardware Port Control** | 특정 장치에 대한 절대적 제어 |

어셈블리 프로그램은 Level 0~3 **모든 계층에 직접 접근 가능**하다는 점이 강점이다.

| ASM 접근 수준 | 내용 |
|---|---|
| Level 3 — Library Functions | 일반적인 텍스트·파일 I/O |
| Level 2 — OS Functions | 일반적인 텍스트·파일 I/O |
| Level 1 — BIOS Functions | 장치별 제어 기능 |
| Level 0 — Hardware Port Control | 특정 장치의 절대적 제어 |

> 트레이드오프: **상위 계층 = 이식성↑ 제어력↓ / 하위 계층 = 제어력↑ 이식성↓**

### 예제: 화면에 문자열 출력하기

1. **Application Call** — 응용 프로그램이 라이브러리 함수를 호출한다.
2. **Library Function** — 문자열 포인터를 OS에 전달한다.
3. **OS Function** — BIOS 서브루틴을 호출해 문자 표시를 처리한다.
4. **BIOS Subroutine** — 문자를 시스템 폰트로 매핑해 비디오 컨트롤러로 전달한다.
5. **Video Controller** — 화면에 픽셀을 표시하는 신호를 생성한다.

### Device Driver

- 처리 흐름: **OS Request → Driver Receives Request → Executes Firmware Code → Reads Device Data → Data Delivered to OS**
- 설치 방식
  - **Install Before Attachment**: 하드웨어 연결 전에 드라이버 설치 → 즉시 인식
  - **Install After Attachment**: 장치 연결 후 설치 → OS가 자동 식별·설치
- Figure 2-1 ~ 2-8, Table 2-1 기준으로 정리

