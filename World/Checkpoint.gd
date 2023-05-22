extends Area2D


onready var animatedSprite: = $AnimatedSprite


var active = true
var is_flag_raised: bool = false


func _on_Checkpoint_body_entered(body):
	# Only collide with player
	if not body is Player:
		return
	
	# Prevent going to an old checkpoint
	if not active:
		return
	
	# Play animation
	animatedSprite.play("checked")
	
	# Play sound
	if not is_flag_raised:
		SoundPlayer.play_sound(SoundPlayer.CHECKPOINT)
		is_flag_raised = true
		
	
	# Save location as new spawn
	Events.emit_signal(
		"checkpoint_reached", # event
		position  # position of the checkpoint 
	)
