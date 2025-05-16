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
;  File name: atof.asm
;  Language: X86-64
;  Development Platform: Windows 11 Enterprise Ver. 24H2. Intel(R) Core(TM) i3-8145U CPU @ 2.10GHz 2.30 GHz Processor. Running on Ubuntu 22.04.5 LTS.
;  Max page width: 189 columns
;  Assemble: nasm -f elf64 -l atof.lis -o atof.o atof.asm
;  Assemble (debug in GDB): nasm -f elf64 -gdwarf -l atof.lis -o atof.o atof.asm
;  Page width: 198 columns
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: double atof(char string[])
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;===== Begin code area ====================================================================================================================================================

; Declarations
%include "acdc.inc"
global atof

; Declare initialized arrays
segment .data
negative_mask dq 0x8000000000000000

; Declare uninitialized array
segment .bss
align 64
backup_storage_area resb 832

segment .text
atof:
; Call the macro to back up the GPRs
backup_gprs

; Call the macro to back up the non-GPRs/SSEs into backup_storage_area
backup_non_gprs backup_storage_area

; Move the received arguments (the ASCII string) into the non-volatile register r12.
mov r12, rdi

; Maintain a counter to use to find the decimal point
xor r13, r13

; Start the loop that checks each ASCII char in search of a decimal point (Note: We already know there is only 1 decimal point from isfloat)
find_decimal_point:

; Compare the current ASCII char at the counter r13 with '.' to determine the index of the decimal place. If '.' is found, jump. Otherwise, continue.
cmp byte[r12 + r13], '.'
je found_decimal_point
inc r13
jmp find_decimal_point

; End of find_decimal_point to iterate through the ASCII string to find the index of the decimal point

; Prepares to convert the integer portion of the ASCII string
found_decimal_point:

; Maintain registers to use as the sum for the integer portion, marker for the place value, a copy of the index of the decimal point, and a flag for the negative sign
xor r14, r14
mov r15, 1
mov r11, r13
xor r10, r10

; Decrement the index of the decimal place as we are only converting the integer portion
dec r11

; Start the loop to iterate through the integer portion of the ASCII string for conversion BACKWARDS
convert_int_portion:

; Check if we have reached a sign. If so either turn on the negative sign flag (r10) or jump. Otherwise, continue.
mov al, byte[r12 + r11]
cmp al, '+'
je finish_int_portion
cmp al, '-'
je int_negative_sign

; Convert the current ASCII char by subtracting the ASCII code for '0' to the current character to yield the integer value
sub al, '0'

; Multiply the extracted integer value by the marker value (r15), increment the marker value by 10, and add it to our sum (r14)
imul rax, r15 ; We are using a 64-bit register (rax) rather than the 8-bit register (al) as we have yielded an int from the previous instruction
imul r15, 10
add r14, rax

; Decrement the index then check for over-indexing by checking if r11 < 0. If so, jump. Otherwise, reset the loop
dec r11
cmp r11, 0
jl finish_int_portion
jmp convert_int_portion

; End of convert_int_portion to iterate through the integer portion of the ASCII string for backwards conversion

; Jump here if we found a negative sign to set on the negative sign flag (r10)
int_negative_sign:

; Set on the negative sign flag by turning it to 1 then proceed to finish_int_portion
mov r10, 1
jmp finish_int_portion

; End of int_negative_sign to set on the negative sign flag

; Prepare to convert the decimal portion of the ASCII string
finish_int_portion:

; Move 10.0 into xmm11 by first moving it into rax then converting it
mov rax, 10
cvtsi2sd xmm11, rax

; Maintain registers for use as a decimal sum and a marker for place value
xorpd xmm12, xmm12
movsd xmm13, xmm11

; Increment the index of the decimal place as we are only converting the integer portion
inc r13

; Start the loop to iterate through the decimal portion of the ASCII string for conversion FORWARDS
convert_dec_portion:

; Convert the ASCII char by subtracting the ASCII code for '0' to the current character to yield the integer value
mov al, byte[r12 + r13]
sub al, '0'

; Convert the extracted integer value into a float, divide it by the place value (xmm13), then add it to our sum (xmm12)
cvtsi2sd xmm14, rax
divsd xmm14, xmm13
addsd xmm14, xmm12

; Increment the index of the decimal place (r13) by 1 and the place value (xmm13) by 10
inc r13
mulsd xmm13, xmm11

; Check if we have reached a null terminator character by checking if the current character = 0. If so, continue to finalize the float. Otherwise, reset the loop
cmp byte[r12 + r13], 0
je convert_dec_portion

; From here, finalize the float. Start by adding the integer (r14) and decimal (xmm14) portions together.
cvtsi2sd xmm10, r14
addsd xmm14, xmm10

; Check if the negative flag (r10) was turned on. If so, continue. Otherwise, jump to return.
cmp r10, 1
je return

; Convert the float into a negative by flipping on its first bit using a mask
movsd xmm1, [negative_mask]
xorpd xmm14, xmm1

; End of convert_dec_portion to convert the decimal portion of the ASCII string and finalize conversion into a float

; Jump here to return to the caller
return:

; Prepare to send back the generated float by pushing it to the stack
push qword 0
movsd [rsp], xmm14

; Call the macro to restore the non-GPRs/SSEs from backup_storage_area
restore_non_gprs backup_storage_area

; Send back the generated float
movsd xmm0, [rsp]
pop rax

; Call the macro to restore the GPRs
restore_gprs

ret
