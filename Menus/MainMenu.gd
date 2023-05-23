extends Node2D


export var  main_game_scene : PackedScene


func _on_New_Game_Button_button_up():
	get_tree().change_scene(main_game_scene.resource_path)
