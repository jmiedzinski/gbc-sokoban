INCLUDE	"inc/vars.inc"
INCLUDE	"inc/sprite.inc"
INCLUDE	"inc/player.inc"
INCLUDE	"inc/crate.inc"

SECTION "WRAM_C0",BSS[$C000]
timer_overflow_count::	DS 1
vblank_count::			DS 1
last_vblank_count::		DS 1
seconds_passed::		DS 1
player_moving::			DS 1
move_direction::		DS 1
buttons_input::			DS 1
curr_anim_first_frame	DS 1
curr_anim_last_frame	DS 1
collision::				DS 1
player_animating::		DS 1
steps_count::			DS 1
	
	PlayerAttr Player
	CrateAttr Crate0
	CrateAttr Crate1
	CrateAttr Crate2

SECTION "WRAM_C1",BSS[$C100]
	SpriteAttr	Sprite0
	SpriteAttr	Sprite1
	SpriteAttr	Sprite2
	SpriteAttr	Sprite3
	
	SpriteAttr	Crate0_0
	SpriteAttr	Crate0_1
	SpriteAttr	Crate0_2
	SpriteAttr	Crate0_3
	
	SpriteAttr	Crate1_0
	SpriteAttr	Crate1_1
	SpriteAttr	Crate1_2
	SpriteAttr	Crate1_3
	
	SpriteAttr	Crate2_0
	SpriteAttr	Crate2_1
	SpriteAttr	Crate2_2
	SpriteAttr	Crate2_3