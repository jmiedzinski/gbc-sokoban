INCLUDE "inc/player.inc"
INCLUDE "inc/sprite.inc"
INCLUDE "inc/vars.inc"
INCLUDE "inc/hardware.inc"
INCLUDE "res/map1.inc"

SECTION "Player code", HOME

PlayerInit::
    push af
    PutSpriteYAddr  Sprite0,8*4     ; ustaw pozycje kafelka Sprite0 w 0,0
    PutSpriteXAddr  Sprite0,8*3
    ld  a,ANIM_DOWN_START       ; ustaw w A numer kafelka
    ld  [Sprite0TileNum],a          ; zapisz wartosc A pod adresem Sprite0TileNum
    ld  a,%00000000                 ; ustaw flagi dla kafelka Sprite0
    ld  [Sprite0Flags],a            ; zapisz flagi pod adresem Sprite0Flags
    
    PutSpriteYAddr  Sprite1,8*5
    PutSpriteXAddr  Sprite1,8*3
    ld  a,ANIM_DOWN_START+1
    ld  [Sprite1TileNum],a
    ld  a,%00000000
    ld  [Sprite1Flags],a
    
    PutSpriteYAddr  Sprite2,8*4
    PutSpriteXAddr  Sprite2,8*4
    ld  a,ANIM_DOWN_START+2
    ld  [Sprite2TileNum],a
    ld  a,%00000000
    ld  [Sprite2Flags],a
    
    PutSpriteYAddr  Sprite3,8*5
    PutSpriteXAddr  Sprite3,8*4
    ld  a,ANIM_DOWN_START+3
    ld  [Sprite3TileNum],a
    ld  a,%00000000
    ld  [Sprite3Flags],a
    
    ld a,ANIM_DOWN_START
    ld [curr_anim_first_frame],a
    ld a,ANIM_DOWN_STOP
    ld [curr_anim_last_frame],a
	
	SetPlayerPosX	Player,8*5
	SetPlayerPosY	Player,8*4
    
    pop af
    ret

PlayerMovement::
    push af
    xor a
    ld [collision],a
    push bc
    ld a,[player_moving]            ; sprawdz czy postac jest w ruchu (player_moving <> 0)
    ld b,0
    cp b
    jr z,.buttons                   ; jesli postac nie jest w ruchu to zczytaj guziki
    jr nz,.move                     ; jesli postac JEST w ruchu to kontynuuj
.buttons:
    call check_buttons
    jr .end
.move:
    call perform_movement
.end:
    pop bc
    pop af
    ret
    
check_buttons:
    push af
    ld a,[buttons_input]            ; zaladuj rejestr guzikow (zapisany do zmiennej buttons_input w sokoban.asm:104)
    and PADF_RIGHT                  ; porownaj ze stanem dla guzika RIGHT
    call    nz,button_right         ; skocz do obslugi ruchu w prawo
    pop af
    push    af
    ld a,[buttons_input]            ; analogicznie jak powyzej, ale dla guzika LEFT
    and PADF_LEFT
    call    nz,button_left
    pop af
    push    af
    ld a,[buttons_input]            ; analogicznie jak powyzej, ale dla guzika UP
    and PADF_UP
    call    nz,button_up
    pop af
    push    af
    ld a,[buttons_input]            ; analogicznie jak powyzej, ale dla guzika DOWN
    and PADF_DOWN
    call    nz,button_down
    pop af
    ret
    
perform_movement:                   ; wykonanie ruchu postaci w zaleznosci od kierunku
    push af
    push bc
	push hl
    ld a,[move_direction]           ; zaladuj kierunek ze zmiennej move_direction, sprawdz i skocz do obslugi odpowiedniego kierunku
    cp PADF_RIGHT
    jp z,.move_right
    cp PADF_LEFT
    jp z,.move_left
    cp PADF_UP
    jp z,.move_up
    cp PADF_DOWN
    jp z,.move_down
.move_right:                        ; w prawo: przesun wszystkie sprite'y o 1 w prawo i sprawdz czy nie sa juz w docelowym miejscu
    GetSpriteXAddr  Sprite3
    inc a                           ; dodaj 1 do biezace wspolrzednej X sprite'a
    ld b,a                          ; skopiuj do B
    sub 8                           ; odejmij 8 od biezacej wspolrzednej X sprite'a
    ld c,a                          ; zapisz do C
    ld a,b                          ; przywroc wartosc A sprzed odejmowania
    call check4coll_right
    ld a,[collision]
    ld e,1
    cp e
    jp z,.finish_movement\@
    ld a,b
    call set_player_position_x
    and 256-16
    cp b
    jp z,.finish_movement\@         ; jesli pozycja po przesunieciu o 1 dzieli sie bez reszty przez 16 to znaczy, ze trzeba zakonczyc ruch 
    jp nz,.end\@                    ; w przeciwnym wypadku po prostu zakoncz procedure bez zmiany flagi player_moving
