extends CanvasLayer


onready var animation_player := $AnimationPlayer


signal transition_completed


func  play_exit_level_transition():
	animation_player.play("Exit_Level")


func play_enter_level_transition():
	animation_player.play("Enter_Level")


func _on_AnimationPlayer_animation_finished(_anim_name):
	emit_signal("transition_completed")
