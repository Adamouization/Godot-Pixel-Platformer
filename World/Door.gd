# warning-ignore:return_value_discarded
extends Area2D


export (String, FILE, "*.tscn") var target_level_path = ""


var player = false



func _process(_delta):
	# Don't exit level if player is not over the door
	if not player:
		return
	
	# Don't exit level if player is not on the floor
	if not player.is_on_floor():
		return
	
	if Input.is_action_just_pressed("ui_accept"):  # space key
		# If target level path is empty then exit func	tion
		if target_level_path.empty():
			return
		
		# Else go to next level as intended
		go_to_next_level()


func go_to_next_level():
	# Level transition animation
	LevelTransition.play_exit_level_transition()
	get_tree().paused = true  # pause game
	yield(LevelTransition, "transition_completed")  # wait for transition to finish
	LevelTransition.play_enter_level_transition()
	get_tree().paused = false  # resume game
	
	# Change to a new scene defined in an instance of the door in a scene
	get_tree().change_scene(target_level_path)


func _on_Door_body_entered(body):
	# Exit if collision is with anything that is not a player.
	if not body is Player:
		return
	
	player = body


func _on_Door_body_exited(body):
	if not body is Player:
		return
	
	player = null
