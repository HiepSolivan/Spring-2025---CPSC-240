;****************************************************************************************************************************
; Program name: "Non-deterministic random numbers".  The intent of this program is to generate up to 100 random numbers using *
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
;  The intent of this program is to generate up to 100 random numbers using
;  the non-deterministic random number generator found inside of modern X86 microprocessors.
;
;This file
;  File name: manager.asm
;  Language: X86-64
;  Development Platform: Windows 11 Enterprise Ver. 24H2. Intel(R) Core(TM) i3-8145U CPU @ 2.10GHz 2.30 GHz Processor. Running on Ubuntu 22.04.5 LTS.
;  Max page width: 172 columns
;  Assemble: nasm -f elf64 -l executive.lis -o executive.o executive.asm
;  Assemble (debug in GDB): nasm -f elf64 -gdwarf -l executive.lis -o executive.o executive.asm
;  Page width: 172 columns
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: char * executive()
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;===== Begin code area ====================================================================================================================================================

; Declarations
%include "utilities.inc"
extern fgets
extern printf
extern scanf
extern stdin
extern strlen

extern fill_random_array
extern show_array
extern normalize_array
extern sort
global executive

; Declare initialized arrays
segment .data
enter_name_prompt db "Please enter your name: ", 0
enter_title_prompt db "Please enter your title (Mr, Ms, Sargent, Chief, Project Leader, etc): ", 0
greeting_msg db "Nice to meet you %s %s", 10, 10, 0
program_details_msg db "This program will generate 64-bit IEEE float numbers.", 10, 0
generate_number_prompt db "How many numbers do you want.  Today’s limit is 100 per customer. ", 0
array_filled_msg db "Your numbers have been stored in an array.  Here is that array.", 10, 10, 0
normalized_array_msg db 10, "The array will now be normalized to the range 1.0 to 2.0  Here is the normalized array", 10, 10, 0
sort_array_msg db 10, "The array will now be sorted", 10, 10, 0
farewell_msg db 10, "Good bye %s.  You are welcome any time.", 10, 10, 0
integer_format db "%d", 0
string_format db "%s", 0
debug db "Debug", 10, 0

; Declare uninitialized arrays
segment .bss
align 64
backup_storage_area resb 832

name_input resb 48
title_input resb 48
the_array resq 100

segment .text
executive:

; Call the macro to back-up the GPRs
backup_gprs

; Call the macro to back-up the non-GPRs/SSEs the backup_storage_area
backup_non_gprs backup_storage_area

; Print out the prompt for the user to enter their name
mov rax, 0
mov rdi, string_format
mov rsi, enter_name_prompt
call printf

; Have the user input their name to store in name_input
mov rax, 0
mov rdi, name_input
mov rsi, 48
mov rdx, [stdin]
call fgets

; Call the macro to remove the new line from name_input
remove_new_line name_input

; Print out the prompt for the user to enter their title
mov rax, 0
mov rdi, string_format
mov rsi, enter_title_prompt
call printf

; Have the user input their title to store in title_input
mov rax, 0
mov rdi, title_input
mov rsi, 48
mov rdx, [stdin]
call fgets

; Call the macro to remove the new line from title_input
remove_new_line title_input

; Print out the message greeting the user with their name and title
mov rax, 0
mov rdi, greeting_msg
mov rsi, title_input
mov rdx, name_input
call printf

; Print out the message detailing what the program does
mov rax, 0
mov rdi, string_format
mov rsi, program_details_msg
call printf

; Print out the prompt for the user to input how many numbers they wish to generate
mov rax, 0
mov rdi, string_format
mov rsi, generate_number_prompt
call printf

; Have the user input how many numbers they wish to generate and store it in r12
mov rax, 0
push qword 0
push qword 0
mov rdi, integer_format
mov rsi, rsp
call scanf
mov r12, [rsp]
pop rax
pop rax

; Check if the user inputted more than 100 for the array size. If so, adjust the size, otherwise, continue.
cmp r12, 100
jge adjust_size

continue:
; Call fill_random_array [void fill_random_array(double array [], int size)] to fill the_array with the amount of random numbers the user specified
mov rax, 0
mov rdi, the_array
mov rsi, r12
call fill_random_array

; Print out the message stating that the array has been filled and is ready to be displayed
mov rax, 0
mov rdi, string_format
mov rsi, array_filled_msg
call printf

; Call show_array [void show_array(double array [], int size)] to print out the array
mov rax, 0
mov rdi, the_array
mov rsi, r12
call show_array

; Print out the message stating that the array has been normalized to the range 1.0 to 2.0
mov rax, 0
mov rdi, string_format
mov rsi, normalized_array_msg
call printf

; Call normalize_array [void normalize_array(double array [], int size)] to normalize the array to the range 1.0 to 20
mov rax, 0
mov rdi, the_array
mov rsi, r12
call normalize_array

; Call show_array [void show_array(double array [], int size)] to print out the normalized ([1.0, 2)) array
mov rax, 0
mov rdi, the_array
mov rsi, r12
call show_array

; Print out the message stating that the array has been sorted
mov rax, 0
mov rdi, string_format
mov rsi, sort_array_msg
call printf

; Call sort [void sort (double array[], long array_size)] to sort the array using selection sort
mov rax, 0
mov rdi, the_array
mov rsi, r12
call sort

; Call show_array [void show_array(double array [], int size)] to print out the sorted array
mov rax, 0
mov rdi, the_array
mov rsi, r12
call show_array

; Print out the message saying farewell to the user by their inputted title
mov rax, 0
mov rdi, farewell_msg
mov rsi, title_input
call printf

jmp end_program
; Jump here if the user inputted more than 100 for the array size
adjust_size:

; Adjust the array size to the maximum (100), then proceed as normal
mov r12, 100
jmp continue
; End of adjust_size to adjust the size of the maximum number of arrays

end_program:
; Call the macro to restore the non-GPRs/SSEs from the backup_storage_area
restore_non_gprs backup_storage_area

; Send back the user's name back to main
mov rax, name_input

; Call the macro to restore the GPRs
restore_gprs

ret
