;****************************************************************************************************************************
; Your name as author: Solivan Hiep
; Your section number: CPSC 240-3
; Today’s date: March 10, 2025
; Your preferred return email address: hiepsolivan@csu.fullerton.edu
;****************************************************************************************************************************

; Declarations
extern printf

global output_array

; Declare initialized arrays
segment .data
outputted_number db "%.9f   ", 0
ending_new_line db "", 10, 0

; Declare uninitialized arrays
segment .bss

align 64
backup_storage_area resb 832

segment .text
output_array:

; Backup the GPRs
push rbp
mov rbp, rsp
push rbx
push rcx
push rdx
push rdi
push rsi
push r8
push r9
push r10
push r11
push r12
push r13
push r14
push r15
pushf

; Backup other registers/sse registers
mov rax, 7
mov rdx, 0
xsave [backup_storage_area]

; Move the arguments received (the address to the array + array size) into non-volatile registers r12 and r13 to affect the actual array + future use in logic
mov r12, rdi ; The array
mov r13, rsi ; The array's size

; Maintain a counter for the array using the non-volatile register r14 to ensure no over-indexing
xor r14, r14 ; Comparing r14 to itself via xor sets r14 to 0

; Kick off the main loop to print out each element in the array
top_of_loop:

; Check for over-indexing by determining if r14 >= r13. If so, exit. Otherwise, continue
cmp r14, r13
jge out_of_loop

; Print out the element in the array [r12] at the counter [r14]
mov rax, 1
mov rdi, outputted_number
movsd xmm0, [r12 + r14 * 8]
call printf

; Increment the counter [r14] by 1 and jump back to the top of the loop
inc r14
jmp top_of_loop
; End of main loop to print out each element in the array

; Exit the main loop and complete the program:
out_of_loop:

; Print out a new line for nicer formatting
mov rax, 0
mov rdi, ending_new_line
call printf

; Restore the values to non-GPRs/sse registers
mov rax, 7
mov rdx, 0
xrstor [backup_storage_area]

; Restore the GPRs
popf
pop r15
pop r14
pop r13
pop r12
pop r11
pop r10
pop r9
pop r8
pop rsi
pop rdi
pop rdx
pop rcx
pop rbx
pop rbp   ;Restore rbp to the base of the activation record of the caller program
ret
;End of the function output_array ====================================================================
