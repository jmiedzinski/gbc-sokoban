
; --- vars.inc ------------------------------------------------------------

IF !DEF (__vars)
__vars SET 1

debug_log:	MACRO
	push af
	ld d,d              	; first ID (opcode 52h)
	jr .debug_end\@      	; relative jump, skips message, this also defines the length of following data!
	DB "dd"            		; second ID (ascii 'dd')
	DS 1                	; reserved for flags
	DB "."
	DB \1   				; user defined ascii data (max length 120 bytes)
.debug_end\@:
	pop af
			ENDM
			
TMA_MOD_16HZ	EQU 0
MAP_PLANES_OFFSET	EQU $400

GLOBAL timer_overflow_count
GLOBAL vblank_count
GLOBAL last_vblank_count
GLOBAL seconds_passed
GLOBAL player_moving
GLOBAL move_direction
GLOBAL buttons_input
GLOBAL curr_anim_first_frame
GLOBAL curr_anim_last_frame
GLOBAL collision

GLOBAL Sprite0YAddr
GLOBAL Sprite0XAddr
GLOBAL Sprite0TileNum
GLOBAL Sprite0Flags

GLOBAL Sprite1YAddr
GLOBAL Sprite1XAddr
GLOBAL Sprite1TileNum
GLOBAL Sprite1Flags

GLOBAL Sprite2YAddr
GLOBAL Sprite2XAddr
GLOBAL Sprite2TileNum
GLOBAL Sprite2Flags

GLOBAL Sprite3YAddr
GLOBAL Sprite3XAddr
GLOBAL Sprite3TileNum
GLOBAL Sprite3Flags

ENDC