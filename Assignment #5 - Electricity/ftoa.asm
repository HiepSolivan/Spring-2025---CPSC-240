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
;  File name: ftoa.asm
;  Language: X86-64
;  Development Platform: Windows 11 Enterprise Ver. 24H2. Intel(R) Core(TM) i3-8145U CPU @ 2.10GHz 2.30 GHz Processor. Running on Ubuntu 22.04.5 LTS.
;  Max page width: 189 columns
;  Assemble: nasm -f elf64 -l ftoa.lis -o ftoa.o ftoa.asm
;  Assemble (debug in GDB): nasm -f elf64 -gdwarf -l ftoa.lis -o ftoa.o ftoa.asm
;  Page width: 198 columns
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: char * ftoa(double num)
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;===== Begin code area ====================================================================================================================================================

; Declarations
%include "acdc.inc"
global ftoa

; Declare initialized arrays
segment .data
buffer db 0
ten dq 10.0
zero dq 0.0
debug dq "Debug"

; Declare uninitialized array
segment .bss
align 64
backup_storage_area resb 832

segment .text
ftoa:
; Call the macro to back up the GPRs
backup_gprs

; Call the macro to back up the non-GPRs/SSEs into backup_storage_area
backup_non_gprs backup_storage_area

; Move the received argument (the double to converted) into the non-volatile xmm12
movsd xmm12, xmm0

; Convert the float into a int and save it for later
cvtsd2si rax, xmm12
mov r12, rax

; Maintain a buffer for reading the characters
mov r14, buffer + 32

; Start the loop to convert the numbers on the integer portion of the double into ASCII chars working BACKWARDS
convert_int_portion:
; Reset the remainder stored in rdx
xor rdx, rdx

; Divide the int (rax) by 10 each iteration to obtain one place value via the remainder stored in rdx
mov r15, 10
idiv r15 ; div will automatically divide rax

; Add the extracted int to '0' to obtain the ASCII character then insert it into the string
add dl, '0' ; dl is the 8-bit register of rdx [the remainder]
dec r14
mov [r14], dl

; Check if we are finished with the integer portion by checking if rax != 0 (We have no quotient). If so, jump. Otherwise, reset the loop
cmp rax, 0
jne convert_int_portion
jmp finish_int_portion
; End of convert_int_portion to convert the numbers on the integer portion of the double into ASCII chars working backwards

; Prepare to convert the decimal portion of the double
finish_int_portion:

; Place a decimal '.' into the string (r14)
dec r14
mov byte[r14], '.'

; Convert the integer portion back into a float and subtract it from the original to obtain only the decimal portion
cvtsi2sd xmm13, r12
subsd xmm12, xmm13

; Maintain a counter for how many decimal places to display
mov r15, 7

; Start the loop to convert the numbers on the decimal side of the double into ASCII chars working FORWARDS
convert_dec_portion:
; Multiply the fractional part of the float by 10 to obtain a place value
movsd xmm1, [ten]
mulsd xmm12, xmm1

; Convert the float into an int to obtain the place value, then insert it into the string (r14) by adding '0' to it
cvtsd2si rax, xmm12
add al, '0'
dec r14
mov [r14], al

; Convert the int back into a float and subtract it from xmm12 so that only the decimal portion remains
cvtsi2sd xmm2, rax
subsd xmm12, xmm2

; Check if there are any decimals remaining. If so, reset the loop, otherwise, prepare to return.
dec r15
cmp r15, 0
jne convert_dec_portion

; Call the macro to restore the non-GPRs/SSEs from backup_storage_area
restore_non_gprs backup_storage_area

; Send back the resulting string back to the caller
mov rax, r14

; Call the macro to restore the GPRs
restore_gprs

ret
