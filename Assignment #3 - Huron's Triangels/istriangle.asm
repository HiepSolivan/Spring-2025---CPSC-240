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
;  File name: istriangle.asm
;  Language: X86-64
;  Development Platform: Windows 11 Enterprise Ver. 24H2. Intel(R) Core(TM) i3-8145U CPU @ 2.10GHz 2.30 GHz Processor. Running on Ubuntu 22.04.5 LTS.
;  Max page width: 172 columns
;  Assemble: nasm -f elf64 -l istriangle.lis -o istriangle.o istriangle.asm
;  Assemble (debug in GDB): nasm -f elf64 -gdwarf -l manager.lis -o manager.o manager.asm
;  Page width: 172 columns
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: bool istriangle(double array[], long size)
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;===== Begin code area ====================================================================================================================================================

; Declarations
%include "triangle.inc"
global istriangle

true equ 1
false equ 0

; Declare initialized arrays
segment .data

; Declare uninitialized arrays
segment .bss
align 64
backup_storage_area resb 832

segment .text
istriangle:

; Call the macro to back-up the GPRs
backup_gprs

; Call the macro to back-up the non-GPRs/SSEs into backup_storage_area
backup_non_gprs backup_storage_area

; Move the arguments received (the address to the array + the array's size) into the non-volatile registers r12 and 13 for sustained use in logic
mov r12, rdi
mov r13, rsi

; Check if there are only three sides in the array. If so, continue. If not, the sides do not make a valid triangle.
cmp r13, 3
jne invalid_triangle

; Maintain a counter in r14 to prevent over-indexing
xor r14, r14 ; Comparing r14 to itself sets r14 to 0

; Start the loop of checking the triangle's sides to see if they are all positive
positive_sides:

; Check for over-indexing by determining if r14 >= r13. If so, exit with a valid triangle. Otherwise, continue.
cmp r14, r13
jge valid_sides ; The triangle's is valid because it passed the previous iteration of the 3rd side

; Get the side in the array [r12] at the counter [r14] and compare it to 0. If the side is <= 0, invalid triangle. Otherwise, continue looping
cmp qword[r12 + r14 * 8], 0
jle invalid_triangle

; Increment the counter by one and restart the main loop if everything goes well
inc r14
jmp positive_sides
; End of main loop of checking the triangle's sides to see if they are all positive

; Start checking the triangle's sides to see if they form a valid triangle (i.e the sum of any two sides is > the third)
valid_sides:

; Check if side 1 + side 2 > side 3
check_two_sides_greater r12, 0, 1, 2
jbe invalid_triangle ; Here, we use jbe over jle because we are working with IEEE floats

; Check if side 2 + side 3 > side 1
check_two_sides_greater r12, 1, 2, 0
jbe invalid_triangle

; Check if side 3 + side 1 > side 2
check_two_sides_greater r12, 2, 0, 1
jbe invalid_triangle

; If all triangle sides are valid, you have a valid triangle
jmp valid_triangle
; End of valid_sides to check if the sides form a valid triangle

;; Jump here if the sides of the triangle is valid
valid_triangle:
; Set r15 to the results of is_triangle [true] then jump out of the main loop
mov r15, true
jmp end_of_loop
; End of valid_triangle to set r15 to the results of is_triangle [true]

;; Jump here if the sides of the triangle are invalid
invalid_triangle:
; Set r15 to the results of is_triangle [false] then jump out of the main loop
mov r15, false
jmp end_of_loop
; End of invalid_triangle to set r15 to the results of is_triangle [false]

; Exit the main loop
end_of_loop:

; Restore the non-GPRs/SSEs from backup_storage_area
restore_non_gprs backup_storage_area

; Send back true/false stored in r15 back to caller
mov rax, r15

; Restore the GPRs
restore_gprs

ret
