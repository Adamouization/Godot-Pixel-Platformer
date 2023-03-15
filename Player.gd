extends KinematicBody2D


# Member variables declarations
var velocity = Vector2.ZERO

# Constants
export(int) var JUMP_HEIGHT = -160
export(int) var JUMP_RELEASE_HEIGHT = -35
export(int) var MAX_SPEED = 75
export(int) var ACCELERATION = 10
export(int) var FRICTION = 10
export(int) var GRAVITY = 5
export(int) var GRAVITY_ACC = 3

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

	
	# Jumping
	# Big jump
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):  # is_action_just_pressed to avoid bouncing directly by holding
			velocity.y = JUMP_HEIGHT
	# Small jump
	else:
		if Input.is_action_just_released("ui_up") and velocity.y < JUMP_RELEASE_HEIGHT:
			velocity.y = JUMP_RELEASE_HEIGHT
		if velocity.y > 0:   # Just started falling (0 = apex)
			velocity.y += GRAVITY_ACC
	
	# Update position
	velocity = move_and_slide(velocity, Vector2.UP)


func apply_gravity():
	velocity.y += GRAVITY


func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)


func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, MAX_SPEED * amount, ACCELERATION)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
