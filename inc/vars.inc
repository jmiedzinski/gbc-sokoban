
; --- vars.inc ------------------------------------------------------------

IF !DEF (__vars)
__vars SET 1

TMA_MOD_16HZ	EQU 0

GLOBAL timer_overflow_count
GLOBAL vblank_count
GLOBAL last_vblank_count
GLOBAL seconds_passed
GLOBAL player_moving
GLOBAL move_direction
GLOBAL buttons_input
GLOBAL curr_anim_first_frame
GLOBAL curr_anim_last_frame

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