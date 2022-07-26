extends Node2D

onready var cur_words = $WordsContainer

var selected_word = null
var cur_letter_idx = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func retarget(ch):
	for word in cur_words.get_children():
		var text = word.get_word()
		var next_char = text.substr(0, 1)
		
		if next_char == ch:
			print("found new enemy that starts with %s" % next_char)
			selected_word = word
			cur_letter_idx = 1
			selected_word.set_next_character(cur_letter_idx)
			return



func _unhandled_input(event):
	if event is InputEventKey and not event.is_pressed(): 
		var typed_event = event as InputEventKey
		var key_typed = PoolByteArray([typed_event.unicode]).get_string_from_utf8()
		
		if selected_word == null:
			retarget()
		
