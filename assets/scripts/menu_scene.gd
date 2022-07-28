extends TextureRect

signal btn(s)

func _on_Start_button_up():
	emit_signal("btn", 'start')

func _on_Freeplay_button_up():
	emit_signal("btn", 'freeplay')

func _on_Settings_button_up():
	emit_signal("btn", 'settings')

func _on_Quit_button_up():
	emit_signal("btn", 'quit')
