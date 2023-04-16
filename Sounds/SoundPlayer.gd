extends Node


# Load sound effects resources
const HURT = preload("res://Sounds/hurt.wav")
const JUMP = preload("res://Sounds/jump.wav")


# Shortcut
onready var audioPlayers: = $AudioPlayers


func play_sound(sound):
	for audioStreamPlayer in audioPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break
