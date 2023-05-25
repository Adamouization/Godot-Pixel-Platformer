extends Node2D


export var main_game_scene : PackedScene


onready var animated_sprite: = $AnimatedSprite  # need onready else will run before node exists in scene


var SKINS_FOLDER_PATH : String = "res://Player/Skins/"
var current_skin_index: int = 2  # default is 2, which is yellow
var skins_lst = []


func _ready():
	# Load frames with default character skin
	animated_sprite.frames = load(Gloval_Variables.player_skin_path)
	animated_sprite.animation = "run"
	
	# Get list of all skins available
	skins_lst = _list_files_in_directory(SKINS_FOLDER_PATH)
	print("current skin = {skin}".format({"skin" : skins_lst[current_skin_index]}))


func _on_New_Game_Button_button_up():
	# Start game with level 1
	# warning-ignore:return_value_discarded
	get_tree().change_scene(main_game_scene.resource_path)


func _on_Made_By_Button_pressed():
	# Redirect to website
	# warning-ignore:return_value_discarded
	OS.shell_open("http://www.adam.jaamour.com/")


func _on_Skin_Button_button_up():
	# Update index from list of skins
	if current_skin_index >= len(skins_lst) - 1:
		current_skin_index = 0
	else:
		current_skin_index += 1
	
	# Update selected skin with new path
	print("Skin selected = {skin}".format({"skin" : skins_lst[current_skin_index]}))
	Gloval_Variables.player_skin_path = SKINS_FOLDER_PATH + skins_lst[current_skin_index]
	
	# Update animated sprite in title screen
	animated_sprite.frames = load(Gloval_Variables.player_skin_path)
	animated_sprite.animation = "run"


func _list_files_in_directory(path):
	"""
	Appends all files in a directory to a list and returns that list
	"""
	var files = []
	var dir = Directory.new()
	
	dir.open(path)
	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)
	dir.list_dir_end()
	
	return files
