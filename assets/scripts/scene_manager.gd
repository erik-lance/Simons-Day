extends Node2D


onready var cur_scene_node = $CurrentScene

var freeplay_scene = "res://scenes/freeplay.tscn"

var cur_scene
var scenes = {
	menu = "res://scenes/main_menu.tscn",
	start = "res://scenes/hallway.tscn",
	freeplay = "res://scenes/freeplay.tscn",
	settings = "res://scenes/settings.tscn"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	cur_scene = scenes.menu
	cur_scene_node.get_child(0).connect('btn',self,'_on_signal_scene')

func remove_cur_scene():
	if cur_scene_node.get_children().size() > 0:
		for scene in cur_scene_node.get_children():
			scene.queue_free()

func _on_signal_scene(s):
	var cur_signal_scene = null
	
	match(s):
		'start': cur_signal_scene = scenes.start
		'freeplay': cur_signal_scene = scenes.freeplay
		'settings': cur_signal_scene = scenes.settings
		'quit': get_tree().quit()
	
	if cur_signal_scene != null:
		cur_scene = cur_signal_scene
		load_scene(cur_scene)
	else:
		print('Exiting OR Unknown scene reached.')

func load_scene(scene):
	remove_cur_scene()
	
	var loaded_scene = load(scene).instance()
	cur_scene_node.add_child(loaded_scene)
