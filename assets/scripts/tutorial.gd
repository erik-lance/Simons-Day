extends Node2D

signal btn(s)

onready var anim = $AnimationPlayer

var cur_scene = 0
var scenes = [
	'spotlight_on',
	'point_simon','point_simon_out',
	'point_flynn','point_flynn_out',
	'point_laura','point_laura_out',
	'spotlight_off'
]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_released("next_dialogue"):
		if cur_scene >= scenes.size():
			emit_signal('btn','menu')
		else:
			anim.play(scenes[cur_scene])
			cur_scene+=1
