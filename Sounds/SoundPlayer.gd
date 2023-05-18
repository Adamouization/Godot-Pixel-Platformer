extends Node


# Load sound effects resources
# Created using https://sfbgames.itch.io/chiptone
const HURT = preload("res://Sounds/hurt.wav")
const JUMP = preload("res://Sounds/jump.wav")
const STOMP_IMPACT = preload("res://Sounds/stomp_enemy_impact.wav")
const CHECKPOINT = preload("res://Sounds/checkpoint.wav")


# Shortcut
onready var audioPlayers: = $AudioPlayers


func play_sound(sound):
	for audioStreamPlayer in audioPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break
