INCLUDE "inc/hardware.inc"					; definicje zmiennych sprzetowych i makra pomocnicze
INCLUDE "inc/fonts.inc"						; czcionka
INCLUDE "inc/vars.inc"						; moje zmienne w niskim RAM'ie
INCLUDE "inc/memory.inc"					; obsluga pamieci
INCLUDE "inc/sprite.inc"					; obsluga sprite'ow
INCLUDE "res/tiles.z80"
INCLUDE "res/map1.z80"
INCLUDE "inc/player.inc"

; IRQs
SECTION	"Vblank",HOME[$0040]
	jp draw
SECTION	"LCDC",HOME[$0048]
	jp stat
SECTION	"Timer_Overflow",HOME[$0050]
	jp timer
SECTION	"Serial",HOME[$0058]
	jp serial
SECTION	"p1thru4",HOME[$0060]
	jp joypad

SECTION "rom", HOME[$100]
	nop
	jp main

	ROM_HEADER	ROM_NOMBC,ROM_SIZE_32KBYTE,RAM_SIZE_0KBYTE

FontData:
	load_font 2,5		; makro ladujace do generatora znakow pelny zestaw

; $0150: Code!
main:

	ld sp,$ffff			; ustaw wskaznik stosu w najwyzszym miejcu pamieci
	
	di					; wylacz przerwania
	
	call initdma		; skopiuj obsluge sprite'ow do wysokiego RAM'u
	
	ld a,%00000101		; 00000101 - wlaczone tylko przerwania VBlank i Timer
	ld [rIE],a			; ustaw wartosc z A w rejestrze kontrolujacym wlaczenie przerwan rIE
	
	call StopLCD		; zawolaj procedure StopLCD (poprzez rejestr sterujacy rLCDC i w czasie VBlank)
	
	ld	a,TACF_START|TACF_4KHZ		; wlacz timer i ustaw czestotliwosc na 4096 Hz
	ld	[rTAC],a					; zaladuj ustawienia do rejestru sterujacego TAC
	ld	a,TMA_MOD_16HZ				; Ustaw zero w rTMA. Powinnismy dostac przerwanie timera 16/s
	ld	[rTMA],a

	ei					; wlacz przerwania
	
	ld	a,$e4
	ld	[rBGP],a        ; Ustaw domyslna palete tla (E4 hex, 11100100 bin) w rejestrze sterujacym rBGP
	ldh	[rOBP0],a		; set sprite pallette 0 (choose palette 0 or 1 when describing the sprite)
	ldh	[rOBP1],a		; set sprite pallette 1
	
	ld	a,0				; ustaw wartosc a = 0
	ld	[rSCX],a		; skopiuj wartosc a do rejestru scroll X dla ekranu
	ld	[rSCY],a		; skopiuj wartosc a do rejestru scroll Y dla ekranu
						; teraz rSCX i rSCY wskazuja na lewy gorny rog ekranu
						
	ld hl,MapData	 				; Ustaw adres TileMapLabel (pod ta nazwa jest wyexportowana mapa z edytora) w HL
	ld de, _SCRN0+0+(SCRN_VY_B*0)	; ustaw adres docelowy (row 0, col 0)
	ld bc, 32*32					; ustaw rozmiar mapy
	call mem_CopyVRAM				; DO THE MAGIC 

	ld	hl,FontData		; ustaw w HL adres zrodlowy (FontData - etykieta, pod ktora makro load_font zaladowalo dane czcionki)
	ld	de,$8200		; ustaw w DE adres generatora znakow (hex 8200) - przesuniety 0 512b 
						; poniewaz nie ladujemy pierwszego seta ASCII
	ld	bc,8*256        ; ustaw w BC dlugosc danych (8 bytes per tile) x (256 tiles)
	call mem_CopyMono   ; mem_CopyMono skopiuje BC * 2 bajtow spod adresu w HL pod adres DE
	
	ld	hl,Title       				; Skopiuj adres labelki Title do HL
	ld	de,$9800+(SCRN_VY_B*17)		; ustaw w DE adres $9800 + 3 + 32 * 7 = adres 7 wiersza ekranu + 3 spacje w nastepnym wierszu
	ld	bc,TitleEnd-Title			; ustaw w BC ilosc bajtow do skopiowania - dlugosc napisu spod Title
	call mem_Copy					; wywolaj mem_Copy, ktora przekopiuje 13 bajtow spod adresu w HL pod adres w DE
	
	ld	a,0							; zerowanie obszaru pamieci, w ktorym znajda sie dane sprite'ow (nie graficzne)
	ld	hl,OAMDATALOC
	ld	bc,OAMDATALENGTH
	call mem_Set
	
	ld	a,LCDCF_ON|LCDCF_BG8000|LCDCF_BG9800|LCDCF_BGON|LCDCF_OBJ8|LCDCF_OBJON	; ustaw w A flagi sterujace ekranem
	ld	[rLCDC],a       														; zaladuj A do rejestru sterujacego LCD rLCLC - efektywnie: wlacz LCD
	
	ld hl, TileData																; ustaw adres etykiety TileData (tiles.z80) w HL
	ld de, _VRAM       															; ustaw adres docelowy ($8000) w DE
	ld bc, $01f0																; ustaw ilosc bajtow do skopiowania w BC (jeden kafelek 8x8 = 16b * ilosc kafelkow)
	call mem_Copy 																; skopiuj pamiec
	
	call PlayerInit
	
	ld a,[vblank_count]
	inc a
	ld [vblank_count],a
	
	ld a,0
	ld [player_moving],a
	
