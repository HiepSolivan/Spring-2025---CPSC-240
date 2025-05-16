;****************************************************************************************************************************
; Program name: "Triangles".  The intent of this program is to compute the length of the third
; side of a triangle given other information about the triangle taken via user input.                                        *
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
;  Program name: Triangles
;  Programming languages: Main function in C; assembly function in X86-64; one bash function.
;  Date program began: 2025-Jan-26
;  Date of last update: 2025-Feb-5
;  Files in the program: geometry.c, triangle.asm, r.sh
;
;Purpose
;  The intent of this program is to compute the length of the third
;  side of a triangle given other information about the triangle taken via user input.
;  The program also sends accompanying messages to greet the user.
;  The assembly file performs the calculations to send back to the driver
;
;This file
;  File name: triangle.asm
;  Language: X86-64
;  Max page width: 172 columns
;  Assemble: nasm -f elf64 -l triangle.lis -o triangle.o triangle.asm
;  Page width: 172 columns
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;===== Begin code area ====================================================================================================================================================

; Declarations
extern cos
extern fgets
extern printf
extern scanf
extern sqrt
extern stdin
extern strlen
global triangle

uninitialized_size equ 48

; Declare initialized arrays
segment .data
last_name_message db "Please enter your last name: ", 0
user_title_suffix_message db "Please enter your title (Mr, Ms, Nurse, Engineer, etc): ", 0
triangle_side_message db "Please enter the sides of your triangle separated by ws: ", 0
angle_degrees_message db "Please enter the size in degrees of the angle between those sides: ", 0
third_side_message db "The length of the third side is %.10lf units.", 10, 0
enjoy_message db "Please enjoy your triangles %s %s.", 10, 0
string_format db "%s", 0
eight_bit_float_format db "%lf", 0
eight_bit_float_format_quantity_2 db "%lf %lf", 0
one_hundred_eighty dq 180.0
pi dq 3.14159265358979323846

; Declare uninitialized arrays
segment .bss
last_name_input resb uninitialized_size
user_title_suffix_input resb uninitialized_size
triangle_side_input_1 resq uninitialized_size
triangle_side_input_2 resq uninitialized_size

segment .text
triangle:

; Back up GPRs
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

mov qword []

; Print out side
mov rax, 0 
mov rdi, float_format
mov rsi, [triangle_side_input_1]
call printf

; Print out last name prompt
mov rax, 0
mov rdi, string_format
mov rsi, last_name_message
call printf

; User inputs last name
mov rax, 0
mov rdi, last_name_input
mov rsi, uninitialized_size
mov rdx, [stdin]
call fgets

; Remove the newline from previous input (last name)
mov rax, 0
mov rdi, last_name_input
call strlen
mov [last_name_input + rax - 1], byte 0

; Print out title suffix prompt
mov rax, 0
mov rdi, string_format
mov rsi, user_title_suffix_message
call printf

; User inputs title suffix
mov rax, 0
mov rdi, user_title_suffix_input
mov rsi, uninitialized_size
mov rdx, [stdin]
call fgets

; Remove the newline from previous input (user title suffix)
mov rax, 0
mov rdi, user_title_suffix_input
call strlen
mov [user_title_suffix_input + rax - 1], byte 0

; Print out triangle side prompt
mov rax, 0
mov rdi, string_format
mov rsi, triangle_side_message
call printf

; User inputs twp triangle sides separated by whitespace
mov rax, 0   ;Getting 2 floats, but no float arguments used
;push qword 0 ;Ensure scanf reads 16 bytes
;push qword 0
mov rdi, eight_bit_float_format_quantity_2
mov rsi, triangle_side_input_1
mov rdx, triangle_side_input_2
call scanf
;pop rax
;pop rax

; Print out angle degrees prompt
mov rax, 0
mov rdi, string_format
mov rsi, angle_degrees_message
call printf

; User input angle degrees
mov rax, 0
push qword 0
push qword 0
mov rdi, eight_bit_float_format
mov rsi, rsp
call scanf
movsd xmm10, [rsp] ;Store angle into xmm10
pop rax
pop rax

; Convert the user inputted (xmm10) degrees into radians
movsd xmm1, [pi] ;Because xmm1 is empty, move pi to prepare for operations
movsd xmm2, [one_hundred_eighty] ;Because xmm2 is empty, move 180.0 to prepare for operations
divsd xmm1, xmm2 ;Perform pi / 180.0
movsd xmm3, xmm1 ;Store results in xmm3
movsd xmm1, xmm10 ;Move xmm10 (user-inputted angle) into xmm1 to prepare for operations
mulsd xmm1, xmm3 ;Perform (pi / 100) * degrees
movsd xmm3, xmm1
movsd xmm11, xmm3 ;Store final results of radian_conversion into xmm11

; Compute the cosine of the angle
mov rax, 1
movsd xmm0, xmm11
call cos
movsd xmm12, xmm0 ;Store cosine results into xmm12

; Compute 2ab * cos(C)
movsd xmm1, [triangle_side_input_1] ;Because xmm1 is empty, move side 1 to prepare for operations
movsd xmm2, [triangle_side_input_2] ;Because xmm2 is empty, move side 2 to prepare for operations
movsd xmm3, xmm12 ;Because xmm3 is empty, move cosine results to prepare for operations
addsd xmm1, xmm1 ;Add xmm1 to itself to simulate 2a
mulsd xmm1, xmm2 ;Multiply xmm2 to xmm1 to simulate 2ab
mulsd xmm1, xmm3 ;Multiply xmm3 to xmm1 to simulate 2ab * cos(C)
movsd xmm13, xmm1 ;Store final results of two_ab_cosc into xmm13

; Compute law of cosines [c^2 = a^2 + b^2 - (2ab * cos(C))]
movsd xmm1, [triangle_side_input_1] ;Because xmm1 is empty, move side 1 to prepare for operations
movsd xmm2, [triangle_side_input_2] ;Because xmm2 is empty, move side 2 to prepare for operations
movsd xmm3, xmm13 ;Because xmm3 is empty, move (2ab * cos(C)) to prepare for operations
mulsd xmm1, xmm1 ;Multiply xmm1 to itself to simulate a^2
mulsd xmm2, xmm2 ;Multiply xmm2 to itself to simulate b^2
movsd xmm4, xmm1 ;Move xmm1 into xmm4 to store results
addsd xmm4, xmm2
subsd xmm4, xmm3
movsd xmm14, xmm4 ;Store final results of c_squared into xmm14

; Compute c by taking the square root of c^2
mov rax, 1
movsd xmm0, xmm14
call sqrt
movsd xmm15, xmm0 ;Store results of sqrt c^2 into xmm15

; Print out third side message
mov rax, 1
mov rdi, third_side_message
movsd xmm0, xmm15
call printf

; Print out enjoy message
mov rax, 0
mov rdi, enjoy_message
mov rsi, user_title_suffix_input
mov rdx, last_name_input
call printf

; Move results to the stack
mov rax, 0
push qword 0
movsd [rsp], xmm15

; Send back the third side
movsd xmm0, [rsp]
pop rax

; Restore the GPRs and close
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
pop rbp
ret
