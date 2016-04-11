INCLUDE "inc/hardware.inc"

;If all of these are already defined, don't do it again.

IF      !DEF(MEMORY_INC)
MEMORY_INC  SET  1

; Macro that pauses until VRAM available.

lcd_WaitVRAM: MACRO
        ld      a,[rSTAT]       ; <---+
        and     STATF_BUSY      ;     |
        jr      nz,@-4          ; ----+
        ENDM
		
GLOBAL mem_Set
GLOBAL mem_Copy
GLOBAL mem_CopyMono
GLOBAL mem_SetVRAM
GLOBAL mem_CopyVRAM

ENDC