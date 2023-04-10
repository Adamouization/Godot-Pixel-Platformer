extends KinematicBody2D
class_name Player

 
# Finite State Machine
enum {
	MOVE,  # set to 0
	CLIMB,  # set to 1
}


# Global variabes
var state = MOVE  # Default state
var velocity = Vector2.ZERO
var double_jump = 1  # number of double jumps
var buffered_jump = false


# Player stats: imported from PlayerMovementData resource + cast as PlayerMovementData for auto-completion 
export(Resource) var move_data = preload("res://DefaultPlayerMovementData.tres") as PlayerMovementData
 

# Shortcuts (: for cast typing and auto-completion)
onready var animatedSprite: = $AnimatedSprite  # need onready else will run before node exists in scene
onready var ladderDetection: = $LadderDetection
onready var jumpBufferTimer: = $JumpBufferTimer


# Called when the node enters the scene tree for the first time.
func _ready():
	# Load sprite
	animatedSprite.frames = load("res://PlayerYellowSkin.tres")


# Called during every physics frame of the game (default 60).
# Delta = 1/60
func _physics_process(delta):
	# Move right/left
	var input = Vector2.ZERO
	input.x =  Input.get_axis("ui_left", "ui_right")  # same as: Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_axis("ui_up", "ui_down")
	
	# FSM
	match state:
		MOVE: move_state(input)
		CLIMB: climb_state(input)


func move_state(input):
	# State transition
	if is_on_ladder() and Input.is_action_pressed("ui_up"):
		state = CLIMB
	
	# Gravity
	apply_gravity()
	
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
		# Reset double jump counter
		double_jump = move_data.DOUBLE_JUMP_COUNT_MAX
		
		# is_action_just_pressed to avoid bouncing directly by holding or if a jump is buffered, then jump
		if Input.is_action_just_pressed("ui_up") or buffered_jump == true:
			velocity.y = move_data.JUMP_HEIGHT
			buffered_jump = false
	
	# Small jump (with release when in the air)
	else:
		animatedSprite.animation = "jump"
		
		if Input.is_action_just_released("ui_up") and velocity.y < move_data.JUMP_RELEASE_HEIGHT:
			velocity.y = move_data.JUMP_RELEASE_HEIGHT
		
		if Input.is_action_just_pressed("ui_up") and double_jump > 0:
			velocity.y = move_data.JUMP_HEIGHT
			double_jump -= 1 
		
		if Input.is_action_just_pressed("ui_up"):
			buffered_jump = true
			jumpBufferTimer.start()  # starts the timer
		
		if velocity.y > 0:   # Just started falling (0 = apex)
			animatedSprite.animation = "idle"  # close legs when falling back down
			velocity.y += move_data.GRAVITY_ACC
	
	# Check if was jumping
	var was_in_air = not is_on_floor()
	
	# Update position
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# Update animation to play correct frame when landing
	if is_on_floor() and was_in_air:
		animatedSprite.animation = "run"
		animatedSprite.frame = 1


func climb_state(input):
	# State transition
	if not is_on_ladder():
		state = MOVE
	
	# Climbing animation
	if input.length() != 0:  # moving up
		animatedSprite.animation = "run"
	else:  # not moving on ladder
		animatedSprite.animation = "ide"
	
	velocity = input * move_data.CLIMB_SPEED
	velocity = move_and_slide(velocity, Vector2.UP)


func apply_gravity():
	velocity.y += move_data.GRAVITY
	velocity.y = min(velocity.y, 300)  # set max gravity 300 to prevent player from falling too fast


func apply_friction():
	velocity.x = move_toward(velocity.x, 0, move_data.FRICTION)


func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, move_data.MAX_SPEED * amount, move_data.ACCELERATION)


func is_on_ladder():
	# Exit case #1: if not colliding at all, exit
	if not ladderDetection.is_colliding():
		return false
		
	# Exit case  #2: if collider colliding with is not a ladder, exit
	if not ladderDetection.get_collider() is Ladder: 
		return false
	
	return true


func _on_JumpBufferTimer_timeout():
	 buffered_jump = false 
