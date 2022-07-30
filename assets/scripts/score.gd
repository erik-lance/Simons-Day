extends Node2D

signal btn(s)
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_score(s):
	$SettingsMenu/ColorRect/VBoxContainer/Score.text = str(s)+" people!"


func _on_Button_button_up():
	emit_signal('btn','menu')
