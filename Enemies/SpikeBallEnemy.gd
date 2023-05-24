tool
extends Path2D


enum AMIMATION_TYPE {
	LOOP,
	BOUNCE
}


# Export vars
export(AMIMATION_TYPE) var animation_type setget set_animation_type
export(int) var animation_speed = 1


# Shortcuts (: for cast typing and auto-completion)
onready var animationPlayer: = $AnimationPlayer 


# Called when the node enters the scene tree for the first time.
func _ready():
	play_updated_animation(animationPlayer)


func play_updated_animation(ap):
	match animation_type:
		AMIMATION_TYPE.LOOP: 
			ap.play("MoveAlong2DPathLoop")
		AMIMATION_TYPE.BOUNCE: 
			ap.play("MoveAlong2DPathBounce")
	ap.playback_speed = animation_speed


func set_animation_type(value):

	animation_type = value
	var ap = find_node("AnimationPlayer")
	if ap:
		play_updated_animation(ap)
