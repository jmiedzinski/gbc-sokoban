;*
;* Keypad Code
;*
;*   Started 15-April-97
;*
;* Initials: JF = Jeff Frohwein, CS = Carsten Sorensen
;*
;* V1.0 - 17-Jul-97 : Original Release - JF
;* V1.1 - 19-Jul-97 : Added Joypad equates - JF, inspired by CS
;*                  : Modified for new subroutine prefixes - JF
;* V1.2 - 16-Aug-97 : Output format similiar to CS - JF
;* V1.3 - 18-Aug-97 : Converted to newer 'hardware.inc' - JF
;*

;If all of these are already defined, don't do it again.
IF      !DEF(KEYPAD_INC)
KEYPAD_INC  SET  1

GLOBAL pad_Read
GLOBAL _PadData
GLOBAL _PadDataEdge

ENDC    ;keypad_asm