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
;  File name: manager.asm
;  Language: X86-64
;  Development Platform: Windows 11 running UNIX
;  Max page width: 172 columns
;  Assemble: nasm -f elf64 -l manager.lis -o manager.o manager.asm
;  Page width: 172 columns
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: double manager()
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;===== Begin code area ====================================================================================================================================================

; Declarations
extern printf

extern input_array
extern output_array
extern sort
extern sum
global manager

; Declare initialized arrays
segment .data
management_intro_prompt db "This program will manage your arrays of 64-bit floats", 10, 0
array_intro_prompt db "For the array enter a sequence of 64-bit floats separated by white space.", 10, 0
last_input_intro_prompt db "After the last input press enter followed by Control+D: ", 10, 0
received_numbers_for_array_prompt db 10, "These numbers were received and placed into an array", 10, 0
sum_prompt db "The sum of the inputted numbers is %.9lf", 10, 0
mean_prompt db "The arithmetic mean of the numbers in the array is %.6lf", 10, 0
sort_results_prompt db "This is the array after the sort process completed:", 10, 0

string_format db "%s", 0

; Declare uninitialized arrays
segment .bss
the_array resq 48

align 64
backup_storage_area resb 832

segment .text
manager:

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

; Print out the prompt describing what the program is
mov rax, 0
mov rdi, string_format
mov rsi, management_intro_prompt
call printf

; Print out the prompt describing how to input numbers for the array
mov rax, 0
mov rdi, string_format
mov rsi, array_intro_prompt
call printf

; Print out the prompt describing how to input the last input
mov rax, 0
mov rdi, string_format
mov rsi, last_input_intro_prompt
call printf

; Begin inputting the array through input_array [long input_array(double array[], long capacity)]
mov rax, 0
mov rdi, the_array
mov rsi, 48
call input_array ; Call input_array and get back the size (used to compute mean) which is stored in rax

; Store the size of the array into a non-volatile register
mov r12, rax

; Print out prompt affirming what numbers were successfully inputted into the array
mov rax, 0
mov rdi, string_format
mov rsi, received_numbers_for_array_prompt
call printf

; Print out what numbers were successfully inputted into the array by calling output_array [void output_array(double array[], long size)]
mov rax, 0
mov rdi, the_array
mov rsi, r12 ; [r12 = size of array]
call output_array

; Find the sum of all the elements in the array by calling sum [double sum(double array[], long size)], then store it in a non-volatile register
mov rax, 0
mov rdi, the_array
mov rsi, r12 ; [r12 = size of array]
call sum
movsd xmm15, xmm0

; Print out the sum of all the elements in the array
mov rax, 1
mov rdi, sum_prompt
movsd xmm0, xmm15
call printf

; Compute the mean of the elements in the array by taking the sum [xmm15] and dividing it by the size [r12]
cvtsi2sd xmm1, r12 ; Convert Integer [r12] to Scalar Double
movsd xmm2, xmm15 ; Because xmm1 is empty, store xmm15 to prepare for operations
divsd xmm2, xmm1
movsd xmm14, xmm2 ; Store the mean into the non-volatile register xmm14

; Print out the mean of all the elements in the array
mov rax, 1
mov rdi, mean_prompt
movsd xmm0, xmm14
call printf

; Print out the array after sorting
mov rax, 0
mov rdi, string_format
mov rsi, sort_results_prompt
call printf

; Sort the array using insertion sort [void sort (double array[], long array_size)]
mov rax, 0
mov rdi, the_array
mov rsi, r12
call sort

; Print out the sorted array by calling output_array [void output_array(double array[], long size)]
mov rax, 0
mov rdi, the_array
mov rsi, r12 ; [r12 = size of array]
call output_array

; Move the sum to the stack before restoring SSEs to maintain the value
mov rax, 0
push qword 0
movsd [rsp], xmm15

; Restore the values to non-GPRs/sse registers
mov rax, 7
mov rdx, 0
xrstor [backup_storage_area]

; Send back the sum stored in rsp and pop the stack
movsd xmm0, [rsp]
pop rax

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
;End of the function manager ====================================================================
