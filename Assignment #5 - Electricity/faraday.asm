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
;  File name: faraday.asm
;  Language: X86-64
;  Development Platform: Windows 11 Enterprise Ver. 24H2. Intel(R) Core(TM) i3-8145U CPU @ 2.10GHz 2.30 GHz Processor. Running on Ubuntu 22.04.5 LTS.
;  Max page width: 172 columns
;  Assemble: nasm -f elf64 -l faraday.lis -o faraday.o faraday.asm
;  Assemble (debug in GDB): nasm -f elf64 -gdwarf -l faraday.lis -o faraday.o faraday.asm
;  Page width: 172 columns
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: int faraday()
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;===== Begin code area ====================================================================================================================================================

; Declarations
global _start ; Global declaration for the linker
extern edison
extern syscall_strlen

SYS_WRITE equ 1
SYS_EXIT equ 60
STDOUT equ 1

; Declare initialized arrays
segment .data
newline db 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa           ;Declare an array of 8 bytes where each byte is initialized with ascii value 10 [A] (newline)

welcome_msg db "Welcome to Electricity brought to you by Solivan Hiep."
program_desc_msg db "This program will compute the resistance current flow in your direct circuit."
number_received_msg db "The driver received this number  "
next_semester_msg db ", and will keep it until next semester."
zero_return_msg db "A zero will be returned to the Operating System"

; Declare uninitialized arrays
segment .bss

segment .text
_start:
; NOTE: We do not need to backup our registers because we have no caller

; Print out the welcome message introducing the program and its author
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, welcome_msg
mov rdx, 54 ; Amount of characters to be read
syscall

; Print out a new line
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, newline
mov rdx, 1
syscall

; Print out the message explaining what the program does
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, program_desc_msg
mov rdx, 77
syscall

; Print out a new line
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, newline
mov rdx, 1
syscall

; Print out another new line
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, newline
mov rdx, 1
syscall

; Call edison [double edison()] to obtain the current in a circuit given the resistance in ohms on three sub-circuits
mov rax, 0
call edison
mov r12, rax

; Print out a message stating what number was received from edison
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, number_received_msg
mov rdx, 33
syscall

; Call syscall_strlen [long syscall_strlen(char string[])] to obtain the length of the current string for use in printing
mov rax, 0
mov rdi, r12
call syscall_strlen
mov r13, rax

; Print out the number received
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, r12
mov rdx, r13
syscall

; Print out a message stating that the number will be kept until next semester
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, next_semester_msg
mov rdx, 39
syscall

; Print out a new line
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, newline
mov rdx, 1
syscall

; Print out the message stating that the driver will return a 0
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, zero_return_msg
mov rdx, 47
syscall

; Print out a new line
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, newline
mov rdx, 1
syscall

; Return and exit the program with error code 0
mov rax, SYS_EXIT
mov rdi, 0
syscall
