INCLUDE "inc/player.inc"
INCLUDE "inc/sprite.inc"
INCLUDE "inc/vars.inc"
INCLUDE "inc/hardware.inc"

SECTION "Player code", HOME

PlayerInit::
	push af
	PutSpriteYAddr	Sprite0,8*5	; ustaw pozycje kafelka Sprite0 w 0,0
	PutSpriteXAddr	Sprite0,8*5
 	ld	a,$13						; ustaw w A numer kafelka
 	ld 	[Sprite0TileNum],a      ; zapisz wartosc A pod adresem Sprite0TileNum
 	ld	a,%00000000         	; ustaw flagi dla kafelka Sprite0
 	ld	[Sprite0Flags],a        ; zapisz flagi pod adresem Sprite0Flags
	
	PutSpriteYAddr	Sprite1,8*6
	PutSpriteXAddr	Sprite1,8*5
	ld	a,$15
	ld	[Sprite1TileNum],a
	ld	a,%00000000
	ld	[Sprite1Flags],a
	
	PutSpriteYAddr	Sprite2,8*5
	PutSpriteXAddr	Sprite2,8*6
	ld	a,$14
	ld	[Sprite2TileNum],a
	ld	a,%00000000
	ld	[Sprite2Flags],a
	
	PutSpriteYAddr	Sprite3,8*6
	PutSpriteXAddr	Sprite3,8*6
	ld	a,$16
	ld	[Sprite3TileNum],a
	ld	a,%00000000
	ld	[Sprite3Flags],a
	pop af
	ret

PlayerMovement::
	push	af
	and	PADF_RIGHT
	call	nz,move_right
	pop	af
	push	af
	and	PADF_LEFT
	call	nz,move_left
	pop	af
	push	af
	and	PADF_UP
	call	nz,move_up
	pop	af
	push	af
	and	PADF_DOWN
	call	nz,move_down
	pop	af
	ret
	
move_right:
	ld [move_direction],a
	GetSpriteXAddr	Sprite0
	cp		SCRN_X-8	; already on RHS of screen?
	ret		z
	inc		a
	PutSpriteXAddr	Sprite0,a
	PutSpriteXAddr	Sprite1,a
	ld b,8
	add a,b
	PutSpriteXAddr	Sprite2,a
	PutSpriteXAddr	Sprite3,a
	ret
move_left:
	ld [move_direction],a
	GetSpriteXAddr	Sprite0
	cp		0		; already on LHS of screen?
	ret		z
	dec		a
	PutSpriteXAddr	Sprite0,a
	PutSpriteXAddr	Sprite1,a
	ld b,8
	add a,b
	PutSpriteXAddr	Sprite2,a
	PutSpriteXAddr	Sprite3,a
	ret	
move_up:
	ld [move_direction],a
	GetSpriteYAddr	Sprite0
	cp		0		; already at top of screen?
	ret		z
	dec		a
	PutSpriteYAddr	Sprite0,a
	PutSpriteYAddr	Sprite2,a
	ld b,8
	add a,b
	PutSpriteYAddr	Sprite1,a
	PutSpriteYAddr	Sprite3,a
	ret
move_down:
	ld [move_direction],a
	GetSpriteYAddr	Sprite0
	cp		SCRN_Y-8	; already at bottom of screen?
	ret		z
	inc		a
	PutSpriteYAddr	Sprite0,a
	PutSpriteYAddr	Sprite2,a
	ld b,8
	add a,b
	PutSpriteYAddr	Sprite1,a
	PutSpriteYAddr	Sprite3,a
	ret
	
AnimatePlayer::
	push af
	ld a,[last_vblank_count]
	ld b,a
	ld a,[vblank_count]
	cp b
	jr z,.end
	ld b,a
	and 256-8
	cp b
	jr nz,.end
	ld a,[Sprite0TileNum]
	add a,4
	ld b,$1f
	cp b
	jr nz,.next_frame
	jr z,.first_frame
.next_frame:
	ld [Sprite0TileNum],a
	inc a
	ld [Sprite2TileNum],a
	inc a
	ld [Sprite1TileNum],a
	inc a
	ld [Sprite3TileNum],a
	jr .end
.first_frame:
	ld a,$13
	ld [Sprite0TileNum],a
	ld a,$14
	ld [Sprite2TileNum],a
	ld a,$15
	ld [Sprite1TileNum],a
	ld a,$16
	ld [Sprite3TileNum],a
.end:
	pop af
	ret
