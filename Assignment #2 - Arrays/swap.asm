;****************************************************************************************************************************
; Program name: "Arrays".  The intent of this program is to sort, print, and compute the mean of an array of float numbers   *
; in which the array was constructed using user input. The educational purpose is to gain experience programming with arrays *                                                              *
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
;  Program name: Arrays
;  Programming languages: Six modules in X86, one module in C, one module in C++, and one in bash
;  Date program began: 2025-Feb-09
;  Date of last update: 2025-Feb-20
;  Files in the program: manager.asm, input_array.asm, isfloat.asm, output_array.asm, sum.asm, swap.asm, sort.c, main.c, r.sh
;
;Purpose
;  The intent of this program is to sort, print, and compute the mean of an array of float numbers
;  in which the array was constructed using user input.
;  The educational purpose is to gain experience programming with arrays.
;
;This file
;  File name: swap.asm
;  Language: X86-64
;  Max page width: 172 columns
;  Assemble: nasm -f elf64 -l swap.lis -o swap.o swap.asm
;  Page width: 172 columns
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: swap(double * float_1, double * float_2)
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;===== Begin code area ====================================================================================================================================================

; Declarations
global swap

; Declare initialized arrays
segment .data

; Declare uninitialized arrays
segment .bss
align 64
backup_storage_area resb 832

segment .text
swap:

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

; Place the dereferenced values of the two received arguments into temporary locations. Then move into opposing registers to swap
mov rax, [rdi]
mov rdx, [rsi]
mov [rdi], rdx
mov [rsi], rax

; Restore the values to non-GPRs/sse registers
mov rax, 7
mov rdx, 0
xrstor [backup_storage_area]

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
pop rbp   ;Restore rbp to the base of the activation record of the caller program
ret
;End of the function swap ====================================================================
