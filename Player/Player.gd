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
var coyote_jump = false


# Player stats: imported from PlayerMovementData resource + cast as PlayerMovementData for auto-completion 
export(Resource) var move_data = preload("res://Player/Player_Characteristics_Data/FastPlayerMovementData.tres") as PlayerMovementData


# Shortcuts (: for cast typing and auto-completion)
onready var animatedSprite: = $AnimatedSprite  # need onready else will run before node exists in scene
onready var ladderDetection: = $LadderDetection
onready var jumpBufferTimer: = $JumpBufferTimer
onready var coyoteJumpTimer: = $CoyoteJumpTimer
onready var remoteTransform: = $RemoteTransform2D


# Called when the node enters the scene tree for the first time.
func _ready():
	# Load sprite
	animatedSprite.frames = load(Gloval_Variables.player_skin_path)


# Called during every physics frame of the game (default 60).
# Delta = 1/60
func _physics_process(delta):
	# Move right/left
	var input = Vector2.ZERO
	input.x =  Input.get_axis("ui_left", "ui_right")  # same as: Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input.y = Input.get_axis("ui_up", "ui_down")
	
	# Prevent player from falling to infinite
	if position.y > 300:
		die()
	
	# FSM
	match state:
		MOVE: move_state(input, delta)
		CLIMB: climb_state(input)


func move_state(input, delta):
	# State transition
	if is_on_ladder() and Input.is_action_pressed("ui_up"):
		state = CLIMB
	
	# Gravity
	apply_gravity(delta)
	
	# Not moving = idle
	if input.x == 0:
		apply_friction(delta)
		animatedSprite.animation = "idle"  # same as get_node("AnimatedSprite")
	# Moving = running
	else:
		apply_acceleration(input.x, delta)
		animatedSprite.animation = "run"
		
		# Turn player in the direction of movement
		if input.x > 0:
			animatedSprite.flip_h = true  # because sprite faces left by default
		elif input.x < 0:
			animatedSprite.flip_h = false  # faces left by default
	
	# Jumping (if on floor or coyote jump conditions are true)
	if is_on_floor():  # Reset double jump counter if on floor
		double_jump = move_data.DOUBLE_JUMP_COUNT_MAX
	if can_jump():
		# Reset double jump counter
		double_jump = move_data.DOUBLE_JUMP_COUNT_MAX
		
		# Jump (use is_action_just_pressed to avoid bouncing directly by holding or if a jump is buffered, then jump)
		if Input.is_action_just_pressed("ui_up") or buffered_jump == true:
			SoundPlayer.play_sound(SoundPlayer.JUMP)
			velocity.y = move_data.JUMP_HEIGHT
			buffered_jump = false
	
	# Small jump (with release when in the air)
	else:
		animatedSprite.animation = "jump"
		
		# Input jump release
		if Input.is_action_just_released("ui_up") and velocity.y < move_data.JUMP_RELEASE_HEIGHT:
			velocity.y = move_data.JUMP_RELEASE_HEIGHT
		
		# Input double jump
		if Input.is_action_just_pressed("ui_up") and double_jump > 0:
			SoundPlayer.play_sound(SoundPlayer.JUMP)
			velocity.y = move_data.JUMP_HEIGHT
			double_jump -= 1 
		
		# Buffer jump
		if Input.is_action_just_pressed("ui_up"):
			buffered_jump = true
			jumpBufferTimer.start()  # starts the timer
		
		# Fast fall
		if velocity.y > 0:   # Just started falling (0 = apex)
			animatedSprite.animation = "idle"  # close legs when falling back down
			velocity.y += move_data.GRAVITY_ACC * delta
	
	# Check if was jumping or was on floor
	var was_in_air = not is_on_floor()
	var was_on_floor = is_on_floor()
	
	# Update position
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# Update animation to play correct frame when landing
	if is_on_floor() and was_in_air:
		animatedSprite.animation = "run"
		animatedSprite.frame = 1
	
	# Coyote jump (left ledge and jumped)
	var just_left_ground = (not is_on_floor()) and (was_on_floor)
	if just_left_ground and velocity.y >= 0:
		coyote_jump = true
		coyoteJumpTimer.start()


func climb_state(input):
	# State transition
	if not is_on_ladder():
		state = MOVE
	
	# Climbing animation
	if input.length() != 0:  # moving up
		animatedSprite.animation = "run"
	else:  # not moving on ladder
		animatedSprite.animation = "idle"
	
	velocity = input * move_data.CLIMB_SPEED
	velocity = move_and_slide(velocity, Vector2.UP)


func can_jump():
	 return is_on_floor() or coyote_jump == true


func apply_gravity(delta):
	velocity.y += move_data.GRAVITY * delta
	velocity.y = min(velocity.y, 300)  # set max gravity 300 to prevent player from falling too fast


func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, move_data.FRICTION * delta)


func apply_acceleration(amount, delta):
	velocity.x = move_toward(velocity.x, move_data.MAX_SPEED * amount, move_data.ACCELERATION * delta)


func is_on_ladder():
	# Exit case #1: if not colliding at all, exit
	if not ladderDetection.is_colliding():
		return false
		
	# Exit case  #2: if collider colliding with is not a ladder, exit
	if not ladderDetection.get_collider() is Ladder: 
		return false
	
	return true


func die():
	SoundPlayer.play_sound(SoundPlayer.HURT)
	
	queue_free()
	# get_tree().reload_current_scene()
	
	Events.emit_signal("player_died")


func connect_camera(camera):
	var camera_path = camera.get_path()
	remoteTransform.remote_path = camera_path


func _on_JumpBufferTimer_timeout():
	 buffered_jump = false 


func _on_CoyoteJumpTimer_timeout():
	coyote_jump = false
