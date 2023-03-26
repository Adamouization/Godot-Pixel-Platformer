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


# Shortcuts
onready var animatedSprite = $AnimatedSprite  # need onready else will run before node exists in scene


# Called when the node enters the scene tree for the first time.
func _ready():
	animatedSprite.frames = load("res://PlayerYellowSkin.tres")


# Called during every physics frame of the game (default 60).
# Delta = 1/60
func _physics_process(delta):
	# Gravity
	apply_gravity()
	
	# Move right/left
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	# Not moving = idle
	if input.x == 0:
		apply_friction()
		animatedSprite.animation = "idle"  # same as get_node("AnimatedSprite")
	# Moving = running
	else:
		apply_acceleration(input.x)
		animatedSprite.animation = "run"
		
		# Turn player in the direction of movement
		if input.x > 0:
			animatedSprite.flip_h = true  # because sprite faces left by default
		elif input.x < 0:
			animatedSprite.flip_h = false  # faces left by default
	
	# Jumping
	# Big jump
	if is_on_floor():
		if Input.is_action_pressed("ui_up"):  # is_action_just_pressed to avoid bouncing directly by holding
			velocity.y = JUMP_HEIGHT
	# Small jump
	else:
		animatedSprite.animation = "jump"
		if Input.is_action_just_released("ui_up") and velocity.y < JUMP_RELEASE_HEIGHT:
			velocity.y = JUMP_RELEASE_HEIGHT
		if velocity.y > 0:   # Just started falling (0 = apex)
			animatedSprite.animation = "idle"  # close legs when falling back down
			velocity.y += GRAVITY_ACC
	
	# Check if was jumping
	var was_in_air = not is_on_floor()
	
	# Update position
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# Update animation to play correct frame when landing
	if is_on_floor() and was_in_air:
		animatedSprite.animation = "run"
		animatedSprite.frame = 1


func apply_gravity():
	velocity.y += GRAVITY
	# set max gravity to prevent player from falling too fast
	velocity.y = min(velocity.y, 300)


func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)


func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, MAX_SPEED * amount, ACCELERATION)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
