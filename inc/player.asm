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
	push af
	ld a,[player_moving]
	ld b,0
	cp b
	jr z,.buttons
	jr nz,.move
.buttons:
	call check_buttons
	jr .end
.move:
	call perform_movement
.end:
	pop af
	ret
	
check_buttons:
	push af
	ld a,[buttons_input]
	and	PADF_RIGHT
	call	nz,button_right
	pop	af
	push	af
	ld a,[buttons_input]
	and	PADF_LEFT
	call	nz,button_left
	pop	af
	push	af
	ld a,[buttons_input]
	and	PADF_UP
	call	nz,button_up
	pop	af
	push	af
	ld a,[buttons_input]
	and	PADF_DOWN
	call	nz,button_down
	pop	af
	ret
	
perform_movement:
	push af
	ld a,[move_direction]
	cp PADF_RIGHT
	jp z,.move_right
	cp PADF_LEFT
	jp z,.move_left
	cp PADF_UP
	jp z,.move_up
	cp PADF_DOWN
	jp z,.move_down
.move_right:
	GetSpriteXAddr	Sprite3
	inc a
	ld b,a
	sub 8
	ld c,a
	ld a,b
	PutSpriteXAddr	Sprite3,a
	PutSpriteXAddr	Sprite2,a
	PutSpriteXAddr	Sprite0,c
	PutSpriteXAddr	Sprite1,c
	and 256-16
	cp b
	jp z,.finish_movement
	jp nz,.end
.move_left:
	GetSpriteXAddr	Sprite3
	dec a
	ld b,a
	sub 8
	ld d,a
	ld a,b
	PutSpriteXAddr	Sprite3,a
	PutSpriteXAddr	Sprite2,a
	PutSpriteXAddr	Sprite0,d
	PutSpriteXAddr	Sprite1,d
	and 256-16
	cp b
	jp z,.finish_movement
	jp nz,.end
.move_down:
	GetSpriteYAddr	Sprite3
	inc a
	ld c,a
	sub 8
	ld d,a
	ld a,c
	PutSpriteYAddr	Sprite3,a
	PutSpriteYAddr	Sprite1,a
	PutSpriteYAddr	Sprite0,d
	PutSpriteYAddr	Sprite2,d
	and 256-16
	cp c
	jp z,.finish_movement
	jp nz,.end
.move_up:
	GetSpriteYAddr	Sprite3
	dec a
	ld c,a
	sub 8
	ld d,a
	ld a,c
	PutSpriteYAddr	Sprite3,a
	PutSpriteYAddr	Sprite1,a
	PutSpriteYAddr	Sprite0,d
	PutSpriteYAddr	Sprite2,d
	and 256-16
	cp c
	jp z,.finish_movement
	jp nz,.end	
.finish_movement
	ld a,0
	ld [player_moving],a
.end
	pop af
	ret
	
button_right:
	push af
	ld a,PADF_RIGHT
	ld [move_direction],a
	ld a,1
	ld [player_moving],a
	xor a
	pop af
	ret
	
button_left:
	push af
	ld a,PADF_LEFT
	ld [move_direction],a
	ld a,1
	ld [player_moving],a
	xor a
	pop af
	ret	
	
button_up:
	push af
	ld a,PADF_UP
	ld [move_direction],a
	ld a,1
	ld [player_moving],a
	xor a
	pop af
	ret
	
button_down:
	push af
	ld a,PADF_DOWN
	ld [move_direction],a
	ld a,1
	ld [player_moving],a
	xor a
	pop af
	ret
	
AnimatePlayer::
	push af
	ld a,[player_moving]
	ld b,0
	cp b
	jp z,.first_frame
	ld a,[last_vblank_count]
	ld b,a
	ld a,[vblank_count]
	cp b
	jr z,.end
	ld b,a
	and 256-4
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
