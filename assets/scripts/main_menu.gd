extends Node2D

onready var scene_manager = $SceneManager

var freeplay_scene = "res://scenes/freeplay.tscn"

func _ready():
	pass # Replace with function body.

func _on_Start_button_up():
	pass # Replace with function body.

func _on_Freeplay_button_up():
	scene_manager.load_scene(freeplay_scene)

func _on_Settings_button_up():
	pass # Replace with function body.

func _on_Quit_button_up():
	pass # Replace with function body.
