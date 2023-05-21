extends Node2D

# Instantiate a new scene
const player_scene = preload("res://Player/Player.tscn")


# Constants
var player_spawn_location = Vector2.ZERO


# Shortcuts
onready var camera: = $Camera2D
onready var player: = $Player
onready var timer: = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	# Background colour
	VisualServer.set_default_clear_color(Color.dodgerblue)
	 
	# Attach camera to player and set spawn location to player
	player.connect_camera(camera)
	player_spawn_location = player.position
	
	# Connect events
	Events.connect("player_died", self, "_on_player_died")
	Events.connect("checkpoint_reached", self, "on_checkpoint_reached")


func _on_player_died():
	# Wait for a bit before re-spawning
	timer.start(0.5)
	yield(timer, "timeout")
	
	# Create new player instance and add it to world
	var player = player_scene.instance()
	player.position = player_spawn_location	
	add_child(player)
	player.connect_camera(camera)


func on_checkpoint_reached(position):
	player_spawn_location = position
