# 0910 과제 - Chapter 2 Review Questions

1. In 32-bit mode, aside from the stack pointer (ESP), what other register points to variables on the stack?

함수의 매개변수와 지역 변수를 [EBP+8], [EBP-4] 처럼 고정된 기준점으로 참조해야 하기 때문이다.
→ EBP (Base Pointer)

2. Name at least four CPU status flags.

연산 결과의 상태를 다음 분기 판단에 써야 하므로 여러 플래그가 존재한다.
→ Carry(CF), Overflow(OF), Sign(SF), Zero(ZF) (그 외 Auxiliary Carry, Parity)

3. Which flag is set when the result of an unsigned arithmetic operation is too large to fit into the destination?

부호 없는 값이 목적지 크기를 넘어 자리올림이 발생한 경우다.
→ Carry flag (CF)

4. Which flag is set when the result of a signed arithmetic operation is either too large or too small to fit into the destination?

부호 있는 값은 표현 범위의 위·아래 양쪽으로 벗어날 수 있어 별도 플래그가 필요하다.
→ Overflow flag (OF)

5. (True/False): When a register operand size is 32 bits and the REX prefix is used, the R8D register is available for programs to use.

REX prefix가 레지스터를 16개로 확장하고, 32비트 접근 시에는 D 접미사를 쓴다.
→ True

6. Which flag is set when an arithmetic or logical operation generates a negative result?

결과의 최상위 비트(부호 비트)가 1이면 음수로 판단한다.
→ Sign flag (SF)

7. Which part of the CPU performs floating-point arithmetic?

실수 연산은 정수 연산과 회로 구조가 달라 전담 유닛이 필요하다.
→ FPU (Floating-Point Unit)

8. On a 32-bit processor, how many bits are contained in each floating-point data register?

ST(0)~ST(7) 데이터 레지스터는 확장 정밀도를 위해 80비트로 설계되었다.
→ 80 bits

9. (True/False): The x86-64 instruction set is backward-compatible with the x86 instruction set.

기존 소프트웨어를 그대로 쓸 수 있어야 시장에서 받아들여지기 때문이다.
→ True

10. (True/False): In current 64-bit chip implementations, all 64 bits are used for addressing.

64비트 전부를 구현할 필요가 없고 비용만 커진다. 실제 물리 주소는 48비트(256TB)다.
→ False

11. (True/False): The Itanium instruction set is completely different from the x86 instruction set.

Itanium은 x86 확장이 아니라 완전히 새로 설계된 아키텍처다.
→ True

12. (True/False): Static RAM is usually less expensive than dynamic RAM.

SRAM은 셀당 트랜지스터가 많아 집적도가 낮고 단가가 높다. 그래서 캐시처럼 소량만 쓴다.
→ False (SRAM이 더 비싸다)

13. (True/False): The 64-bit RDI register is available when the REX prefix is used.

REX prefix가 64비트 피연산자를 활성화하면 RAXRSP, R8R15를 쓸 수 있다.
→ True

14. (True/False): In native 64-bit mode, you can use 16-bit real mode, but not the virtual-8086 mode.

네이티브 64비트 모드에서는 real mode와 virtual-8086 모드 둘 다 사용할 수 없다.
→ False

15. (True/False): The x86-64 processors have 4 more general-purpose registers than the x86 processors.

8개에서 16개로 늘어났으므로 4개가 아니라 8개가 더 많다.
→ False

16. (True/False): The 64-bit version of Microsoft Windows does not support virtual-8086 mode.

그래서 64비트 Windows에서 오래된 16비트 DOS 프로그램이 실행되지 않는다.
→ True

17. (True/False): DRAM can only be erased using ultraviolet light.

UV로 지우는 것은 EPROM이다. DRAM은 전원이 끊기면 내용이 사라지는 휘발성 메모리다.
→ False

18. (True/False): In 64-bit mode, you can use up to eight floating-point registers.

FPU 레지스터는 32비트와 64비트 모드 모두 ST(0)~ST(7) 8개로 동일하다.
→ True

19. (True/False): A bus is a plastic cable that is attached to the motherboard at both ends, but does not sit directly on the motherboard.

버스는 케이블이 아니라 메인보드에 인쇄된 병렬 배선(전도체 묶음)이다.
→ False

20. (True/False): CMOS RAM is the same as static RAM, meaning that it holds its value without any extra power or refresh cycles.

CMOS RAM은 시스템 설정을 유지하려고 별도의 배터리 전원을 쓴다.
→ False

21. (True/False): PCI connectors are used for graphics cards and sound cards.

PCI는 확장 카드를 연결하는 범용 버스 규격이다.
→ True

22. (True/False): The 8259A is a controller that handles external interrupts from hardware devices.

키보드·타이머 등 장치가 보내는 인터럽트를 정리해 CPU에 전달하는 역할이다.
→ True (Programmable Interrupt Controller)

23. (True/False): The acronym PCI stands for programmable component interface.

PCI는 주변기기를 연결하는 상호접속 규격을 뜻한다.
→ False (Peripheral Component Interconnect)

24. (True/False): VRAM stands for virtual random access memory.

화면을 계속 갱신하기 위해 영상 데이터를 담는 메모리다.
→ False (Video RAM)

25. At which level(s) can an assembly language program manipulate input/output?

어셈블리는 계층 제약을 받지 않아 필요에 따라 어느 수준이든 선택할 수 있다.
→ 모든 수준. Level 3(라이브러리) / Level 2(OS 함수) / Level 1(BIOS 함수) / Level 0(하드웨어 포트 직접 제어)

26. Why do game programs often send their sound output directly to the sound card's hardware ports?

OS나 BIOS를 거치면 계층마다 지연이 생기고, 그 계층이 제공하지 않는 장치 고유 기능은 쓸 수 없다.
→ 속도를 높이고 사운드 카드의 특수 기능을 최대한 활용하기 위해서다. 대신 이식성이 떨어진다.
