;****************************************************************************************************************************
; Program name: "Huron's Triangle".  The intent of this program is to compute the area of any triangle where the lengths of the
; three sides is known using Huron's formula. The educational purpose is to reinforce my skill of using a few techniques from
; the past such as data validation and parameter passing and use macros in this program to hopefully understand how to use   *
; macros in other situations                                                                                                 *
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
;  Program name: Huron's Triangle
;  Programming languages: Five modules in X86, one module in C++, and one in bash
;  Date program began: 2025-Feb-24
;  Date of last update: 2025-Mar-05
;  Files in the program: manager.asm, istriangle.asm, isfloat.asm, huron.asm, triangle.inc, main.c, r.sh
;
;Purpose
;  The intent of this program is to compute the area of any triangle where the lengths of the
;  three sides is known using Huron's formula.
;  The educational purpose is to reinforce my skill of using a few techniques from the past such as data validation
;  and parameter passing as well as use macros in this program to hopefully understand how to use
;  macros in other situations
;
;This file
;  File name: huron.asm
;  Language: X86-64
;  Development Platform: Windows 11 Enterprise Ver. 24H2. Intel(R) Core(TM) i3-8145U CPU @ 2.10GHz 2.30 GHz Processor. Running on Ubuntu 22.04.5 LTS.
;  Max page width: 172 columns
;  Assemble: nasm -f elf64 -l huron.lis -o huron.o huron.asm
;  Assemble (debug in GDB): nasm -f elf64 -gdwarf -l huron.lis -o huron.o huron.asm
;  Page width: 172 columns
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: double huron(double array[])
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;===== Begin code area ====================================================================================================================================================

; Declarations
%include "triangle.inc"
extern sqrt
global huron

; Declare initialized arrays
segment .data
half dq 0.5

; Declare uninitialized arrays
segment .bss
align 64
backup_storage_area resb 832

segment .text
huron:
; Call the macro to back up the GPRs
backup_gprs

; Call the macro to back up the non-GPRs/SSEs into backup_storage_area
backup_non_gprs backup_storage_area

; Move the argument received (the array) into the non-volatile registers r12 for use in calculations
mov r12, rdi

; Move all the sides in the array into non-volatile registers xmm8, xmm9, and xmm10 for use in calculations
movsd xmm8, qword[r12 + 0 * 8] ; Corresponds to side 1 or 'a'
movsd xmm9, qword[r12 + 1 * 8] ; Corresponds to side 2 or 'b'
movsd xmm10, qword[r12 + 2 * 8] ; Corresponds to side 3 or 'c'

; Calculate the semi-perimeter 's' (0.5 * (a + b + c)) and store it into the non-volatile xmm11
movsd xmm11, xmm8
addsd xmm11, xmm9
addsd xmm11, xmm10
mulsd xmm11, [half]

; Calculate the product inside the root, s(s-a)(s-b)(s-c), and store it into the non-volatile xmm12
movsd xmm12, xmm11

movsd xmm1, xmm11
subsd xmm1, xmm8
mulsd xmm12, xmm1

movsd xmm2, xmm11
subsd xmm2, xmm9
mulsd xmm12, xmm2

movsd xmm3, xmm11
subsd xmm3, xmm10
mulsd xmm12, xmm3

; Find the square root of s(s-a)(s-b)(s-c) and store it in non-volatile xmm13
sqrtsd xmm13, xmm12

; Move the results of Huron's formula to the stack
mov rax, 0
push qword 0
movsd [rsp], xmm13

; Call the macro to restore the non-GPRs/SSEs from backup_storage_area
restore_non_gprs backup_storage_area

; Send back the results of Huron's formula
movsd xmm0, [rsp]
pop rax

; Call the macro to restore the GPRs
restore_gprs

ret
