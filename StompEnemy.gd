extends Node2D


enum {
	HOVER,
	RISE,
	FALL,
	LAND
}

var state = HOVER


onready var start_position = position   # use instead of global_position
onready var timer := $Timer
onready var ray_cast := $RayCast2D
onready var animated_sprite := $AnimatedSprite
onready var particles := $Particles2D


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
	state = FALL


func rise_state(delta):
	# Set animation
	animated_sprite.play("rising")
	
	# Move back towards start position
	position.y = move_toward(position.y, start_position.y, 20 * delta)
	if position.y == start_position.y:
		state = HOVER


func fall_state(delta):
	# Fall down with angry face animation
	position.y += 100 * delta
	animated_sprite.play("falling")
	
	# Check collision with floor
	if ray_cast.is_colliding():
		var collision_point = ray_cast.get_collision_point()
#		position.y = collision_point.y
		state = LAND
		
		# Wait 1s in land state before entering rise state
		timer.start(1.0)
		particles.emitting = true


func land_state():
	if timer.time_left == 0:
		state = RISE
