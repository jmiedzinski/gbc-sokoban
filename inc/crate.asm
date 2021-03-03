INCLUDE "inc/crate.inc"
INCLUDE "inc/sprite.inc"
INCLUDE "inc/vars.inc"
INCLUDE "inc/hardware.inc"
INCLUDE "res/map1.inc"

SECTION "Crate code", ROMX

InitCrates::
	push af
	
	SetCratePosX	Crate0,6*8
	SetCratePosY	Crate0,25*8
	
	SetCratePosX	Crate1,14*8
	SetCratePosY	Crate1,16*8
	
    PutSpriteXAddr  Crate0_0,5*8
    PutSpriteYAddr  Crate0_0,24*8
    PutSpriteXAddr  Crate0_1,5*8
    PutSpriteYAddr  Crate0_1,25*8
    PutSpriteXAddr  Crate0_2,6*8
    PutSpriteYAddr  Crate0_2,24*8
    PutSpriteXAddr  Crate0_3,6*8
    PutSpriteYAddr  Crate0_3,25*8
	
    PutSpriteXAddr  Crate1_0,13*8
    PutSpriteYAddr  Crate1_0,15*8
    PutSpriteXAddr  Crate1_1,13*8
    PutSpriteYAddr  Crate1_1,16*8
    PutSpriteXAddr  Crate1_2,14*8
    PutSpriteYAddr  Crate1_2,15*8
    PutSpriteXAddr  Crate1_3,14*8
    PutSpriteYAddr  Crate1_3,16*8
	
    ld  a,$b0
    ld  [Crate0_0TileNum],a
    ld  [Crate1_0TileNum],a
    ld  a,$b1
    ld  [Crate0_1TileNum],a
    ld  [Crate1_1TileNum],a	
    ld  a,$b2
    ld  [Crate0_2TileNum],a
    ld  [Crate1_2TileNum],a	
    ld  a,$b3
    ld  [Crate0_3TileNum],a
	ld  [Crate1_3TileNum],a
    ld  a,%00000000
    ld  [Crate0_0Flags],a
	ld  [Crate0_1Flags],a
	ld  [Crate0_2Flags],a
	ld  [Crate0_3Flags],a
    ld  [Crate1_0Flags],a
	ld  [Crate1_1Flags],a
	ld  [Crate1_2Flags],a
	ld  [Crate1_3Flags],a
	
	pop af
	ret
	
DrawCrates::
	push af
	push bc
	push de
;	calculating current crate0 position according to scroll values	
	ld a,[rSCX]
	ld b,a
	GetCratePosX Crate0
	sub b
	ld b,a
	ld a,[rSCY]
	ld c,a
	GetCratePosY Crate0
	sub c
	ld c,a
	ld a,b
;	placing the crate sprites to calculated position	
    PutSpriteXAddr  Crate0_3,a
    PutSpriteYAddr  Crate0_3,c
    PutSpriteYAddr  Crate0_1,c
    PutSpriteXAddr  Crate0_2,a
	ld a,c
	sub 8
	ld c,a
	ld a,b
	sub 8
    PutSpriteXAddr  Crate0_0,a
    PutSpriteYAddr  Crate0_0,c
    PutSpriteXAddr  Crate0_1,a
    PutSpriteYAddr  Crate0_2,c
;	calculating current crate1 position according to scroll values	
	ld a,[rSCX]
	ld b,a
	GetCratePosX Crate1
	sub b
	ld b,a
	ld a,[rSCY]
	ld c,a
	GetCratePosY Crate1
	sub c
	ld c,a
	ld a,b
;	placing the crate sprites to calculated position	
    PutSpriteXAddr  Crate1_3,a
    PutSpriteYAddr  Crate1_3,c
    PutSpriteYAddr  Crate1_1,c
    PutSpriteXAddr  Crate1_2,a
	ld a,c
	sub 8
	ld c,a
	ld a,b
	sub 8
    PutSpriteXAddr  Crate1_0,a
    PutSpriteYAddr  Crate1_0,c
    PutSpriteXAddr  Crate1_1,a
    PutSpriteYAddr  Crate1_2,c
	pop de
	pop bc
	pop af
	ret
