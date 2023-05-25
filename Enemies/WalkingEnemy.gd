# warning-ignore:return_value_discarded
extends KinematicBody2D


# Constants
var direction = Vector2.RIGHT
var velocity = Vector2.ZERO


# Shortcuts
onready var LedgeCheckRight = $LedgeCheckRight
onready var LedgeCheckLeft = $LedgeCheckLeft
onready var sprite = $AnimatedSprite


# Called during every physics frame of the game (default 60).
# Delta = 1/60
func _physics_process(_delta):
	# Detect wall collisions or ledges
	var is_found_wall = is_on_wall()
	var is_found_ledge = (not LedgeCheckRight.is_colliding()) or (not LedgeCheckLeft.is_colliding())
	
	# Change direction if wall or ledge found
	if is_found_wall or is_found_ledge:
		direction *= -1  # flip vector
	
	# Flip sprite based on direction it's walking towards
	sprite.flip_h = direction.x > 0  # flip h true is direction is 1, false is direction is 0
	
	# Apply move
	velocity = direction * 25
	move_and_slide(velocity, Vector2.UP)
