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
;  The intent of this program is to generate up to 100 random number using
;  the non-deterministic random number generator found inside of modern X86 microprocessors.
;
;This file
;  File name: normalize_array.asm
;  Language: X86-64
;  Development Platform: Windows 11 Enterprise Ver. 24H2. Intel(R) Core(TM) i3-8145U CPU @ 2.10GHz 2.30 GHz Processor. Running on Ubuntu 22.04.5 LTS.
;  Max page width: 172 columns
;  Assemble: nasm -f elf64 -l normalize_array.lis -o normalize_array.o normalize_array.asm
;  Assemble (debug in GDB): nasm -f elf64 -gdwarf -l normalize_array.lis -o normalize_array.o normalize_array.asm
;  Page width: 172 columns
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: void normalize_array(double array [], int size)
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;===== Begin code area ====================================================================================================================================================

; Declarations
%include "utilities.inc"
global normalize_array

; Declare initialized arrays
segment .data

; Declare uninitialized arrays
segment .bss
align 64
backup_storage_area resb 832

segment .text
normalize_array:

; Call the macro to back up the GPRs
backup_gprs

; Call the macro to back up the non-GPRs + SSEs into backup_storage_area
backup_non_gprs backup_storage_area

; Move the arguments holding the array and its size into the non-volatile GPRs r12 and r13 respectively
mov r12, rdi
mov r13, rsi

; Maintain a counter to prevent over indexing
xor r14, r14

; Start the main loop of normalizing each item in the array
normalizing:

; Check for over indexing by checking id r14 >= r13. If so, exit. Otherwise continue
cmp r14, r13
jge end_of_loop

; To normalize a number to between 1.0 and 2.0, start by clearing the first 12 bits
mov r15, [r12 + r14 * 8]
shl r15, 12
shr r15, 12

; Ensure that the first 12 bits are 3FF by turning on required bits using the mask 0x3FF0000000000000
mov rax, 0x3FF0000000000000
or r15, rax

; Push the normalized number onto the stack so an SSE register can take it
push r15
movsd xmm10, [rsp]
pop r15

; Move the normalized number back into the array
movsd [r12 + r14 * 8], xmm10

; Increment and jump to the top of the loop
inc r14
jmp normalizing
; End of normalizing to normalize each item in the array

; Exit the main loop
end_of_loop:

; Call the macro to restore the non-GPRs + SSEs in backup_storage_area
restore_non_gprs backup_storage_area

; Call the macro to restore the GPRs
restore_gprs

ret
