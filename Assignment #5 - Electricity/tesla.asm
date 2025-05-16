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
;  File name: tesla.asm
;  Language: X86-64
;  Development Platform: Windows 11 Enterprise Ver. 24H2. Intel(R) Core(TM) i3-8145U CPU @ 2.10GHz 2.30 GHz Processor. Running on Ubuntu 22.04.5 LTS.
;  Max page width: 189 columns
;  Assemble: nasm -f elf64 -l tesla.lis -o tesla.o tesla.asm
;  Assemble (debug in GDB): nasm -f elf64 -gdwarf -l tesla.lis -o tesla.o tesla.asm
;  Page width: 198 columns
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: double tesla(double array[])
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;===== Begin code area ====================================================================================================================================================

; Declarations
%include "acdc.inc"
global tesla

; Declare initialized arrays
segment .data
one dq 1.0

; Declare uninitialized arrays
segment .bss
align 64
backup_storage_area resb 832

segment .text
tesla:
; Call the macro to back up the GPRs
backup_gprs

; Call the macro to back up the non-GPRs/SSEs into backup_storage_area
backup_non_gprs backup_storage_area

; Move the arguments received (the array of resistances) and place them into the non-volatile register r12
mov r12, rdi

; Move each resistance in the array into non-volatile registers xmm10, xmm11, and xmm12
movsd xmm10, [r12 + 0 * 8]
movsd xmm11, [r12 + 1 * 8]
movsd xmm12, [r12 + 2 * 8]

; Find the reciprocal of each resistance then find their sums ((1/R1) + ((1/R2) + (1/R3))
movsd xmm1, [one]
movsd xmm2, xmm1
divsd xmm2, xmm10 ; 1/R1
movsd xmm3, xmm1
divsd xmm3, xmm11 ; 1/R2
movsd xmm4, xmm1
divsd xmm4, xmm12 ; 1/R3
addsd xmm2, xmm3
addsd xmm2, xmm4

; Find the reciprocal of the reciprocals to find the total resistance 1/((1/R1) + ((1/R2) + (1/R3))
divsd xmm1, xmm2
movsd xmm13, xmm1

; Prepare to send back the total resistance by pushing it to the stack
push qword 0
movsd [rsp], xmm13

; Call the macro to restore the non-GPRs/SSEs from backup_storage_area
restore_non_gprs backup_storage_area

; Send back the total resistance and reset the stack
movsd xmm0, [rsp]
pop rax

; Call the macro to restore the GPRs
restore_gprs

ret
