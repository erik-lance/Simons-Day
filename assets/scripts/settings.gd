extends Node2D

signal btn(s)
signal difficulty(d)

onready var master_slider = $SettingsMenu/ColorRect/VBoxContainer/Master
onready var music_slider=  $SettingsMenu/ColorRect/VBoxContainer/Music
onready var SFX_slider = $SettingsMenu/ColorRect/VBoxContainer/SFX

# Called when the node enters the scene tree for the first time.
func _ready():
	master_slider.value = AudioServer.get_bus_volume_db(0)
	music_slider.value = AudioServer.get_bus_volume_db(1)
	SFX_slider.value = AudioServer.get_bus_volume_db(2)

func _on_Master_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)

func _on_Music_value_changed(value):
	AudioServer.set_bus_volume_db(1, value)

func _on_SFX_value_changed(value):
	if !$SettingsMenu/AudioStreamPlayer.playing:
		$SettingsMenu/AudioStreamPlayer.play()
	AudioServer.set_bus_volume_db(2, value)

func _on_Button_button_up():
	emit_signal('btn','menu')

func diff_slider(d):
	$SettingsMenu/ColorRect/VBoxContainer/EasyHard.value = d

func _on_EasyHard_value_changed(value):
	emit_signal('difficulty',value)
