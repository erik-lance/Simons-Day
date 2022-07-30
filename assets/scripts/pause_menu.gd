extends Control

signal btn(s)

var disabled = true

func toggle_disable(): disabled = !disabled

func _input(event):
	if !disabled:
		if event.is_action_released('menu'):
			get_tree().paused = false
			self.visible = false
			disabled = true
	else:
		if event.is_action_released('menu'):
			get_tree().paused = true
			self.visible = true
			disabled = false

func _on_Continue_button_up():
	get_tree().paused = false
	self.visible = false
	disabled = true


func _on_MainMenu_button_up():
	emit_signal('btn','menu')
