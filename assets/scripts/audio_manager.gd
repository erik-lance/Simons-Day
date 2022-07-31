extends Node2D

onready var audio = $Music

var sound_bank = {
	menu = load("res://assets/audio/music/main_menu.ogg"),
	game = load("res://assets/audio/music/freeplay.ogg")
}

var cur_song = null

# Called when the node enters the scene tree for the first time.
func _ready():
	cur_song =  sound_bank.menu
	audio.stream = cur_song
	audio.play()

func play_menu():
	cur_song = sound_bank.menu
	audio.stream = cur_song
	audio.play()

func play_game():
	cur_song = sound_bank.game
	audio.stream = cur_song
	audio.play()

func get_cur_song():
	return cur_song
