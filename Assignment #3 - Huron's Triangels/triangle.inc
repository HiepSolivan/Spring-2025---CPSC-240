;=====Declarations =======================================================================
;These declarations are global to all the macros in this include file "triangle.inc".
courtesy_msg db "This program is brought to you as a courtesy of", 10, 0
author_msg db "Author: Solivan Hiep", 10, 0
cwid_msg db "Cwid: 884-845-876", 10, 0
email_msg db "Email: hiepsolivan@csu.fullerton.edu", 10, 10, 0

; Macro that backs up the GPRs
%macro backup_gprs 0
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
%endmacro

; Macro that restores the GPRs
%macro restore_gprs 0
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
%endmacro

; Macro that back ups non-GPRs/SSEs to an array stored in parameter %1
%macro backup_non_gprs 1
  mov rax, 7
  mov rdx, 0
  xsave [%1]
%endmacro

; Macro that restores the non-GPRs/SSEs in storage array of parameter %1
%macro restore_non_gprs 1
  mov rax, 7
  mov rdx, 0
  xrstor [%1]
%endmacro

; Macro that introduces who the program is courtesy of
%macro display_info 0
  mov rax, 0
  mov rdi, string_format ; This string format was already declared in manager.asm, so we don't need to redefine it
  mov rsi, courtesy_msg
  call printf
%endmacro

; Macro that prints out the author's name
%macro display_author_name 0
  mov rax, 0
  mov rdi, string_format
  mov rsi, author_msg
  call printf
%endmacro

; Macro that prints out the author's CWID
%macro display_cwid 0
  mov rax, 0
  mov rdi, string_format
  mov rsi, cwid_msg
  call printf
%endmacro

; Macro that prints out the author's email
%macro display_email 0
  mov rax, 0
  mov rdi, string_format
  mov rsi, email_msg
  call printf
%endmacro

; Macro that checks if the sum of the first two sides is greater than the third
%macro check_two_sides_greater 4
  ; %1 = the array of sides
  ; %2 = index of first side [from 0]
  ; %3 = index of second side
  ; %4 = index of third side
  mov r12, %1
  mov r13, %2
  mov r14, %3
  mov r15, %4
  movsd xmm1, qword[r12 + r13 * 8]
  movsd xmm2, qword[r12 + r14 * 8]
  addsd xmm1, xmm2
  movsd xmm3, qword[r12 + r15 * 8]
  ucomisd xmm1, xmm3 ; Unordered Compare Scalar Double Precision Floating-Point Values (i.e comparing SSEs)
%endmacro
