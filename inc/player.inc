IF !DEF (PLAYER_INC)
PLAYER_INC SET 1

ANIM_DOWN_START			EQU $80
ANIM_DOWN_STOP			EQU $8c
ANIM_LEFT_START			EQU $8c
ANIM_LEFT_STOP			EQU $98
ANIM_RIGHT_START		EQU $98
ANIM_RIGHT_STOP			EQU $a4
ANIM_UP_START			EQU $a4
ANIM_UP_STOP			EQU $b0

PLAYER_SIZE				EQU 16

PlayerAttr:     MACRO
\1PosX::           	DS  1
\1PosY::           	DS  1
\1Frame::         	DS  1
\1Flags::          	DS  1
                ENDM
				
SetPlayerPosX: MACRO
                push af
                ld  a,\2
                ld [\1PosX],a
                pop af
                ENDM
				
SetPlayerPosY: MACRO
                push af
                ld  a,\2
                ld [\1PosY],a
                pop af
               ENDM
				
GetPlayerPosX: MACRO
				ld a,[\1PosX]
			   ENDM
			   
GetPlayerPosY: MACRO
				ld a,[\1PosY]
			   ENDM

GLOBAL PlayerInit
GLOBAL PlayerMovement
GLOBAL AnimatePlayer

ENDC