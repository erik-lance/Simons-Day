extends Node2D

onready var pos_words = "res://assets/data/positive_adjectives.txt"
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
			selected_word = word
			cur_letter_idx = 1
			selected_word.set_next_character(cur_letter_idx)
			return



func _unhandled_input(event):
	if event is InputEventKey and not event.is_pressed() and not event.is_echo(): 
		var typed_event = event as InputEventKey
		var key_typed = PoolByteArray([typed_event.scancode]).get_string_from_utf8().to_lower()

		if selected_word == null:
			retarget(key_typed)
		else:
			var word = selected_word.get_word()
			var next_ch = word.substr(cur_letter_idx,1)
			if key_typed == next_ch:
				cur_letter_idx += 1
				selected_word.set_next_character(cur_letter_idx)
				
				# If completed word
				if cur_letter_idx == word.length():
					cur_letter_idx = -1
					selected_word.queue_free()
					selected_word = null
			else:
				print('Type fail.')
		





