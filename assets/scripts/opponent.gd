extends Node2D

signal defeated
signal damage

var max_hp
var hp


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_new_hp(h):
	max_hp = h
	hp = h

func get_hp():
	return hp

func take_hit(d):
	hp -= d
	if hp <= 0:
		emit_signal('defeated')
	else:
		emit_signal('damage')
