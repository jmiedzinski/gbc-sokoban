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
	ld a,[player_moving]			; sprawdz czy postac jest w ruchu (player_moving <> 0)
	ld b,0
	cp b
	jr z,.buttons					; jesli postac nie jest w ruchu to zczytaj guziki
	jr nz,.move						; jesli postac JEST w ruchu to kontynuuj
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
	ld a,[buttons_input]			; zaladuj rejestr guzikow (zapisany do zmiennej buttons_input w sokoban.asm:104)
	and	PADF_RIGHT					; porownaj ze stanem dla guzika RIGHT
	call	nz,button_right			; skocz do obslugi ruchu w prawo
	pop	af
	push	af
	ld a,[buttons_input]			; analogicznie jak powyzej, ale dla guzika LEFT
	and	PADF_LEFT
	call	nz,button_left
	pop	af
	push	af
	ld a,[buttons_input]			; analogicznie jak powyzej, ale dla guzika UP
	and	PADF_UP
	call	nz,button_up
	pop	af
	push	af
	ld a,[buttons_input]			; analogicznie jak powyzej, ale dla guzika DOWN
	and	PADF_DOWN
	call	nz,button_down
	pop	af
	ret
	
perform_movement:					; wykonanie ruchu postaci w zaleznosci od kierunku
	push af
	ld a,[move_direction]			; zaladuj kierunek ze zmiennej move_direction, sprawdz i skocz do obslugi odpowiedniego kierunku
	cp PADF_RIGHT
	jp z,.move_right
	cp PADF_LEFT
	jp z,.move_left
	cp PADF_UP
	jp z,.move_up
	cp PADF_DOWN
	jp z,.move_down
.move_right:						; w prawo: przesun wszystkie sprite'y o 1 w prawo i sprawdz czy nie sa juz w docelowym miejscu
	GetSpriteXAddr	Sprite3
	inc a							; dodaj 1 do biezace wspolrzednej X sprite'a
	ld b,a							; skopiuj do B
	sub 8							; odejmij 8 od biezacej wspolrzednej X sprite'a
	ld c,a							; zapisz do C
	ld a,b							; przywroc wartosc A sprzed odejmowania
	PutSpriteXAddr	Sprite3,a		; ustaw nowa wspolrzedna dla sprite'ow (Sprite0 i Sprite1 sa przesuniete o -8)
	PutSpriteXAddr	Sprite2,a
	PutSpriteXAddr	Sprite0,c
	PutSpriteXAddr	Sprite1,c
	and 256-16
	cp b
	jp z,.finish_movement			; jesli pozycja po przesunieciu o 1 dzieli sie bez reszty przez 16 to znaczy, ze trzeba zakonczyc ruch 
	jp nz,.end						; w przeciwnym wypadku po prostu zakoncz procedure bez zmiany flagi player_moving
.move_left:							; analogicznie jak move_right tyle ze przesuwamy sie w lewo a wiec odejmujemy 1 od biezacej wspolrzednej X
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
.move_down:							; analogicznie jak move_right tyle ze operujemy na wspolrzednej Y
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
.move_up:							; analogicznie jak w move_left tyle ze operujemy na wspolrzednej Y
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
.finish_movement					; koniec ruchu - ustaw flage player_moving = 0
	ld a,0
	ld [player_moving],a
.end
	pop af
	ret
	
button_right:						; obsluga ruchu w prawo
	push af
	ld a,PADF_RIGHT					; zapisz kierunek do zmiennej [move_direction]
	ld [move_direction],a
	ld a,1
	ld [player_moving],a			; ustaw flage ruchu na 1 [player_moving]
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
	
AnimatePlayer::						; animacja postaci gracza
	push af
	ld a,[player_moving]			; sprawdz czy postac w trakcie ruchu
	ld b,0
	cp b
	jp z,.first_frame				; jesli nie, to ustaw sprite'y dla pierwszej klatki animacji
	ld a,[last_vblank_count]		; sprawdz czy nie jestesmy w tym samym vblanku
	ld b,a
	ld a,[vblank_count]
	cp b
	jr z,.end						; jesli jestesmy to zakoncz
	ld b,a
	and 256-4						; zmieniamy klatke animacji co 4 vblanki
	cp b
	jr nz,.end						; jesli jestesmy w n % 4 =0 vblanku to
	ld a,[Sprite0TileNum]
	add a,4							; zobacz czy mamy kolejna klatke do animacji
	ld b,$1f
	cp b
	jr nz,.next_frame				; jesli mamy to ustaw ja dla wszystkich 4 sprite'ow
	jr z,.first_frame				; jesli nie mamy to wroc do klatki 0 (dla wszystkich 4 sprite'ow)
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
