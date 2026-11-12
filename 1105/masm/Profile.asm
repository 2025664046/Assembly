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
