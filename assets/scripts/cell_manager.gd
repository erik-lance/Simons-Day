extends Node2D

var class_cell = "res://scenes/cells/classroom_cell.tscn"
var locker_cell_1 = "res://scenes/cells/locker_cell.tscn"
var locker_cell_2 = "res://scenes/cells/locker_cell_2.tscn"
var window_cell = "res://scenes/cells/window_cell.tscn"
var broken_cell = "res://scenes/cells/broken_cell.tscn"

onready var cell = $Cells
onready var cell_1 = $"Cells/Cell 1"
onready var cell_2 = $"Cells/Cell 2"
onready var cell_3 = $"Cells/Cell 3"

var cast_unknown = "res://scenes/actors/unknown.tscn"

var speed = 30
export (bool) var walking = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if (walking):
		cell_1.position.x -= speed*delta
		cell_2.position.x -= speed*delta
		cell_3.position.x -= speed*delta
		
		if (cell_1.position.x <= -240): 
			cell_1.position.x = cell_3.position.x + 240
			load_cell(0, rand_cell())
			
		if (cell_2.position.x <= -240): 
			cell_2.position.x = cell_1.position.x + 240
			load_cell(1, rand_cell())
			
		if (cell_3.position.x <= -240): 
			cell_3.position.x = cell_2.position.x + 240
			load_cell(2, rand_cell())
		

func rand_cell():
	var n = randi() % 5
	
	match(n):
		0: return class_cell
		1: return locker_cell_1
		2: return locker_cell_2
		3: return window_cell
		4: return broken_cell
	

# Loads cell at cell n with type c
func load_cell(n,c):
	var loaded_cell = load(c).instance()
	match(n):
		0: cell_1.get_children()[0].queue_free()
		1: cell_2.get_children()[0].queue_free()
		2: cell_3.get_children()[0].queue_free()
	
	match(n):
		0: cell_1.add_child(loaded_cell)
		1: cell_2.add_child(loaded_cell)
		2: cell_3.add_child(loaded_cell)
	
	add_actors(loaded_cell)

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
	
	var n = randi() % 2
	match(n):
		0: loaded_cast.get_child(0).animation = 'idle'
		1: loaded_cast.get_child(0).animation = 'talk'
	
	n = randi() % 2
	match(n):
		0: loaded_cast.get_child(0).flip_h = false
		1: loaded_cast.get_child(0).flip_h = true
	
	return loaded_cast

func set_walking(t):
	walking = t
