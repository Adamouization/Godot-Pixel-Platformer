extends Node2D

# Instantiate a new scene
const player_scene = preload("res://Player.tscn")


# Constants
var player_spawn_location = Vector2.ZERO


# Shortcuts
onready var camera: = $Camera2D
onready var player: = $Player
onready var timer: = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	VisualServer.set_default_clear_color(Color.dodgerblue)
	player.connect_camera(camera)
	player_spawn_location = player.global_position
	Events.connect("player_died", self, "_on_player_died")


func _on_player_died():
	# Wait for a bit before re-spawning
	timer.start(0.5)
	yield(timer, "timeout")
	
	# Create new player instance and add it to world
	var player = player_scene.instance()
	add_child(player)
	player.global_position = player_spawn_location	
	player.connect_camera(camera)
