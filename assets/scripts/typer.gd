extends Node2D

signal word_hit(w)
signal finished_word(w)

onready var pos_words_file = "res://assets/data/positive_adjectives.txt"
var pos_words = {}

onready var cur_words = $WordsContainer

onready var audio = $AudioStreamPlayer
var sound_bank = {
	good = load("res://assets/audio/highrobo.wav"),
	bad = load("res://assets/audio/bad_action.wav"),
	done = load("res://assets/audio/complete_action.wav"),
	small_hit = load("res://assets/audio/small_hit.wav"),
	deep_hit = load("res://assets/audio/deep_hit.wav")
}

var selected_word = null
var cur_letter_idx = -1

var cur_skill = 0
var skill_activate = false

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

func pause_game():
	$Timer.stop()
	$Timer2.stop()

func word_burst():
	$Timer.wait_time = 2.2
	$Timer2.wait_time = 1.4
	pass

func flynn_boost(d=1):
	for word in cur_words.get_children():
		word.set_speed(word.get_orig_speed() + 15*d)
	
func laura_invis():
	for word in cur_words.get_children():
		word.get_anim_player().play('invis')

func stop_abilities():
	for word in cur_words.get_children():
		word.return_orig_speed()
		word.get_anim_player().play('idle')

# 0 - None
# 1 - Flynn
# 2 - Laura
func set_skill(s=0):
	cur_skill = s
	$Timer3.start()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func retarget(ch):
	for word in cur_words.get_children():
		var text = word.get_word()
		var next_char = text.substr(0, 1)
		
		if next_char == ch:
			selected_word = word
			play_sound(1)
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
					
					emit_signal('finished_word',word)
					
					selected_word.queue_free()
					selected_word = null
					
			else:
				play_sound(0)
				selected_word.stutter()
		

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

func clear_words():
	for word in cur_words.get_children():
		word.queue_free()

func _on_Timer_timeout():
	instantiate_word()

func _on_Timer2_timeout():
	instantiate_word()

func _on_StaticBody2D_area_entered(area):
	emit_signal("word_hit",area.get_parent().get_word())
#	selected_word.queue_free()
	selected_word = null
	cur_letter_idx = -1

# Returns to normal
func _on_Timer3_timeout():
	print('SKILL!!!')
	print(cur_skill)
	if cur_skill > 0:
		if !skill_activate:
			match(cur_skill):
				1: flynn_boost()
				2: laura_invis()
			$Timer3.start()
		else:
			stop_abilities()
			$Timer3.start()

		skill_activate = !skill_activate
