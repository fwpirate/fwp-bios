;
;   FWP-BIOS ENTRY POINT
;
;   Authors:
;       -  fwpirate <alavik@disroot.org>

section .reset_vector
    jmp start                          ; Jump to the start of the BIOS code

section .bios
start:
    ; Load all 256 entries in the IVT
    mov ax, cs                         ; Get the current code segment (CS)
    mov ds, ax                         ; Set DS to CS so we can use it for memory access

    xor di, di                         ; Start at 0x0000:0x0000, the start of the IVT
    mov bx, ivt_handler                ; Load offset of ivt_handler

    mov cx, 256                        ; 256 entries in the IVT
set_ivt:
    mov [di], bx                       ; Set the offset of the interrupt handler
    mov [di + 2], ax                   ; Set the segment of the interrupt handler (CS)
    add di, 4                          ; Move to the next IVT entry (each entry is 4 bytes)
    loop set_ivt                       ; Repeat until all 256 entries are set

    jmp entry                          ; Jump to the entry point (post-ivt)

ivt_handler:
    ; Do some magic here (interrupt handler code)
    hlt                                ; Halt the CPU (for demonstration)

entry:
    int 0x1                            ; Fire test interrupt
    jmp $                              ; Infinite loop
