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
;  File name: syscall_strlen.asm
;  Language: X86-64
;  Development Platform: Windows 11 Enterprise Ver. 24H2. Intel(R) Core(TM) i3-8145U CPU @ 2.10GHz 2.30 GHz Processor. Running on Ubuntu 22.04.5 LTS.
;  Max page width: 189 columns
;  Assemble: nasm -f elf64 -l syscall_strlen.lis -o syscall_strlen.o syscall_strlen.asm
;  Assemble (debug in GDB): nasm -f elf64 -gdwarf -l syscall_strlen.lis -o syscall_strlen.o syscall_strlen.asm
;  Page width: 198 columns
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: long syscall_strlen(char string[])
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;===== Begin code area ====================================================================================================================================================

; Declarations
%include "acdc.inc"
global syscall_strlen

; Declare initialized arrays
segment .data

; Declare uninitialized arrays
segment .bss
align 64
backup_storage_area resb 832

segment .text
syscall_strlen:
; Call the macro to back up the GPRs
backup_gprs

; Call the macro to back up the non-GPRs/SSEs into backup_storage_area
backup_non_gprs backup_storage_area

; Move the argument received (the address to the string) into non-volatile registers r12
mov r12, rdi

; Maintain a counter for each character
xor r8, r8

; Load the effective address of the string to use as an index
lea r9, [r12]

; Kick of the loop to get the string length
count_chars:
; Check for the null character. If at null char, jump. Otherwise, continue
cmp byte [r9], 0
je count_done

; Increment both the character count and index then reset the loop
inc r8
inc r9
jmp count_chars
; End of count_chars to obtain the string length

; Jump here once you are finished counting characters
count_done:

; Call the macro to restore the non-GPRs/SSEs from backup_storage_area
restore_non_gprs backup_storage_area

; Send back the count back to caller
mov rax, r8

; Call the macro to restore the GPRs
restore_gprs

ret