MainLoop:
	halt
	nop
	call GetKeys
	ld [buttons_input],a
	call PlayerMovement
	call AnimatePlayer
	jr MainLoop

.loop:
	halt
	jr .loop
	
Title:
	DB	"Napierdalam w ASMie!"
TitleEnd:

draw:								; procedura obslugi przerwania vblank
	ld a,[last_vblank_count]
	inc a
	ld [last_vblank_count],a
	ld a,[vblank_count]
	inc a
	ld [vblank_count],a
.do_dma
	jp DMACODELOC					; skocz pod adres gdzie po wywolaniu 
									; procedury initdma znajdzie sie kod 
									; odpowiedzialny za kopiowanie sprite'ow
									; do VRAM'u
timer:								; procedura obslugi przerwania timera
									; liczy sekundy od startu i umieszcza je
									; pod adresem [seconds_passed]
	ld a,[timer_overflow_count]
	inc a							; A+1
	ld b,$10						; B=16
	cp b							; jesli (A=B) to
	call z,Increment_seconds		; zawolaj Increment_seconds
	ld [timer_overflow_count],a		; wywolanie Increment_seconds zeruje A
	reti							; zakoncz i przywroc obsluge przerwan
stat:
serial:
joypad:
	reti
	
StopLCD:
	ld		a,[rLCDC]		; Zaladuj rejestr LCDC (obsluga LCD) do a
	rlca					; Obroc zawartosc a w lewo (najmlodszy bit 0, najstarszy do carry)
	ret		nc				; jesli w carry jest 0 to znaczy ze bit 7 byl 0 czyli LCD wylaczone
.wait:
	ld		a,[rLY]			; Zaladuj aktualna pozycje Y ekranu do a
	cp		145				; porownaj a z 145 (a - 145 = 0) - jesli 0 ustaw carry = 1
	jr		nz,.wait		; jesli no-carry to czekaj (skok do .wait)

	ld		a,[rLCDC]		; Zaladuj rejestr LCDC (obsluga LCD) do a
	res		7,a				; Zresetuj (wyzeruj) bit 7 w a
	ld		[rLCDC],a		; zaladuj a pod adres rejestru LCDC

	ret
	
Increment_seconds:
	ld a,[seconds_passed]
	inc a
	ld [seconds_passed],a
	xor a
	ret
	
; GetKeys: adapted from APOCNOW.ASM and gbspec.txt
GetKeys:                 ;gets keypress
	ld 	a,P1F_5			; set bit 5
	ld 	[rP1],a			; select P14 by setting it low. See gbspec.txt lines 1019-1095
	ld 	a,[rP1]
 	ld 	a,[rP1]			; wait a few cycles
	cpl				; complement A. "You are a very very nice Accumulator..."
	and 	$0f			; look at only the first 4 bits
	swap 	a			; move bits 3-0 into 7-4
	ld 	b,a			; and store in b

 	ld	a,P1F_4			; select P15
 	ld 	[rP1],a
	ld	a,[rP1]
	ld	a,[rP1]
	ld	a,[rP1]
	ld	a,[rP1]
	ld	a,[rP1]
	ld	a,[rP1]
	ld	a,[rP1]
	ld	a,[rP1]
	ld	a,[rP1]
	ld	a,[rP1]			; wait for the bouncing to stop
	cpl				; as before, complement...
 	and $0f				; and look only for the last 4 bits
 	or b				; combine with the previous result
 	ret				; do we need to reset joypad? (gbspec line 1082)
	
initdma:
	ld	de, DMACODELOC		; ustaw w DE adres DMA
	ld	hl, dmacode			; ustaw w HL adres poczatkowy kodu obslugi kopiowania VRAM'u
	ld	bc, dmaend-dmacode	; ustaw w BC dlugosc kodu
	call	mem_CopyVRAM	; skopiuj kiedy VRAM będzie dostepny
	ret
dmacode:					; procedura obslugujaca kopiowanie VRAM'u
	push	af				; zabezpiecz A i flagi
	ld	a, OAMDATALOCBANK	; ustaw w A adres banku DMA
	ldh	[rDMA], a			; Start DMA
	ld	a, $28				; 160ns
dma_wait:
	dec	a
	jr	nz, dma_wait
	pop	af
	reti
dmaend:


