IF !DEF (CRATE_INC)
CRATE_INC SET 1

CrateAttr:     MACRO
\1PosX::           	DS  1
\1PosY::           	DS  1
\1Frame::         	DS  1
\1Flags::          	DS  1
                ENDM
				
SetCratePosX: MACRO
                push af
                ld  a,\2
                ld [\1PosX],a
                pop af
                ENDM
				
SetCratePosY: MACRO
                push af
                ld  a,\2
                ld [\1PosY],a
                pop af
               ENDM
				
GetCratePosX: MACRO
				ld a,[\1PosX]
			   ENDM
			   
GetCratePosY: MACRO
				ld a,[\1PosY]
			   ENDM

GLOBAL InitCrates
GLOBAL DrawCrates
			   
ENDC