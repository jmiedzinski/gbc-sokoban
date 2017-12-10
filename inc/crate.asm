INCLUDE "inc/crate.inc"
INCLUDE "inc/sprite.inc"
INCLUDE "inc/vars.inc"
INCLUDE "inc/hardware.inc"
INCLUDE "res/map1.inc"

SECTION "Crate code", HOME

InitCrates::
	push af
	
    PutSpriteXAddr  Crate0_0,1*8
    PutSpriteYAddr  Crate0_0,1*8
    PutSpriteXAddr  Crate0_1,1*8
    PutSpriteYAddr  Crate0_1,2*8
    PutSpriteXAddr  Crate0_2,2*8
    PutSpriteYAddr  Crate0_2,1*8
    PutSpriteXAddr  Crate0_3,2*8
    PutSpriteYAddr  Crate0_3,2*8
    ld  a,$b0
    ld  [Crate0_0TileNum],a
    ld  a,$b1
    ld  [Crate0_1TileNum],a
    ld  a,$b2
    ld  [Crate0_2TileNum],a
    ld  a,$b3
    ld  [Crate0_3TileNum],a
    ld  a,%00000000
    ld  [Crate0_0Flags],a
	ld  [Crate0_1Flags],a
	ld  [Crate0_2Flags],a
	ld  [Crate0_3Flags],a
	
	pop af
	ret
	
DrawCrates::
	push af
	
    PutSpriteXAddr  Crate0_0,1*8
    PutSpriteYAddr  Crate0_0,1*8
    PutSpriteXAddr  Crate0_1,1*8
    PutSpriteYAddr  Crate0_1,2*8
    PutSpriteXAddr  Crate0_2,2*8
    PutSpriteYAddr  Crate0_2,1*8
    PutSpriteXAddr  Crate0_3,2*8
    PutSpriteYAddr  Crate0_3,2*8
    ld  a,$b0
    ld  [Crate0_0TileNum],a
    ld  a,$b1
    ld  [Crate0_1TileNum],a
    ld  a,$b2
    ld  [Crate0_2TileNum],a
    ld  a,$b3
    ld  [Crate0_3TileNum],a
	
	pop af
	ret
