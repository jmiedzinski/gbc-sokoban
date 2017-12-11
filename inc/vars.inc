
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
GLOBAL player_animating
GLOBAL steps_count

GLOBAL PlayerPosX
GLOBAL PlayerPosY
GLOBAL PlayerFrame
GLOBAL PlayerFlags

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

GLOBAL Crate0PosX
GLOBAL Crate0PosY
GLOBAL Crate0Frame
GLOBAL Crate0Flags

GLOBAL Crate1PosX
GLOBAL Crate1PosY
GLOBAL Crate1Frame
GLOBAL Crate1Flags

GLOBAL Crate2PosX
GLOBAL Crate2PosY
GLOBAL Crate2Frame
GLOBAL Crate2Flags

GLOBAL Crate0_0YAddr
GLOBAL Crate0_0XAddr
GLOBAL Crate0_0TileNum
GLOBAL Crate0_0Flags

GLOBAL Crate0_1YAddr
GLOBAL Crate0_1XAddr
GLOBAL Crate0_1TileNum
GLOBAL Crate0_1Flags

GLOBAL Crate0_2YAddr
GLOBAL Crate0_2XAddr
GLOBAL Crate0_2TileNum
GLOBAL Crate0_2Flags

GLOBAL Crate0_3YAddr
GLOBAL Crate0_3XAddr
GLOBAL Crate0_3TileNum
GLOBAL Crate0_3Flags

GLOBAL Crate1_0YAddr
GLOBAL Crate1_0XAddr
GLOBAL Crate1_0TileNum
GLOBAL Crate1_0Flags

GLOBAL Crate1_1YAddr
GLOBAL Crate1_1XAddr
GLOBAL Crate1_1TileNum
GLOBAL Crate1_1Flags

GLOBAL Crate1_2YAddr
GLOBAL Crate1_2XAddr
GLOBAL Crate1_2TileNum
GLOBAL Crate1_2Flags

GLOBAL Crate1_3YAddr
GLOBAL Crate1_3XAddr
GLOBAL Crate1_3TileNum
GLOBAL Crate1_3Flags

GLOBAL Crate2_0YAddr
GLOBAL Crate2_0XAddr
GLOBAL Crate2_0TileNum
GLOBAL Crate2_0Flags

GLOBAL Crate2_1YAddr
GLOBAL Crate2_1XAddr
GLOBAL Crate2_1TileNum
GLOBAL Crate2_1Flags

GLOBAL Crate2_2YAddr
GLOBAL Crate2_2XAddr
GLOBAL Crate2_2TileNum
GLOBAL Crate2_2Flags

GLOBAL Crate2_3YAddr
GLOBAL Crate2_3XAddr
GLOBAL Crate2_3TileNum
GLOBAL Crate2_3Flags

ENDC