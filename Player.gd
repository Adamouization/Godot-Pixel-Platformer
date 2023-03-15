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
	apply_gravity()
	
	# Move right/left
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if input.x == 0:
		apply_friction()
	else:
		apply_acceleration(input.x)

	
	# Jump
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y -= 120
	else:
		if Input.is_action_just_released("ui_up") and velocity.y < -30:
			velocity.y -= 0
	
	# Update position
	velocity = move_and_slide(velocity, Vector2.UP)


func apply_gravity():
	velocity.y += 4


func apply_friction():
	velocity.x = move_toward(velocity.x, 0, 10)


func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, 50 * amount, 10)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
