extends Control


onready var p_bar = $HBoxContainer/PlayerBox/PlayerBar
onready var e_bar = $HBoxContainer/EnemyBox/EnemyBar
onready var s_label = $HBoxContainer/Score

var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func ready_player_bar(hp):
	p_bar.max_value = hp
	p_bar.value = hp

func ready_enemy_bar(hp):
	var init_v =  e_bar.value
	$HBoxContainer/EnemyBox/EnemyBar/Tween.interpolate_property(e_bar,"value",init_v, 0,1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$HBoxContainer/EnemyBox/EnemyBar/Tween.start()
	
	e_bar.max_value = hp
	e_bar.value = 0

func player_damage(d):
	var init_v =  p_bar.value
	var final_v = p_bar.value - d
	
	$HBoxContainer/PlayerBox/PlayerBar/Tween.interpolate_property(p_bar,"value",init_v, final_v,1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$HBoxContainer/PlayerBox/PlayerBar/Tween.start()

func player_empty():
	$HBoxContainer/PlayerBox/PlayerBar/Tween.interpolate_property(p_bar,"value",null, 0,0.5)
	$HBoxContainer/PlayerBox/PlayerBar/Tween.start()

# Enemy increase satisfaction therefore it is reversed
func enemy_damage(d):
	var init_v =  e_bar.value
	var final_v = e_bar.value + d
	
	$HBoxContainer/EnemyBox/EnemyBar/Tween.interpolate_property(e_bar,"value",init_v, final_v,0.5,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	$HBoxContainer/EnemyBox/EnemyBar/Tween.start()

func enemy_empty():
	$HBoxContainer/EnemyBox/EnemyBar/Tween.interpolate_property(e_bar,"value",null, e_bar.max_value,0.5)
	$HBoxContainer/EnemyBox/EnemyBar/Tween.start()
	add_score()

func get_score():
	return score

func add_score():
	score += 1
	s_label.text = str(score)
