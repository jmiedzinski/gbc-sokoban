INCLUDE	"inc/vars.inc"
INCLUDE	"inc/sprite.inc"

SECTION "WRAM_C0",BSS[$C000]
timer_overflow_count::	DS 1
vblank_count::			DS 1
last_vblank_count::		DS 1
seconds_passed::		DS 1
player_moving::			DS 1
move_direction::		DS 1

SECTION "WRAM_C1",BSS[$C100]
	SpriteAttr	Sprite0
	SpriteAttr	Sprite1
	SpriteAttr	Sprite2
	SpriteAttr	Sprite3