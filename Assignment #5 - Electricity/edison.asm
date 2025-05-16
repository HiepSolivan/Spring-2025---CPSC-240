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
;  File name: edison.asm
;  Language: X86-64
;  Development Platform: Windows 11 Enterprise Ver. 24H2. Intel(R) Core(TM) i3-8145U CPU @ 2.10GHz 2.30 GHz Processor. Running on Ubuntu 22.04.5 LTS.
;  Max page width: 189 columns
;  Assemble: nasm -f elf64 -l edison.lis -o edison.o edison.asm
;  Assemble (debug in GDB): nasm -f elf64 -gdwarf -l edison.lis -o edison.o edison.asm
;  Page width: 198 columns
;  Optimal print specification: Landscape, 7 points, monospace, 8½x11 paper
;  Prototype of this function: int edison()
;
;========1=========2=========3=========4=========5=========6=========7=========8=========9=========0=========1=========2=========3=========4=========5=========6=========7**
;
;===== Begin code area ====================================================================================================================================================

; Declarations
%include "acdc.inc"
global edison
extern atof
extern input_array
extern ftoa
extern syscall_fgets
extern syscall_strlen
extern tesla

SYS_WRITE equ 1
STDOUT equ 1


; Declare initialized arrays
segment .data

full_name_prompt db "Please enter your full name: "
career_path_prompt db "Please enter the career path you are following: "
thank_you_career_msg db "Thank you.  We appreciate all "
circuit_desc_msg db "Your circuit has 3 sub-circuits."
subcircuit_res_prompt db "Please enter the resistance in ohms on each of the three sub-circuits separated by ws."
append_s db "s."
thank_you_msg db "Thank you."
total_res_msg db "The total resistance of the full circuit is computed to be "
ohms_msg db "  ohms."
emf_msg db "EMF is constant on every branch of any circuit."
emf_prompt db "Please enter the EMF of this circuit in volts:  "
computed_current_msg db "The current flowing in this circuit has been computed:  "
amps_msg db " amps"
thank_you_msg_2 db "Thank you "
using_program_msg db " for using the program Electricity."

; Declare uninitialized arrays
segment .bss
align 64
backup_storage_area resb 832

full_name resb 50
career_path resb 50
resistances resq 3
emf resq 1
chr resb 1 ; Used in acdc.inc

segment .text
edison:

; Call the macro to back up the GPRs
backup_gprs

; Call the macro to back up the non-GPRs/SSEs into the backup_storage_area
backup_non_gprs backup_storage_area

; Print out the prompt for the user to input their full name
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, full_name_prompt
mov rdx, 29
syscall

; Call syscall_fgets [void syscall_fgets(char string[])] to get the user input for their full name via sycall
mov rax, 0
mov rdi, full_name
call syscall_fgets

; Print out the prompt for the user to input their career path
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, career_path_prompt
mov rdx, 48
syscall

; Call syscall_fgets [void syscall_fgets(char string[])] to get the user input for their career path via syscall
mov rax, 0
mov rdi, career_path
call syscall_fgets

; Obtain the length of the user-inputted career for usage in syscall and store it in non-volatile r12 by calling syscall_strlen [long syscall_strlen(char string[])]
mov rax, 0
mov rdi, career_path
call syscall_strlen
mov r12, rax

; Remove the newline character from the end of the user-inputted career
mov [career_path + r12], byte 0

; Print out the message thanking the user and expressing appreciation for the user's tite
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, thank_you_career_msg
mov rdx, 30
syscall

; Print out the user-inputted career.
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, career_path
mov rdx, r12
syscall

