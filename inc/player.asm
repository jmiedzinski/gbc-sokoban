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
	ld h,a
	cp PADF_RIGHT
	jr z,.is_right
	cp PADF_LEFT
	jr z,.is_left
	cp PADF_UP
	jr z,.is_up
	cp PADF_DOWN
	jr z,.is_down
.is_right:
	GetSpriteXAddr	Sprite3
	inc a
	ld b,a
	PutSpriteXAddr	Sprite3,a
	and 256-8
	cp b
	jr z,.finish_movement
	jr nz,.end
.is_left:
	GetSpriteXAddr	Sprite3
	dec a
	ld b,a
	PutSpriteXAddr	Sprite3,a
	and 256-8
	cp b
	jr z,.finish_movement
	jr nz,.end
.is_down:
	GetSpriteYAddr	Sprite3
	inc a
	ld c,a
	PutSpriteYAddr	Sprite3,a
	and 256-8
	cp c
	jr z,.finish_movement
	jr nz,.end
.is_up:
	GetSpriteYAddr	Sprite3
	dec a
	ld c,a
	PutSpriteYAddr	Sprite3,a
	and 256-8
	cp c
	jr z,.finish_movement
	jr nz,.end	
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
