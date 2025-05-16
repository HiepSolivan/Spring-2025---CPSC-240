;****************************************************************************************************************************
; Program name: "Execution Speed".  The academic objective is to learn how to utilize the clock.
; The application objective is to measure the average time require to perform one floating point addition: addsd xmm10,xmm11 *
; Copyright (C) 2025  Solivan Hiep                                                                                           *
; This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License  *
; version 3 as published by the Free Software Foundation.                                                                    *
; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied         *
; warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.     *
; A copy of the GNU General Public License v3 is available here:  <https://www.gnu.org/licenses/>.                           *
;****************************************************************************************************************************


;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**

;Author information
;  Author name: Solivan Hiep
;  Author email: hiepsolivan@csu.fullerton.edu
;  CWID: 8848458756
;  Class: CPSC 240-03 - Class Nbr 13604
;
;Program information
;  Program name: Execution Speed
;  Programming languages: Six modules in X86, two modules in C++, and one in bash
;  Date program began: 2025-Apr-21
;  Date of last update: 2025-Apr-25
;  Files in the program: manager.asm, input_array.asm, isfloat.asm, sum.asm, getfrequency.asm, utilities.inc, clock.cpp, r.sh
;
;Purpose
;  The academic objective is to learn how to utilize the clock.
;  The application objective is to measure the average time require to perform one floating point addition: addsd xmm10,xmm11
;
;This file
;  File name: input_array.asm
;  Language: X86-64
;  Max page width: 172 columns
;  Assemble: nasm -f elf64 -l input_array.lis -o input_array.o input_array.asm
;  Page width: 172 columns
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: void input_array(double array[], long capacity)
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;===== Begin code area ====================================================================================================================================================

; Declarations
extern atof
extern printf
extern scanf

extern isfloat
global input_array

; Declare initialized arrays
segment .data
invalid_input_msg db "    The last input was invalid and not entered into the array.  Try again.", 10, 0
capacity_reached_msg db "    The array has reached its capacity.  Exiting...", 10, 0

whitespace db "   ", 0
string_format db "%s", 0

; Declare uninitialized arrays
segment .bss
align 64
backup_storage_area resb 832

segment .text
input_array:

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

; Move the arguments received (the address to the array + array capacity) into non-volatile registers r12 and r13 to affect the actual array + future use in logic
mov r12, rdi ; The array
mov r13, rsi ; The array's capacity

; Maintain a counter for the array using the non-volatile register r14 to ensure no over-indexing
xor r14, r14 ; Comparing r14 to itself via xor sets r14 to 0

; Kick of the main loop to ask for user input to insert into an array
top_of_loop:

; Check for over-indexing by determining if r14 >= r13. If so, exit. Otherwise, continue
cmp r14, r13
jge capacity_full

; Print out leading whitespace before input for formatting
mov rax, 0
mov rdi, string_format
mov rsi, whitespace
call printf

; Prompt for user input for the array. The input is received as a STRING
push qword 0 ; Ensure scanf reads 64 bits
push qword 0
mov rax, 0
mov rdi, string_format
mov rsi, rsp
call scanf

; Check if scanf actually stored the value into the array [r12] by checking if the low of rax (eax) equals -1. If so, jump to scan_ended. Otherwise, continue.
cmp eax, -1 ; Note: This comparison ALSO checks if the user pressed CTRL + D
je scan_ended

; Validate the most recent input by calling isfloat [bool isfloat(char [] input)]
mov rdi, rsp
call isfloat
cmp rax, 0 ; If isfloat returned a 0, then we did not get a float
je try_again

; Now that we have a valid float, call atof [double atof (char str[])] to convert the array of ASCII chars into a float
mov rax, 0
mov rdi, rsp
call atof ; Stores the float into xmm0

; Pop the stack as we are now done with the user-inputted float
pop rax
pop rax

; Insert the user-inputted float into the array [r12] at the counter's [r14] current position
movsd [r12 + r14 * 8], xmm0

; Increment the counter by one and restart the main loop if everything goes well
inc r14
jmp top_of_loop
; End of the main loop to ask for user input to insert into the array

;; Jump here if the array is now full
capacity_full:

;; Print out a message telling the user the array is full
mov rax, 0
mov rdi, string_format
mov rsi, capacity_reached_msg
call printf

;; Exit the main loop
jmp out_of_loop
;; End of capacity_full to inform user the array is full

;; Jump here if scanf failed OR CTRL + D was pressed to end the main loop
scan_ended:

;; Pop what is currently on the stack (to avoid segmentation faults) then exit the loop
pop rax
pop rax
jmp out_of_loop
;; End of scan_ended to end the main loop if scanf failed OR CTRL + D was pressed

;; Jump here if you scanf did NOT receive a float to inform the user of invalid input and let them try again
try_again:

;; Print out a message for the user to try again
mov rax, 0
mov rdi, string_format
mov rsi, invalid_input_msg
call printf

;; Pop the failed input on the stack (to avoid segmentation faults) then jump back to the top of the main loop
pop rax
pop rax
jmp top_of_loop
;; End of try_again to inform the user of invalid input and let them try again

; Exit the main loop and complete the program
out_of_loop:

; Restore the values to non-GPRs/sse registers
mov rax, 7
mov rdx, 0
xrstor [backup_storage_area]

; Send back the array's size stored in r14
mov rax, r14

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
pop rbp
ret