; Print out an appended 's' and period (Author's Note: Rather than appending into the array, append the output. This is to allow for appending even if the career exceeds the 50 char limit)
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, append_s
mov rdx, 2
syscall

; Call the macro to print out two newlines
new_line
new_line

; Print out the message describing the circuit structure
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, circuit_desc_msg
mov rdx, 32
syscall

; Call the macro to print a newline
new_line

; Print out the prompt for the user to enter their 3 subcircuits
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, subcircuit_res_prompt
mov rdx, 86
syscall

; Call the macro to print out a newline
new_line

; Call input_array [void input_array(double array[], long capacity)] to input resistances
mov rax, 0
mov rdi, resistances
mov rsi, 3
call input_array

; Print out a thank you message
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, thank_you_msg
mov rdx, 10
syscall

; Call the macro to print out a newline
new_line

; Calculate the total resistance of the full circuit by calling tesla [double tesla(double array[])]
mov rax, 0
mov rdi, resistances
call tesla ; Calculations stored in xmm0
movsd xmm12, xmm0

; Call ftoa [char * ftoa(double num)] to obtain an ASCII string of the computed resistance so it can be printed
mov rax, 1
movsd xmm0, xmm12
call ftoa ; Calculations stored in rax
mov r13, rax

; Call syscall_strlen [long syscall_strlen(char string[])] to obtain the length of the resistance string so it can be printed
mov rax, 0
mov rdi, r13
call syscall_strlen ; Calculations stored in rax
mov r14, rax

; Print out the message explaining the computed resistance
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, total_res_msg
mov rdx, 59
syscall

; Print out the computed resistance
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, r13
mov rdx, r14
syscall

; Print out the message adding the ohm unit to the computed resistance
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, ohms_msg
mov rdx, 7
syscall

; Print out two newlines
new_line
new_line

; Print out the message explaining EMF behavior on a circuit
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, emf_msg
mov rdx, 47
syscall

; Call the macro to print out a newline
new_line

; Print out the prompt for the user to input the EMF of the circuit in volts
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, emf_prompt
mov rdx, 48
syscall

; Call syscall_fgets [void syscall_fgets(char string[])] to get the user input for their EMF via syscall
mov rax, 0
mov rdi, emf
call syscall_fgets

; Convert the obtained user input into a float for use in computations via atof [double atof(char string[])]
mov rax, 0
mov rdi, emf
call atof
movsd xmm13, xmm0

; Compute the current using the formula: I (Current) = R (Resistance) / E (EMF)
movsd xmm14, xmm12
;divsd xmm14, xmm13

; Print out a thank you message
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, thank_you_msg
mov rdx, 10
syscall

; Call the macro to print out two newlines
new_line
new_line

; Print out a message explaining that the current has been computed
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, computed_current_msg
mov rdx, 56
syscall

; Call ftoa [char * ftoa(double num)] to obtain an ASCII string of the computed current so it can be printed
mov rax, 1
movsd xmm0, xmm14
call ftoa ; Calculations stored in rax
mov r15, rax

; Call syscall_strlen [long syscall_strlen(char string[])] to obtain the length of the current string so it can be printed
mov rax, 0
mov rdi, r15
call syscall_strlen ; Calculations stored in rax
mov r11, rax

; Print out the computed current
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, r15
mov rdx, r11
syscall

; Print out the message attaching the amps unit to the computed current
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, amps_msg
mov rdx, 5
syscall

; Call the macro to print a newline
new_line

; Obtain the length of the user's full name via syscall_strlen [long syscall_strlen(char string[])] for use in printing
mov rax, 0
mov rdi, full_name
call syscall_strlen
mov r10, rax

; Print out a thank you message (without a period)
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, thank_you_msg_2
mov rdx, 10
syscall

; Print out the user's full name
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, full_name
mov rdx, r10
syscall

; Finish printing out the thank you message
mov rax, SYS_WRITE
mov rdi, STDOUT
mov rsi, using_program_msg
mov rdx, 35
syscall

; Call the macro to print out two newlines
new_line
new_line

; Call the macro to restore the non-GPRs/SSEs from the backup_storage_area
restore_non_gprs backup_storage_area

; Send back the computed current back to the caller
mov rax, r15

; Call the macro to restore the GPRs
restore_gprs

ret
