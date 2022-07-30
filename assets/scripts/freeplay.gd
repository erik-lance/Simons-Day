extends Node2D

signal game_done(r)
var game_result = 0

onready var simon = $Simon
onready var person_slot = $Challenger

onready var anim = $AnimationPlayer
onready var type_game = $TypeHandler

onready var cell_manager = $CellManager
onready var health_bars = $Intro/HBars

onready var shader_window = $Intro/ShaderEffects

var cur_stage = 1
var cur_cell = 0

# Stage Numbers
var cell_1 = 1
var cell_2 = 2
var cell_3 = 3

var hp = 100
var lives = 3 

# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("begin_game")
	type_game.connect("word_hit",self,'_on_word_hit')
	type_game.connect("finished_word",self,'_on_finished_word')
	cell_manager.connect("new_cell",self,'_on_CellManager_new_cell')
	cell_manager.connect("special_challenger",self,'_on_new_challenger')
	cell_manager.ready_freeplay()
	health_bars.ready_player_bar(hp)
	
	$Challenger.set_target(cell_manager.get_cur_cell().get_child(0).find_node('Challenger',true,false))
	load_challenger()
	
	

# This loads the challenger
func load_challenger():
	var hp = 20 + cur_stage*5
	$Challenger.set_new_hp(hp)
	health_bars.ready_enemy_bar(hp)

func _on_word_hit(word):
	if hp > 0:
		health_bars.player_damage(word.length())
		hp -= word.length()
		if hp <= 0:
			type_game.play_sound(5)
			simon.get_child(0).play('fail')
			type_game.pause_game()
			type_game.clear_words()
			
			game_result = health_bars.get_score()
			$Timer.start()

func _on_finished_word(word):
	$Challenger.take_hit(word.length())

func _on_CellManager_new_cell(cell, cast):
	$Challenger.set_target(cast)
	load_challenger()
	cell_manager.get_cur_cell_challenger()
	type_game.begin_game()
	$Simon/AnimatedSprite.play('idle')

func _on_new_challenger(type):
	type_game.set_skill(type, cur_stage, shader_window)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name ==  'begin_game':
		$TypeHandler.begin_game()
#		$Challenger.cur_target 

func _on_Challenger_defeated():
	# Since finished cell will loop back
	match(cur_cell):
		0:
			cell_1 += 3
			cur_cell = 1
		1:
			cell_2 += 3
			cur_cell = 2
		2:
			cell_3 += 3
			cur_cell = 0

	cur_stage += 1
	cell_manager.set_walking(true)
	$Simon/AnimatedSprite.play('walk')
	print('target: ')
	print($Challenger.get_target())
	$Challenger.get_target().find_node("AnimationPlayer").play("walk_away")
	type_game.clear_words()
	type_game.pause_game()
	
	health_bars.enemy_empty()
	


func _on_Challenger_damage(d):
	health_bars.enemy_damage(d)


func _on_Timer_timeout():
	emit_signal('game_done',game_result)
