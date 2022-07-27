extends Node2D

onready var master_slider = $Menu/ColorRect/VBoxContainer/Master
onready var music_slider=  $Menu/ColorRect/VBoxContainer/Music
onready var SFX_slider = $Menu/ColorRect/VBoxContainer/SFX

# Called when the node enters the scene tree for the first time.
func _ready():
	master_slider.value = AudioServer.get_bus_volume_db(0)
	music_slider.value = AudioServer.get_bus_volume_db(1)
	SFX_slider.value = AudioServer.get_bus_volume_db(2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Master_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)


func _on_Music_value_changed(value):
	AudioServer.set_bus_volume_db(1, value)


func _on_SFX_value_changed(value):
	AudioServer.set_bus_volume_db(2, value)


func _on_Button_button_up():
	get_tree().change_scene_to(load("res://scenes/main_menu.tscn"))
