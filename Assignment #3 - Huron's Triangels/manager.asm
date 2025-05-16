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
;  Files in the program: manager.asm, isfloat.asm, istriangle.asm, huron.asm, triangle.inc, main.c, r.sh
;
;Purpose
;  The intent of this program is to compute the area of any triangle where the lengths of the
;  three sides is known using Huron's formula.
;  The educational purpose is to reinforce my skill of using a few techniques from the past such as data validation
;  and parameter passing as well as use macros in this program to hopefully understand how to use
;  macros in other situations
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
;  Prototype of this function: double manager()
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;===== Begin code area ====================================================================================================================================================

; Declarations
%include "triangle.inc"

extern atof
extern printf
extern scanf

extern isfloat
extern istriangle
extern huron
global manager

; Declare initialized arrays
segment .data
three_sides_prompt db "Please enter the lengths of three sides of a triangle [Enter CTRL + D when finished]:", 10, 0
thank_you_msg db "Thank you.", 10, 10, 0
valid_triangle_msg db "These inputs have been tested and they are sides of a valid triangle.", 10, 10, 0
invalid_triangle_msg db "These inputs have been tested and they are not the sides of a valid triangle.", 10, 10, 0
huron_app_msg db "The Huron formula will be applied to find the area.", 10, 10, 0
huron_results_msg db "The area is %.6lf sq units. This number will be returned to the caller module.", 10, 10, 0
error_input_msg db "Error input try again", 10, 0
run_again_msg db "You may run this program again with valid triangle numbers", 10, 10, 0
string_format db "%s", 0
float_format db "%lf", 0
fail dq -1.0

games dq 37,93,107,60,110,87,79

; Declare uninitialized arrays
segment .bss
sides resq 48 ; Optimally, only 3 should be inputted but allow for backup space on the queue

align 64
backup_storage_area resb 832

segment .text
manager:

; Call the macro to back-up the GPRs
backup_gprs

; Call the macro to back-up the non-GPRs + SSEs into backup_storage_area
backup_non_gprs backup_storage_area

; Call the macros to display who the program is courtesy of and their information [name, CWID, and e-mail]
display_info
display_author_name
display_cwid
display_email

; Print out message instructing user to enter the length of the three sides of the triangle
mov rax, 0
mov rdi, string_format
mov rsi, three_sides_prompt
call printf

; Maintain a counter using the non-volatile register r14 to ensure no over-indexing. This counter also doubles as the size of the array.
xor r14, r14 ; Comparing r14 to itself via xor sets r14 to 0

; Start the loop to input (preferably 3) sides of the triangle
inputting_sides:

; Check for over indexing by checking if r14 >= 48 [Maximum size of the array]. If so, exit and continue program. Otherwise, continue looping.
cmp r14, 48
jge continue_program

; Prompt for user input for the array. The input is received as a STRING
push qword 0 ; Ensure scanf reads 64 bits
push qword 0
mov rax, 0
mov rdi, string_format
mov rsi, rsp
call scanf

; Check if scanf actually stored the value into the array [r12] by checking if the low of rax (eax) equals -1. If so, jump to scan_ended. Otherwise, continue.
cmp eax, -1 ; Note: This comparison ALSO checks if the user pressed CTRL + D
je scan_ended

; Validate the most recent input by calling isfloat [bool isfloat(char [] input)]
mov rdi, rsp
call isfloat
cmp rax, 0 ; If isfloat returned a 0, then we did not get a float
je try_again

; Now that we have a valid float, call atof [double atof (char str[])] to convert the array of ASCII chars into a float
mov rax, 0
mov rdi, rsp
call atof ; Stores the float into xmm0

; Pop the stack now that we are done with the user-inputted float
pop rax
pop rax

; Insert the float into the array
movsd [sides + r14 * 8], xmm0

; Increment the counter r14 then jump back to the top of the loop if everything goes well
inc r14
jmp inputting_sides
; End of the main loop inputting_sides to input sides into the array

;; Jump here if the scan failed
scan_ended:

;; Pop what is currently on the stack (to avoid segmentation faults) then exit the loop
pop rax
pop rax
jmp continue_program
;; End of scan_ended to end the loop inputting_sides if scanf failed

;; Jump here if a float was not inputted
try_again:

;; Print out a message requesting the user to try again due to invalid input
mov rax, 0
mov rdi, string_format
mov rsi, error_input_msg
call printf

;; Pop what is currently on the stack (to avoid segmentation faults) then jump back to the top of the loop inputting_sides
pop rax
pop rax
jmp inputting_sides
;; End of try_again to request user to try again after inputting an invalid input

; Exit the loop inputting_sides to continue the rest of manager
continue_program:

; Print out thank you message
mov rax, 0
mov rdi, string_format
mov rsi, thank_you_msg
call printf

; Validate if what is in the array is are sides of a valid triangle using istriangle [bool istriangle(double array[], long size)]. If valid, continue. Otherwise, jump to not_valid
mov rax, 0
mov rdi, sides
mov rsi, r14
call istriangle
cmp rax, 0 ; If istriangle returned a 0, then we do not have a valid triangle
je not_valid

; Print out message affirming that the triangle is valid
mov rax, 0
mov rdi, string_format
mov rsi, valid_triangle_msg
call printf

; Print out message that the Huron's formula will be applied to the sides of the triangle
mov rax, 0
mov rdi, string_format
mov rsi, huron_app_msg
call printf

; With a valid triangle, call huron [double huron(double array[])] to calculate the area of the triangle using Huron's formula
mov rax, 0
mov rdi, sides
call huron
movsd xmm10, xmm0; Move the results from huron into non-volatile xmm10

; Print out the results of huron and explain how the results will be returned to the driver
mov rax, 1
mov rdi, huron_results_msg
movsd xmm0, xmm10
call printf

; Move the results of Huron's Formula into the stack in preparation of sending back to main
mov rax, 0
push qword 0
movsd [rsp], xmm10

; Call the macro to restore the non-GPRs + SSEs from the backup_storage_area
restore_non_gprs backup_storage_area

; Send back the successful results of manager to main
movsd xmm0, [rsp]
pop rax

; Call the macro to restore the GPRs
restore_gprs

ret
; End of continue_program which validated the sides of the triangle and used Huron's formula

; Jump here if istriangle returned a false to print some messages
not_valid:

; Print out the message stating that the triangle is valid
mov rax, 0
mov rdi, string_format
mov rsi, invalid_triangle_msg
call printf

; Print out the message encouraging the user to run the program again
mov rax, 0
mov rdi, string_format
mov rsi, run_again_msg
call printf

; Send back a -1 to indicate invalid triangle
mov rax, 0
push qword 0
movsd xmm10, [fail]
movsd [rsp], xmm10

; Call the macro to restore the non-GPRs + SSEs from the backup_storage_area
restore_non_gprs backup_storage_area

; Send back the failed results of manager back to main
movsd xmm0, [rsp]
pop rax

; Call the macro to restore the GPRs
restore_gprs

ret
