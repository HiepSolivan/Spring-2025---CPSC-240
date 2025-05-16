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
;  File name: isnan.asm
;  Language: X86-64
;  Development Platform: Windows 11 Enterprise Ver. 24H2. Intel(R) Core(TM) i3-8145U CPU @ 2.10GHz 2.30 GHz Processor. Running on Ubuntu 22.04.5 LTS.
;  Max page width: 172 columns
;  Assemble: nasm -f elf64 -l isnan.lis -o isnan.o isnan.asm
;  Assemble (debug in GDB): nasm -f elf64 -gdwarf -l isnan.lis -o isnan.o isnan.asm
;  Page width: 172 columns
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: bool isnan(double number)
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;===== Begin code area ====================================================================================================================================================

; Declarations
%include "utilities.inc"
global isnan

extern printf

true equ 1
false equ 0

; Declare initialized arrays
segment .data

; Declare uninitialized arrays
segment .bss
align 64
backup_storage_area resb 832

segment .text
isnan:

; Call the macro to back up the GPRs
backup_gprs

; Call the macro to back up the non-GPRs + SSEs into backup_storage_area
backup_non_gprs backup_storage_area

; Store the argument holding the number to be checked into a non-volatile SSE register xmm9
movsd xmm9, xmm0

; Check if the number is a NaN by comparing it to itself and checking if it sets of the parity flag.
ucomisd xmm9, xmm9
jp nan

; If we made it here, we do not have a NaN and can prepare to return a false
mov r15, false
jmp end_program

; Jump here if the parity flag set off, implying the existence of a NaN
nan:

; Prepare to return a true then exit
mov r15, true
jmp end_program
; End of nan to prepare to return a true

; Exit the program and clean up the activation record
end_program:

; Call the macro to restore the non-GPRs + SSEs in backup_storage_area
restore_non_gprs backup_storage_area

; Send back the results of the program to the caller
mov rax, r15

; Call the macro to restore the GPRs
restore_gprs

ret
