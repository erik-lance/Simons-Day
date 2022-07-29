extends Node2D

signal new_cell(cell, cast)

var class_cell = "res://scenes/cells/classroom_cell.tscn"
var locker_cell_1 = "res://scenes/cells/locker_cell.tscn"
var locker_cell_2 = "res://scenes/cells/locker_cell_2.tscn"
var window_cell = "res://scenes/cells/window_cell.tscn"
var broken_cell = "res://scenes/cells/broken_cell.tscn"

onready var cell = $Cells
onready var cell_1 = $Cells/Cell1
onready var cell_2 = $Cells/Cell2
onready var cell_3 = $Cells/Cell3

onready var cells = [cell_1, cell_2, cell_3]
var cur_cell = 0

var cast_unknown = "res://scenes/actors/unknown.tscn"
var cast_flynn = "res://scenes/actors/flynn.tscn"

var speed = 30

export (bool) var freeplay = true
export (bool) var walking = true

var stage_ahead = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (walking):
		cell_1.position.x -= speed*delta
		cell_2.position.x -= speed*delta
		cell_3.position.x -= speed*delta
		
		if cells[0].position.x <= -240:
			print('pre: ')
			print(cells)
			var move_cell = cells.pop_front()
			cells.append(move_cell)
			move_cell.position.x = cells[1].position.x + 240
			load_cell(move_cell, rand_cell())
			
			
			print('post: ')
			print(cells)

func rand_cell():
	var n = randi() % 5
	
	match(n):
		0: return class_cell
		1: return locker_cell_1
		2: return locker_cell_2
		3: return window_cell
		4: return broken_cell
	
func clear_cell(cell):
	cell.get_children()[0].queue_free()

# Loads cell at cell n with type c
func load_cell(cell,c):
	var loaded_cell = load(c).instance()
	
	clear_cell(cell)
	cell.add_child(loaded_cell)
	
	if !freeplay:
		add_actors(loaded_cell)
	else:
		add_actors(loaded_cell)
		var cast = load_unknown(loaded_cell)
		var challenger = load_challenger(loaded_cell, stage_ahead)
		emit_signal('new_cell',cells[0], challenger)

func add_actors(cell):
	var n = randi() % 5
	
	# Maximum of 5 actors
	for i in n:
		var unk_actor = load_unknown(cell)
		var x = randi() % 224 + 9
		# from 9 to 233 inclusive
		
		var y = randi() % 10
		y += 40
		
		unk_actor.position.x = x
		unk_actor.position.y = y

func load_unknown(cell):
	var loaded_cast = load(cast_unknown).instance()
	cell.add_child(loaded_cast)
	
	if !freeplay:
		var n = randi() % 2
		match(n):
			0: loaded_cast.get_child(0).animation = 'idle'
			1: loaded_cast.get_child(0).animation = 'talk'
		
		n = randi() % 2
		
		
		match(n):
			0: loaded_cast.get_child(0).flip_h = false
			1: loaded_cast.get_child(0).flip_h = true
	else:
		loaded_cast.get_child(0).animation = 'idle'
		loaded_cast.get_child(0).flip_h = true
	
	return loaded_cast

func load_special(cell):
	var loaded_cast = load(cast_flynn).instance()
	cell.add_child(loaded_cast)
	
	loaded_cast.get_child(0).animation = 'idle'
	loaded_cast.get_child(0).flip_h = true
	
	return loaded_cast

func load_challenger(cell, stage=4):
	# Every 5 stages is special
	var actor = null
	var cell_num = stage % 3
	
	if (stage+1) % 5 != 0:
		actor = load_unknown(cell)
		
		actor.position.x = 186
		actor.position.y = 70
		
	else:
		actor = load_special(cell)
		
		# walk in anim na lang
		actor.position.x = 186
		actor.position.y = 70
		
	actor.set_name("Challenger")
	stage_ahead += 1

func set_walking(t):
	walking = t
