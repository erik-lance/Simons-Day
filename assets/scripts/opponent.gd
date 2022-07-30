extends Node2D

signal defeated
signal damage(d)

var max_hp
var hp

var cur_target = null

enum challenger {UNKNOWN, LAURA, FLYNN}
var challenge_type =  challenger.UNKNOWN

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_target() : return cur_target
func set_target(t): cur_target = t

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
		emit_signal('damage',d)


func _on_Timer_timeout():
	if challenge_type == challenger.FLYNN:
		pass
	elif challenge_type == challenger.LAURA:
		pass
	else:
		pass
