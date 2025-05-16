;=====Declarations =======================================================================
;These declarations are global to all the macros in this include file "acdc.inc".
SYS_READ equ 0
SYS_WRITE equ 1
STDIN equ 0
STDOUT equ 1

LF equ 10
NULL equ 0

newline db 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa, 0xa

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

; Macro to print a newline
%macro new_line 0
  mov rax, SYS_WRITE
  mov rdi, STDOUT
  mov rsi, newline
  mov rdx, 1
  syscall
%endmacro

; Macro that reads each individual character from user input to store in parameter %1 [Limit: 50 chars (same as size of parameter %1)]
%macro syscall_user_input_macro 1
  ; %1 = Where to store the string
  mov rbx, %1

  ; Maintain a counter to avoid over-indexing
  xor r8, r8

  ; Set off the loop to read each character
  %%read_chars:
  ; Obtain one character from the user
  mov rax, SYS_READ
  mov rdi, STDIN
  lea rsi, byte[chr] ; Use lea (Load Effective Address) to get the address of the character to be read
  mov rdx, 1 ; Read one character
  syscall

  ; Obtain the character from syscall stored in al [the low of rax's low's low] and check if its '\n' [Line feed]. If so, jump out; otherwise, continue
  mov al, byte[chr]
  cmp al, LF
  je %%read_done

  ; Increment the counter and compare it to the max string size. If the counter is greater or equal, reset the loop to stop placing chars in the buffer. Otherwise, continue
  inc r8
  cmp r8, 50
  jge %%read_chars ; Doing this will force the above read_done jump as the buffer is now cleared

  ; Update the string at the index r8 and the address of the string
  mov byte[rbx], al
  inc rbx

  ; Reset the loop
  jmp %%read_chars
  ; End of read_chars to read each character from user input

  ; Jump here once you are finished reading
  %%read_done:

  ; Add a null terminator character to the end of the string
  mov byte[rbx], NULL
%endmacro

; Macro that obtains the string length of the string stored in parameter %1 to output into parameter %2
%macro syscall_strlen_macro 2
  ; %1 - The string to find the length of
  ; %2 - The length of the string
  mov r12, %1

  ; Maintain a counter for each character
  xor r8, r8

  ; Load the effective address of the string to use as an index
  lea r9, [r12]

  ; Kick of the loop to get the string length
  %%count_chars:
  ; Check for the null character. If at null char, jump. Otherwise, continue
  cmp byte [r9], 0
  je %%count_done

  ; Increment both the character count and index then reset the loop
  inc r8
  inc r9
  jmp %%count_chars
  ; End of count_chars to obtain the string length

  ; Jump here to exit the macro
  %%count_done:
  mov %2, r8

%endmacro
