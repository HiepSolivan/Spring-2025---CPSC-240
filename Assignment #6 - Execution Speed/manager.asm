;****************************************************************************************************************************
; Program name: "Execution Speed".  The academic objective is to learn how to utilize the clock.
; The application objective is to measure the average time require to perform one floating point addition: addsd xmm10,xmm11 *
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
;  Program name: Execution Speed
;  Programming languages: Six modules in X86, two modules in C++, and one in bash
;  Date program began: 2025-Apr-21
;  Date of last update: 2025-Apr-25
;  Files in the program: manager.asm, input_array.asm, isfloat.asm, sum.asm, getfrequency.asm, utilities.inc, clock.cpp, r.sh
;
;Purpose
;  The academic objective is to learn how to utilize the clock.
;  The application objective is to measure the average time require to perform one floating point addition: addsd xmm10,xmm11
;
;This file
;  File name: manager.asm
;  Language: X86-64
;  Development Platform: Windows 11 Enterprise Ver. 24H2. Intel(R) Core(TM) i3-8145U CPU @ 2.10GHz 2.30 GHz Processor. Running on Ubuntu 22.04.5 LTS.
;  Max page width: 172 columns
;  Assemble: nasm -f elf64 -l manager.lis -o manager.o manager.asm
;  Assemble (debug in GDB): nasm -f elf64 -gdwarf -l manager.lis -o manager.o manager.asm
;  Page width: 172 columns
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: double manaager()
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;===== Begin code area ====================================================================================================================================================

; Declarations
%include "utilities.inc"
global manager
extern input_array
extern sum
extern getfreq

extern printf

; Declaring initialized arrays
segment .data
present_clock_time_msg db "The present time on the clock is %li tics", 10, 10, 0
array_input_msg db "Enter float numbers positive or negative separated by ws. Terminate with control+d", 10, 0
sum_msg db "The sum of these numbers is %.3lf", 10, 0
total_time_msg db "The total time to perform the additions in the ALU was %li tics.", 10, 0
average_time_msg db "That is an average of %.1lf tics per each addition.", 10, 0
ns_msg db "That number of tics equals %.1lf ns.", 10, 10, 0
string_format db "%s"

; Declaring uninitialized arrays
segment .bss
align 64
backup_storage_area resb 832

the_array resq 64

segment .text
manager:

; Call the macro that backs up the GPRs
backup_gprs

; Call the macro that backs up the non-GPRs/SSEs into the backup_storage_area
backup_non_gprs backup_storage_area

; Call the macro to obtain the current clock time in tics
extract_tics

; Print out the message obtaining the present clock time in tics
mov rax, 0
mov rdi, present_clock_time_msg
mov rsi, rdx
call printf

; Print out a message instructing the user to input numbers into the array
mov rax, 0
mov rdi, string_format
mov rsi, array_input_msg
call printf

; Call input_array [long input_array (double array[], long capacity)] to input numbers into the array
mov rax, 0
mov rdi, the_array
mov rsi, 64
call input_array
mov r12, rax ; Save the array's size in r12

; Call the macro to obtain the clock time in tics before finding the sum of the array
extract_tics
mov r13, rdx

; Call sum [double sum(double array[], long size)] to find the sum of the inputted numbers
mov rax, 0
mov rdi, the_array
mov rsi, r12
call sum

; Call the macro to obtain the clock time in tics after finding the sum of the array to compute the elapsed time of sum in tics
extract_tics
mov r14, rdx
sub r14, r13
movsd xmm12, xmm0 ; Save the computed sum in xmm12 here to avoid affecting tic count

; Print out a message stating what the computed was
mov rax, 1
mov rdi, sum_msg
movsd xmm0, xmm12
call printf

; Print out a message stating the total time it took to perform the addition in tics
mov rax, 0
mov rdi, total_time_msg
mov rsi, r14
call printf

; Find the average amount of tics by dividing the total time by the size of the array
cvtsi2sd xmm13, r12
cvtsi2sd xmm14, r14
movsd xmm15, xmm14 ; Store a copy of the amount of tics into xmm15 for later
divsd xmm14, xmm13

; Print out a message stating the average amount of tics it took per addition
mov rax, 1
mov rdi, average_time_msg
movsd xmm0, xmm14
call printf

; Call getfreq [double getfreqy()] to obtain the clockspeed in GHz
mov rax, 0
call getfreq
movsd xmm11, xmm0

; Convert the number of tics into nano-seconds given that GHz = tics/ns. Thereby tics/GHz = ns
divsd xmm15, xmm11

; Print out a message stating the amount of nanoseconds the tics took
mov rax, 1
mov rdi, ns_msg
movsd xmm0, xmm15
call printf

; Prepare to send back the amount of nano-seconds the tics took back to driver by pushing it to the stack
push qword 0
movsd [rsp], xmm15

; Call the macro that restores the non-GPRs/SSEs from the backup_storage_area
restore_non_gprs backup_storage_area

; Send back the amount of nano-seconds the tics took
movsd xmm0, [rsp]
pop rax

; Call the macro that restores the GPRs
restore_gprs

ret
