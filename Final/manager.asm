;Your name : Solivan Hiep
;Your cwid : 884845876
;Your section number : 240 - 3
;Your email address : hiepsolivan @csu.fullerton.edu
;Today’s date : 4 / 23 / 2025
;Identifier : Final program.

; Declarations
%include "utilities.inc"
global manager
extern getqword

extern printf
extern scanf

; Declare initialized arrays
segment .data
num_add_msg db "The address of -17 is %lx", 10, 0
enter_add_prompt db "Please enter an address in hex:  ", 0
int_at_add_msg db "The integer at that address is %lx", 10, 0
finished_msg db "Function getqword has finished. A number will be returned to the driver.", 10, 10, 0

string_format db "%s", 0
hex_format db "%lx", 0
number dq -17

; Declare uninitialized arrays
segment .bss
align 64
backup_storage_area resb 832

inputted_add resq 1

segment .text
manager:

; Call the macro that backs up the GPRs
backup_gprs

; Call the macro that backs up the non-GPRs/SSEs into the backup_storage_area
backup_non_gprs backup_storage_area

; Print out the current address of initialized number (-17)
mov rax, 0
mov rdi, num_add_msg
mov rsi, number ; Note lack of []
call printf

; Print out the prompt for the user to input a hex address
mov rax, 0
mov rdi, string_format
mov rsi, enter_add_prompt
call printf

; User inputs hex address via scanf
mov rax, 0
mov rdi, hex_format
mov rsi, inputted_add
call scanf

; Call getqword [long getqword(unsigned long add)] to obtain the a copy of the integer at a given address
mov rax, 0
mov rdi, inputted_add
call getqword
mov r12, rax

; Print out the integer at the inputted address
mov rax, 0
mov rdi, int_at_add_msg
mov rsi, r12
call printf

; Print out a message stating that the function is completed
mov rax, 0
mov rdi, string_format
mov rsi, finished_msg
call printf

; Call the macro that restores the non-GPRs/SSEs from the backup_storage_area
restore_non_gprs backup_storage_area

; Send back the integer to the caller
mov rax, r12

; Call the macro that restores the GPRs
restore_gprs

ret
