;****************************************************************************************************************************
; Program name: "Non-deterministic random numbers".  The intent of this program is to generate up to 100 random number using *
; the non-deterministic random number generator found inside of modern X86 microprocessors.                                  *
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
;  Program name: Non-deterministic Random Numbers
;  Programming languages: Five modules in X86, two modules in C++, and one in bash
;  Date program began: 2025-Mar-24
;  Date of last update: 2025-Mar-27
;  Files in the program: executive.asm, fill_random_array.asm, isnan.asm, normalize.asm, show_array.asm, main.cpp, sort.cpp, r.sh
;
;Purpose
;  The intent of this program is to generate up to 100 random numbers using
;  the non-deterministic random number generator found inside of modern X86 microprocessors.
;
;This file
;  File name: fill_random_array.asm
;  Language: X86-64
;  Development Platform: Windows 11 Enterprise Ver. 24H2. Intel(R) Core(TM) i3-8145U CPU @ 2.10GHz 2.30 GHz Processor. Running on Ubuntu 22.04.5 LTS.
;  Max page width: 172 columns
;  Assemble: nasm -f elf64 -l fill_random_array.lis -o fill_random_array.o fill_random_array.asm
;  Assemble (debug in GDB): nasm -f elf64 -gdwarf -l fill_random_array.lis -o fill_random_array.o fill_random_array.asm
;  Page width: 172 columns
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: void fill_random_array(double array [], int size)
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;===== Begin code area ====================================================================================================================================================

; Declarations
%include "utilities.inc"
extern isnan

global fill_random_array

; Declare initialized arrays
segment .data

; Declare uninitialized arrays
segment .bss
align 64
backup_storage_area resb 832

segment .text
fill_random_array:

; Call the macro to back up the GPRs
backup_gprs

; Call the macro to back up the non-GPRs + SSEs into backup_storage_area
backup_non_gprs backup_storage_area

; Move the arguments holding the array and its size into non-volatile GPRs r12 and r13 respectively
mov r12, rdi
mov r13, rsi

; Maintain a counter for to prevent over-indexing
xor r14, r14

; Start the loop of generating random numbers using rdrand and placing them into the array
start_generating:

; Check for over-indexing by checking if r14 >= r13. If so, exit. Otherwise, continue
cmp r14, r13
jge end_of_loop

; Generate a random via rdrand and store it into a GPR
rdrand r15

; Because we generated a IEEE number, we need to push it to the stack so an SSE can move it into the array
push r15
push r15
movsd xmm10, [rsp]
pop r15
pop r15

; Check if the generated IEEE number is a NaN by calling isnan [bool isnan(double number)]. If so, regenerate the number, otherwise put it into the array
mov rax, 1
movsd xmm0, xmm10
call isnan
cmp rax, 1
je start_generating
movsd [r12 + r14 * 8], xmm10

; Increment the counter [r14] and continue the loop
inc r14
jmp start_generating
; End of the main loop to generate numbers to place into the array

; Exit the main loop
end_of_loop:

; Call the macro to restore the non-GPRs + SSEs in backup_storage_area
restore_non_gprs backup_storage_area

; Call the macro to restore the GPRs
restore_gprs

ret
