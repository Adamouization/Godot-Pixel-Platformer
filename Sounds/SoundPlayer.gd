extends Node


# Load sound effects resources
# Created using https://sfbgames.itch.io/chiptone
const HURT = preload("res://Sounds/Sound_Effects/hurt.wav")
const JUMP = preload("res://Sounds/Sound_Effects/jump.wav")
const STOMP_IMPACT = preload("res://Sounds/Sound_Effects/stomp_enemy_impact.wav")
const CHECKPOINT = preload("res://Sounds/Sound_Effects/checkpoint.wav")

# PIXABAY content
const DOOR_OPEN = preload("res://Sounds/Sound_Effects/dorm-door-opening-6038.mp3")

# 8-BIT RETRO GAME SFT 44HZ 16BIT STEREO
const UI_CLICK = preload("res://Sounds/Sound_Effects/Retro_8-Bit_Game-Interface_UI_05.wav")


# Shortcut
onready var audioPlayers: = $AudioPlayers


func play_sound(sound):
	for audioStreamPlayer in audioPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break
