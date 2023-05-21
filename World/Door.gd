extends Area2D


export (String, FILE, "*.tscn") var target_level_path = ""


func _on_Door_body_entered(body):
	# Exit if collision is with anything that is not a player.
	if not body is Player:
		return
	
	# Exit if target level path is empty
	if target_level_path.empty():
		return
	
	# Level transition animation
	LevelTransition.play_exit_level_transition()
	get_tree().paused = true  # pause game
	yield(LevelTransition, "transition_completed")  # wait for transition to finish
	LevelTransition.play_enter_level_transition()
	get_tree().paused = false  # resume game
	
	# Change to a new scene defined in an instance of the door in a scene
	get_tree().change_scene(target_level_path)
