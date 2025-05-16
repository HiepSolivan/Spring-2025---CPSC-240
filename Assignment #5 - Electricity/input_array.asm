;****************************************************************************************************************************
; Program name: "Electricity".  The intent of this program is to compute missing electrical information from            *
; user-inputted information. The educational purpose is to provide me with experience in pure assembly programming.          *                                                         *
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
;  Program name: Electricity
;  Programming languages: Ten modules in X86, one in bash
;  Date program began: 2025-Apr-04
;  Date of last update: 2025-Apr-12
;  Files in the program: faraday.asm, edison.asm, input_array.asm, atof.asm, isfloat.asm tesla.asm, ftoa.asm, syscall_fgets.asm, syscall_strlen.asm acdc.inc, r.sh
;
;Purpose
;  The intent of this program is to compute missing electrical information from
;  user-inputted information. The educational purpose is to provide me with experience in pure assembly programming.
;
;This file
;  File name: input_array.asm
;  Language: X86-64
;  Development Platform: Windows 11 Enterprise Ver. 24H2. Intel(R) Core(TM) i3-8145U CPU @ 2.10GHz 2.30 GHz Processor. Running on Ubuntu 22.04.5 LTS.
;  Max page width: 189 columns
;  Assemble: nasm -f elf64 -l input_array.lis -o input_array.o input_array.asm
;  Assemble (debug in GDB): nasm -f elf64 -gdwarf -l input_array.lis -o input_array.o input_array.asm
;  Page width: 198 columns
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: void input_array(double array[], long capacity)
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;===== Begin code area ====================================================================================================================================================

; Declarations
%include "acdc.inc"
global input_array
extern atof
extern isfloat
extern syscall_fgets

SYS_WRITE equ 1
STDOUT equ 1

; Declare initialized arrays
segment .data
debug db "Debug"
fail_msg db "The last input was invalid and not entered into the array.  Try again."

; Declare uninitialized arrats
segment .bss
align 64
backup_storage_area resb 832

segment .text
input_array:
; Call the macro to back up the GPRs
backup_gprs

; Call the macro to back up the non-GPRs/SSEs into backup_storage_area
backup_non_gprs backup_storage_area

; Move the arguments received (the address to the array + array capacity) into non-volatile registers r12 and r13 to affect the actual array + future use in logic
mov r12, rdi ; The array
mov r13, rsi ; The array's capacity

; Maintain a counter to prevent over-indexing
xor r14, r14

; Kick of the main loop to ask for user input to insert into an array
top_of_loop:

; Check for over-indexing by determining if r14 >= r13. If so, exit. Otherwise, continue
cmp r14, r13
jge out_of_loop

; Prompt for user input of the array through syscall_fgets [void syscall_fgets(char string[])] to place input on the stack
push qword 0
push qword 0
mov rax, 0
mov rdi, rsp
call syscall_fgets

; Validate the most recent input by calling isfloat [bool isfloat(char input[])]
mov rax, 0
mov rdi, rsp
call isfloat
cmp rax, 0 ; If isfloat returned a 0, then we did not get a float
je try_again

; Now that we have a valid float, call atof (double atof(char string[])) to convert the ASCII string into a flaot
mov rax, 0
mov rdi, rsp
call atof ; Stores float in xmm0

; Now that we are done with the stack, pop it.
pop rax
pop rax

; Insert the user-inputted float into the array [r12] at the counter [r14]
movsd [r12 + r14 * 8], xmm0

; Increment the counter and reset the loop if all goes well.
inc r14
jmp top_of_loop

; Jump here if you did not receive a float
try_again:

; Print out the message explaining that the user did not input a float and should try again
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, fail_msg
mov rdx, 74
syscall

; Pop the failed input to avoid segmentation faults then jump back to the main loop
pop rax
pop rax
jmp top_of_loop
; End of try_again to pop failed input and reset the main loop

; Exit the main loop and complete the program
out_of_loop:

; Call the macro to restore the non-GPRs/SSEs from backup_storage_area
restore_non_gprs backup_storage_area

; Call the macro to restore the GPRs
restore_gprs

ret
