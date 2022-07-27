extends Node2D

onready var pos_words_file = "res://assets/data/positive_adjectives.txt"
var pos_words = {}

onready var cur_words = $WordsContainer

onready var audio = $AudioStreamPlayer
var sound_bank = {
	good = load("res://assets/audio/highrobo.wav"),
	bad = load("res://assets/audio/bad_action.wav"),
	done = load("res://assets/audio/complete_action.wav")
}

var selected_word = null
var cur_letter_idx = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	
	# Loads all words into pos_words array
	var f = File.new()
	var idx = 0
	f.open(pos_words_file, File.READ)
	
	while not  f.eof_reached():
		var line = f.get_line()
		pos_words[idx] = line
		idx += 1
	f.close()
	

func begin_game():
	$Timer.start()
	$Timer2.start()

func word_burst():
	$Timer.wait_time = 2.2
	$Timer2.wait_time = 1.4
	pass

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
				play_sound(1)
				cur_letter_idx += 1
				selected_word.set_next_character(cur_letter_idx)
				
				# If completed word
				if cur_letter_idx == word.length():
					play_sound(2)
					cur_letter_idx = -1
					selected_word.queue_free()
					selected_word = null
			else:
				play_sound(0)
				print('Type fail.')
		


func play_sound(success):
	match(success):
		0: audio.stream = sound_bank.bad
		1: audio.stream = sound_bank.good
		2: audio.stream = sound_bank.done
	audio.play()

func instantiate_word():
	var n = randi() % 960
	var y = randi() % 50 + 1
	var x = 256
	y += 40
	
	var loaded_word = load("res://scenes/typing/word.tscn").instance()
	cur_words.add_child(loaded_word)
	loaded_word.set_word(pos_words[n])
	loaded_word.position.y = y
	

func _on_Timer_timeout():
	instantiate_word()

func _on_Timer2_timeout():
	instantiate_word()


