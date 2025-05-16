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
;  File name: syscall_fgets.asm
;  Language: X86-64
;  Development Platform: Windows 11 Enterprise Ver. 24H2. Intel(R) Core(TM) i3-8145U CPU @ 2.10GHz 2.30 GHz Processor. Running on Ubuntu 22.04.5 LTS.
;  Max page width: 189 columns
;  Assemble: nasm -f elf64 -l syscall_fgets.lis -o syscall_fgets.o syscall_fgets.asm
;  Assemble (debug in GDB): nasm -f elf64 -gdwarf -l syscall_fgets.lis -o syscall_fgets.o syscall_fgets.asm
;  Page width: 198 columns
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: void syscall_fgets(char string[])
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;===== Begin code area ====================================================================================================================================================

; Declarations
%include "acdc.inc"
global syscall_fgets

SYS_READ equ 0
STDIN equ 0
NULL equ 0
LF equ 10

; Declare initialized arrays
segment .data

; Declare uninitialized arrays
segment .bss
align 64
backup_storage_area resb 832
chr resb 1

segment .text
syscall_fgets:
; Call the macro to back up the GPRs
backup_gprs

; Call the macro to back up the non-GPRs/SSEs into backup_storage_area
backup_non_gprs backup_storage_area

;  Move the argument received (the address to the string) into non-volatile registers r12
mov r12, rdi

; Maintain a counter to avoid over-indexing
xor r8, r8

; Set off the loop to read each character
read_chars:
; Obtain one character from the user
mov rax, SYS_READ
mov rdi, STDIN
lea rsi, byte[chr] ; Use lea (Load Effective Address) to get the address of the character to be read
mov rdx, 1 ; Read one character
syscall

; Obtain the character from syscall stored in al [the low of rax's low's low] and check if its '\n' [Line feed]. If so, jump out; otherwise, continue
mov al, byte[chr]
cmp al, LF
je read_done

; Increment the counter and compare it to the max string size. If the counter is greater or equal, reset the loop to stop placing chars in the buffer. Otherwise, continue
inc r8
cmp r8, 50
jge read_chars ; Doing this will force the above read_done jump as the buffer is now cleared

; Update the string at the index r8 and the address of the string
mov byte[r12], al
inc r12

; Reset the loop
jmp read_chars
; End of read_chars to read each character from user input

; Jump here once you are finished reading
read_done:

; Add a null terminator character to the end of the string
mov byte[r12], NULL

; Call the macro to restore the non-GPRs/SSEs from backup_storage_area
restore_non_gprs backup_storage_area

; Call the macro to restore the GPRs
restore_gprs

ret