.move_left:                         ; analogicznie jak move_right tyle ze przesuwamy sie w lewo a wiec odejmujemy 1 od biezacej wspolrzednej X
    GetSpriteXAddr  Sprite3
    dec a
    ld b,a
    sub 8
    ld c,a
    ld a,b
    call check4coll_left
    ld a,[collision]
    ld e,1
    cp e
    jp z,.finish_movement\@
    ld a,b
    call set_player_position_x
    and 256-16
    cp b
    jp z,.finish_movement\@
    jp nz,.end\@
.move_down:                         ; analogicznie jak move_right tyle ze operujemy na wspolrzednej Y
    GetPlayerPosY  Player
    inc a
    ld b,a
    sub 8
    ld c,a
    ld a,b
    call check4coll_down
    ld a,[collision]
    ld e,1
    cp e
    jp z,.finish_movement\@
    ld a,b
    call scroll_or_move_down
    and 256-16
    cp c
    jp z,.finish_movement\@
    jp nz,.end\@
.move_up:                           ; analogicznie jak w move_left tyle ze operujemy na wspolrzednej Y
    GetPlayerPosY  Player
    dec a
    ld b,a
    sub 8
    ld c,a
    ld a,b
    call check4coll_up
    ld a,[collision]
    ld e,1
    cp e
    jp z,.finish_movement\@
    ld a,b
    call scroll_or_move_up
    and 256-16
    cp c
    jp z,.finish_movement\@
    jp nz,.end\@    
.finish_movement\@:                 ; koniec ruchu - ustaw flage player_moving = 0
    ld a,0
    ld [player_moving],a
    ld [player_animating],a
    ld a,[rSCX]
    ld b,a
    ld a,[rSCY]
    ld c,a
    GetSpriteXAddr  Sprite3
    ld d,a
    GetSpriteYAddr  Sprite3
    ld e,a
	GetPlayerPosX	Player
	ld h,a
	GetPlayerPosY	Player
	ld l,a
    debug_log "scrollX=%b% spriteX=%d% playerX=%h% scrollY=%c% spriteY=%e% playerY=%l%"
.end\@:
	pop hl
    pop bc
    pop af
    ret

;******************************************************************************
;*      Move player sprites down the screen or scroll down the map
;*		using [rSCY] register
;*
;*      input:
;*          a - y coordinate of the player
;*
;*      output:
;*          none
;*
;******************************************************************************    
scroll_or_move_down:
    push af
    push bc
	push de
    ld b,a              		; save player centerY in b
    sbc a,$48
    jp c,.move_sprites\@        ; if player centerY < $48 then move sprites (carry flag set)
    ld a,[rSCY]
    sbc a,$70
    jp nc,.move_sprites\@       ; if scroll Y coordinate > $70 then move sprites (carry flag unset)
    ld a,[rSCY]
    inc a
    ld [rSCY],a					; increment value of the [rSCY] register by 1
	jp .end\@
.move_sprites\@:
	ld a,b
	jp c,.without_sub\@			; carry flag set - we know that we're _before_ scrolling
	sub $70						; else: we know we're _after_ scrolling, so we need substract $70
	ld d,a						; from player posY and then use it to move sprites (both a and c registers)
	ld a,c
	sub $70
	ld c,a
	ld a,d
.without_sub\@:
	call set_player_position_y
.end\@:
	ld a,b
	SetPlayerPosY	Player,a
	pop de
    pop bc
    pop af
    ret

;******************************************************************************
;*      Move player sprites up the screen or scroll map
;*
;*      input:
;*          a - y coordinate of the player
;*
;*      output:
;*          none
;*
;******************************************************************************    
scroll_or_move_up:
    push af
    push bc
	push de
    ld b,a              		; save player centerX in b
	ld a,[rSCY]
    sbc a,$70
    jp nc,.move_sprites\@       ; if scroll Y coordinate > $70 then move sprites (carry flag unset)
	ld a,b
    sbc a,$48
    jp c,.move_sprites\@     	; if player centerY < $48 then move sprites (carry flag set)
    ld a,[rSCY]
    dec a
	ld e,$FF
	cp e
	jr nz,.keep_scrolling\@		; otherwise keep scrolling up
	ld a,0
	jp .move_sprites\@
.keep_scrolling\@:
    ld [rSCY],a					; by decrementing [rSCY] register by 1
	jp .end\@
.move_sprites\@:
	ld a,b
	call set_player_position_y
.end\@:
	ld a,b
	SetPlayerPosY	Player,a
	pop de
    pop bc
    pop af
    ret
    
