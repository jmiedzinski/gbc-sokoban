INCLUDE "inc/keypad.inc"
INCLUDE "inc/hardware.inc"
INCLUDE "inc/vars.inc"

;*
;* Variables
;*

SECTION "UtilityVars",WRAM0

_PadData::      DS      1
_PadDataEdge::  DS      1

SECTION "Keypad Code",ROM0

;***************************************************************************
;*
;* pad_Read - Read the joypad
;*
;* output:
;*   _PadData & A     - joypad matrix
;*   _PadDataEdge & B - edge data: which buttons were pressed since last time
;*                       this routine was called
;*
;***************************************************************************
pad_Read::
        ld      a,P1F_5
        ld      [rP1],a        ;turn on P15

        ld      a,[rP1]        ;delay
        ld      a,[rP1]
	cpl
        and     $0f
	swap	a
	ld	b,a

        ld      a,P1F_4
        ld      [rP1],a     ;turn on P14
        ld      a,[rP1]     ;delay
        ld      a,[rP1]
        ld      a,[rP1]
        ld      a,[rP1]
        ld      a,[rP1]
        ld      a,[rP1]
	cpl
        and     $0f
	or	b
        ld      b,a

	ld	a,[_PadData]
	xor	a,b
	and	a,b
	ld	[_PadDataEdge],a
	ld	a,b
	ld	[_PadData],a
        push    af

	ld	a,P1F_5|P1F_4
        ld      [rP1],a

        ld      a,[_PadDataEdge]
        ld      b,a
        pop     af
	ld [buttons_input],a
	ret




