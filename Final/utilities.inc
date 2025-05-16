;Your name : Solivan Hiep
;Your cwid : 884845876
;Your section number : 240 - 3
;Your email address : hiepsolivan @csu.fullerton.edu
;Today’s date : 4 / 23 / 2025
;Identifier : Final program.

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

; Macro that obtains the current number of ticks from the clock and places them in rdx
%macro extract_tics 0
  mov rdx, 0
  cpuid
  rdtsc
  shl rdx, 32
  add rdx, rax
%endmacro