;******************************************************************************
;*      Check underlying tile if it's blocking or non blocking. Tile data 
;*      is exported as Plane1. Plane1 is loaded into RAM under $C200.
;*      Formula to check that data is as follows:
;*      memory location = (x+rSCX)/8+((y+rSCY)/8)*SCRN_VY_B+$C200
;*
;*      input:
;*          hl - x,y coordinates of tile to check
;*
;*      output:
;*          b - 0/1 (non-blocking/blocking)
;*
;******************************************************************************
get_collision_data:
    push af
    push hl
    push de
    ld a,[rSCX]
    add h
    ld h,a                          ; h=x+rSCX
    ld a,[rSCY]
    add l
    ld l,a                          ; l=y+rSCY
    REPT    3                       ; divide b and c by 8
    srl h
    srl l
    ENDR                            ; h=(x+rSCX)/8, l=(y+rSCY)/8
    ld e,h
    ld h,0
    REPT 5
    sla l
    rl h
    ENDR
    ld d,0                          ; b=(x+rSCX)/8, c=((y+rSCY)/8) * 32
    add hl,de
    ld bc,$c200
    add hl,bc
    ld a,[hl]
    ld b,a
    pop de
    pop hl
    pop af
    ret

;******************************************************************************
;*      Checks for collision while moving down.
;*
;*      |---|---|   routine is taking x,y coords of tiles 1 and 3
;*      | 0 | 2 |   then adding 8 to y component and checking if this new 
;*      |---|---|   point (x,y+8) lays over blocking background tile.
;*      | 1 | 3 |   If yes then collision flag is set to 1.
;*      |---|---|
;*
;*      input: none
;*      output: none
;*
;****************************************************************************** 
check4coll_down:
    push af
    push bc
    push hl
    GetSpritePos Sprite1
    ld a,l
    add 8
    ld l,a
    call get_collision_data
    ld a,b
    ld c,1
    cp c
    jp z,.collision\@
    GetSpritePos Sprite3
    ld a,l
    add 8
    ld l,a
    call get_collision_data
    ld a,b
    ld c,1
    cp c
    jp nz,.end\@
.collision\@:
    ld a,1
    ld [collision],a
.end\@:
    pop hl
    pop bc
    pop af
    ret

;******************************************************************************
;*      Checks for collision while moving up.
;*
;*      |---|---|   routine is taking x,y coords of tiles 0 and 2
;*      | 0 | 2 |   then substracting 1 from y component and checking if this new 
;*      |---|---|   point (x,y-1) lays over blocking background tile.
;*      | 1 | 3 |   If yes then collision flag is set to 1.
;*      |---|---|
;*
;*      input: none
;*      output: none
;*
;****************************************************************************** 
check4coll_up:
    push af
    push bc
    push hl
    GetSpritePos Sprite0
    ld a,l
    dec a
    ld l,a
    call get_collision_data
    ld a,b
    ld c,1
    cp c
    jp z,.collision\@
    GetSpritePos Sprite2
    ld a,l
    dec a
    ld l,a
    call get_collision_data
    ld a,b
    ld c,1
    cp c
    jp nz,.end\@
.collision\@:
    ld a,1
    ld [collision],a
.end\@:
    pop hl
    pop bc
    pop af
    ret

;******************************************************************************
;*      Checks for collision while moving left.
;*
;*      |---|---|   routine is taking x,y coords of tiles 0 and 1
;*      | 0 | 2 |   then substracting 1 from x component and checking if this new 
;*      |---|---|   point (x-1,y) lays over blocking background tile.
;*      | 1 | 3 |   If yes then collision flag is set to 1.
;*      |---|---|
;*
;*      input: none
;*      output: none
;*
;******************************************************************************     
check4coll_left:
    push af
    push bc
    push hl
    GetSpritePos Sprite0
    ld a,h
    dec a
    ld h,a
    call get_collision_data
    ld a,b
    ld c,1
    cp c
    jp z,.collision\@
    GetSpritePos Sprite1
    ld a,h
    dec a
    ld h,a
    call get_collision_data
    ld a,b
    ld c,1
    cp c
    jp nz,.end\@
.collision\@:
    ld a,1
    ld [collision],a
.end\@:
    pop hl
    pop bc
    pop af
    ret

;******************************************************************************
;*      Checks for collision while moving right.
;*
;*      |---|---|   routine is taking x,y coords of tiles 2 and 3
;*      | 0 | 2 |   then adding 8 to x component and checking if this new 
;*      |---|---|   point (x+8,y) lays over blocking background tile.
;*      | 1 | 3 |   If yes then collision flag is set to 1.
;*      |---|---|
;*
;*      input: none
;*      output: none
;*
;******************************************************************************     
check4coll_right:
    push af
    push bc
    push hl
    GetSpritePos Sprite2
    ld a,h
    add 9
    ld h,a
    call get_collision_data
    ld a,b
    ld c,1
    cp c
    jp z,.collision\@
    GetSpritePos Sprite3
    ld a,h
    add 9
    ld h,a
    call get_collision_data
    ld a,b
    ld c,1
    cp c
    jp nz,.end\@
