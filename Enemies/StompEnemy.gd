extends Node2D


enum {
	HOVER,
	RISE,
	FALL,
	LAND
}

var state = HOVER
var is_player_close = false


onready var start_position = position   # use instead of global_position
onready var timer := $Timer
onready var ray_cast := $RayCast2D
onready var animated_sprite := $AnimatedSprite
onready var particles := $Particles2D


export(int) var FALL_SPEED = 150
export(int) var RISE_SPEED = 30
export(float) var WAIT_TIMER = 1.0


func _ready():
	particles.one_shot = true


func _physics_process(delta):
	match state:
		HOVER:
			hover_state()
		RISE:
			rise_state(delta)
		FALL:
			fall_state(delta)
		LAND:
			land_state()


func hover_state():
	if timer.time_left == 0:
		state = FALL


func rise_state(delta):
	# Set animation
	animated_sprite.play("rising")
	
	# Move back towards start position
	position.y = move_toward(position.y, start_position.y, RISE_SPEED * delta)
	if position.y == start_position.y:
		state = HOVER
	
	# Wait 1s in land state before entering rise state
	timer.start(WAIT_TIMER)


func fall_state(delta):
	# Fall down with angry face animation
	position.y += FALL_SPEED * delta
	animated_sprite.play("falling")
	
	# Check collision with floor
	if ray_cast.is_colliding():
		# If player close enough to enemy, play sound (don't play if out of screen)
		if is_player_close:
			SoundPlayer.play_sound(SoundPlayer.STOMP_IMPACT)
#		var collision_point = ray_cast.get_collision_point()
#		position.y = collision_point.y
		state = LAND
		
		# Wait 1s in land state before entering rise state
		timer.start(WAIT_TIMER)
		particles.emitting = true


func land_state():
	if timer.time_left == 0:
		state = RISE


func _on_Sound_Impact_Vicinity_body_entered(body):
	if body is Player:
		is_player_close = true


func _on_Sound_Impact_Vicinity_body_exited(body):
	if body is Player:
		is_player_close = false
