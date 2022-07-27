extends Node2D


onready var cur_scene_node = $CurrentScene

var freeplay_scene = "res://scenes/freeplay.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func remove_cur_scene():
	if cur_scene_node.get_children().size() > 0:
		for scene in cur_scene_node.get_children():
			scene.queue_free()

func load_scene(scene):
	remove_cur_scene()
	
	var loaded_scene = load(scene).instance()
	cur_scene_node.add_child(loaded_scene)