.collision\@:
    ld a,1
    ld [collision],a
.end\@:
    pop hl
    pop bc
    pop af
    ret
    
    
button_right:                       ; obsluga ruchu w prawo
    push af
    ld a,PADF_RIGHT                 ; zapisz kierunek do zmiennej [move_direction]
    ld [move_direction],a
    ld a,1
    ld [player_moving],a            ; ustaw flage ruchu na 1 [player_moving]
    ld [player_animating],a
    ld a,ANIM_RIGHT_START
    call set_animation_frame
    ld [curr_anim_first_frame],a
    ld a,ANIM_RIGHT_STOP
    ld [curr_anim_last_frame],a
    pop af
    ret
    
button_left:
    push af
    ld a,PADF_LEFT
    ld [move_direction],a
    ld a,1
    ld [player_moving],a
    ld [player_animating],a
    ld a,ANIM_LEFT_START
    call set_animation_frame
    ld [curr_anim_first_frame],a
    ld a,ANIM_LEFT_STOP
    ld [curr_anim_last_frame],a
    pop af
    ret 
    
button_up:
    push af
    ld a,PADF_UP
    ld [move_direction],a
    ld a,1
    ld [player_moving],a
    ld [player_animating],a
    ld a,ANIM_UP_START
    call set_animation_frame
    ld [curr_anim_first_frame],a
    ld a,ANIM_UP_STOP
    ld [curr_anim_last_frame],a
    pop af
    ret
    
button_down:
    push af
    ld a,PADF_DOWN
    ld [move_direction],a
    ld a,1
    ld [player_moving],a
    ld [player_animating],a
    ld a,ANIM_DOWN_START
    call set_animation_frame
    ld [curr_anim_first_frame],a
    ld a,ANIM_DOWN_STOP
    ld [curr_anim_last_frame],a
    pop af
    ret
    
set_player_position_x:
    push af
    push bc
    push de
    ld b,a
    ld a,[player_moving]
    ld d,0
    cp d
    jp z,.end\@
    ld a,b
    PutSpriteXAddr  Sprite0,c
    PutSpriteXAddr  Sprite1,c
    PutSpriteXAddr  Sprite2,a
    PutSpriteXAddr  Sprite3,a
.end\@:
    pop de
    pop bc
    pop af
    ret
    
set_player_position_y:
    push af
    push bc
    push de
    ld b,a
    ld a,[player_moving]
    ld d,0
    cp d
    jp z,.end\@
    ld a,b
    PutSpriteYAddr  Sprite0,c
    PutSpriteYAddr  Sprite1,a
    PutSpriteYAddr  Sprite2,c
    PutSpriteYAddr  Sprite3,a
.end\@:
    pop de
    pop bc
    pop af
    ret
    
set_animation_frame:
    ld [Sprite0TileNum],a
    inc a
    ld [Sprite1TileNum],a
    inc a
    ld [Sprite2TileNum],a
    inc a
    ld [Sprite3TileNum],a
    sub 3
    ret
    
AnimatePlayer::                     ; animacja postaci gracza
    push af
    push bc
    ld a,[player_animating]         ; sprawdz czy postac w trakcie ruchu
    ld b,0
    cp b
    jp z,.first_frame               ; jesli nie, to ustaw sprite'y dla pierwszej klatki animacji
    ld a,[last_vblank_count]        ; sprawdz czy nie jestesmy w tym samym vblanku
    ld b,a
    ld a,[vblank_count]
    cp b
    jp z,.end                       ; jesli jestesmy to zakoncz
    ld b,a
    and 256-4                       ; zmieniamy klatke animacji co 4 vblanki
    cp b
    jp nz,.end                      ; jesli nie jestesmy w n%4=0 vblanku to zakoncz
    ld a,[curr_anim_last_frame]
    ld c,a
    ld a,[Sprite0TileNum]
    add a,4                         ; zobacz czy mamy kolejna klatke do animacji
    cp c
    jp nz,.next_frame               ; jesli mamy to ustaw ja dla wszystkich 4 sprite'ow
    jp z,.first_frame               ; jesli nie mamy to wroc do klatki 0 (dla wszystkich 4 sprite'ow)
.next_frame:
    ld [Sprite0TileNum],a
    inc a
    ld [Sprite1TileNum],a
    inc a
    ld [Sprite2TileNum],a
    inc a
    ld [Sprite3TileNum],a
    jr .end
.first_frame:
    ld a,[curr_anim_first_frame]
    ld [Sprite0TileNum],a
    inc a
    ld [Sprite1TileNum],a
    inc a
    ld [Sprite2TileNum],a
    inc a
    ld [Sprite3TileNum],a
.end:
    pop bc
    pop af
    ret
