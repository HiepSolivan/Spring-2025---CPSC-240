;Your name : Solivan Hiep
;Your cwid : 884845876
;Your section number : 240 - 3
;Your email address : hiepsolivan @csu.fullerton.edu
;Today’s date : 4 / 23 / 2025
;Identifier : Final program.

; Declarations
%include "utilities.inc"
global getqword
extern printf

; Declare initialized arrays
segment .data


; Declare uninitialized arrays
segment .bss
align 64
backup_storage_area resb 832

segment .text
getqword:

; Call the macro that backs up the GPRs
backup_gprs

; Call the macro that backs up the non-GPRs/SSEs into the backup_storage_area
backup_non_gprs backup_storage_area

; Move the obtained address into a non-volatile register
mov r12, qword[rdi]

; Dereference the address to obtain a hex value
mov r14, qword[r12]

; Call the macro that restores the non-GPRs/SSEs from the backup_storage_area
restore_non_gprs backup_storage_area

; Send back the obtained hex value to the caller
mov rax, r14

; Call the macro that restores the GPRs
restore_gprs

ret
