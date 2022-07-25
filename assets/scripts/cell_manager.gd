extends Node2D

var class_cell = "res://scenes/classroom_cell.tscn"
var locker_cell_1 = "res://scenes/locker_cell.tscn"
var locker_cell_2 = "res://scenes/locker_cell_2.tscn"
var window_cell = "res://scenes/window_cell.tscn"

onready var cell = $Cells
onready var cell_1 = $"Cells/Cell 1"
onready var cell_2 = $"Cells/Cell 2"
onready var cell_3 = $"Cells/Cell 3"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func load_cell(c):
	var loaded_cell = load(c).instance()
	cell.add_child(loaded_cell)
