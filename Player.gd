extends KinematicBody2D


# Declare member variables here
var velocity = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
#func _ready():
#	print("Hello World!")

# Called during every physics frame of the game (default 60).
# Delta = 1/60
func _physics_process(delta):
	# Gravity
	velocity.y += 4
	
	# Move right/left
	if Input.is_action_pressed("ui_right"):
		velocity.x = 50
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -50
	else:
		velocity.x = 0
	
	# Jump
	if Input.is_action_just_pressed("ui_up"):
		velocity.y = -120
	
	# Update position
	velocity = move_and_slide(velocity)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
