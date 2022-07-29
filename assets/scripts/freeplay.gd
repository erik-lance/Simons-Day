extends Node2D


onready var simon = $Simon
onready var person_slot = $Challenger

onready var anim = $AnimationPlayer
onready var type_game = $TypeHandler

onready var cell_manager = $CellManager

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
	
	$Challenger.set_target(cell_manager.get_cur_cell().get_child(0).find_node('Challenger',true,false))
	load_challenger()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# This loads the challenger
func load_challenger():
	$Challenger.set_new_hp(20 + cur_stage*5)

func _on_word_hit(word):
	print('BEEN HIT')
	print(word)

func _on_finished_word(word):
	$Challenger.take_hit(word.length())
	pass

func _on_CellManager_new_cell(cell, cast):
	print('new_cell!')
	$Challenger.set_target(cast)
	load_challenger()
	cell_manager.get_cur_cell_challenger()
	type_game.begin_game()
	$Simon/AnimatedSprite.play('idle')

func _on_new_challenger(type):
	type_game.set_skill(type)

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
	
