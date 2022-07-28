extends Node2D


onready var simon = $Simon
onready var person_slot = $Challenger

onready var anim = $AnimationPlayer
onready var type_game = $TypeHandler

onready var cell_manager = $CellManager

var cur_stage = 0
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


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_word_hit(word):
	print('BEEN HIT')
	print(word)
	pass

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name ==  'begin_game':
		$TypeHandler.begin_game()

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
	
