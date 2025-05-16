;****************************************************************************************************************************
; Your name as author: Solivan Hiep
; Your section number: CPSC 240-03
; Today’s date: March 10, 2025
; Your preferred return email address: hiepsolivan@csu.fullerton.edu
;****************************************************************************************************************************

; Declarations
extern printf

extern input_array
extern output_array
extern sum_of_reciprocals
global manager

; Declare initialized arrays
segment .data
welcome_msg db "Welcome to Welcome to Harmonic Means.", 10, 0
array_intro_prompt db "For the array enter a sequence of 64-bit floats separated by white space. The upper limit is 10.", 10, 0
last_input_intro_prompt db "After the last input press enter followed by Control+D: ", 10, 0
array_status_prompt db "These values are currently stored in the array:", 10, 0
sum_of_reciprocals_msg db "The sum of the reciprocals of the elements in the array is %.6lf.", 10, 0
harmonic_mean_msg db "The harmonic mean of the elements in the array is %.6lf. It will be returned to main...", 10, 0
string_format db "%s", 0

; Declare uninitialized arrays
segment .bss
the_array resq 48 ; Allow capacity to be greater than upper limit
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

; Print out a welcome message
mov rax, 0
mov rdi, string_format
mov rsi, welcome_msg
call printf

; Print out the message instructing the user how to input their numbers
mov rax, 0
mov rdi, string_format
mov rsi, array_intro_prompt
call printf

; Print out the message instructing the user how to exit from inputting
mov rax, 0
mov rdi, string_format
mov rsi, last_input_intro_prompt
call printf

; Input values into the array by input_array [long input_array(double array[], long capacity)]
mov rax, 0
mov rdi, the_array
mov rsi, 10
call input_array
mov r12, rax ; Move the size of the array obtained from input_array into a non-volatile register r12

; Print out a message in preparation for printing the array
mov rax, 0
mov rdi, string_format
mov rsi, array_status_prompt
call printf

; Output the values from the array by calling output_array [void output(double array[], long size)]
mov rax, 0
mov rdi, the_array
mov rsi, r12 ;[r12 = size of array]
call output_array

; Find the sum of the reciprocals of the array by calling sum_of_reciprocals[double sum_of_reciprocals(double array[], long size)]
mov rax, 0
mov rdi, the_array
mov rsi, r12
call sum_of_reciprocals
movsd xmm12, xmm0 ; Move the sum of the reciprocals obtained into a non-volatile register


; Print out a message indicating what the sum of the reciprocals of the elements in the array are
mov rax, 1
mov rdi, sum_of_reciprocals_msg
movsd xmm0, xmm12
call printf

; Find the harmonic mean: divide the total elements in the array by the sum of the reciprocals
movsd xmm13, xmm12 ; Compute the harmonic mean in xmm13
cvtsi2sd xmm14, r12 ;  Convert Doubleword Integer to Scalar Double: convert the int r12 into a float to be usable in operations
divsd xmm13, xmm14

; Print out a message indicating what the harmonic sum of the elements in the array is
mov rax, 1
mov rdi, harmonic_mean_msg
movsd xmm0, xmm13
call printf

; Prepare to return the harmonic sum by pushing it to the stack
mov rax, 0
push qword 0
movsd [rsp], xmm13

; Restore the values to non-GPRs/sse registers
mov rax, 7
mov rdx, 0
xrstor [backup_storage_area]

; Move the results of the harmonic sum back to main
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
