extends Node2D

onready var cur_scene_node = $CurrentScene

var cur_scene
var scenes = {
	menu = "res://scenes/menu_scene.tscn",
	start = "res://scenes/hallway.tscn",
	tutorial = "res://scenes/tutorial.tscn",
	freeplay = "res://scenes/freeplay.tscn",
	settings = "res://scenes/settings.tscn",
	score = "res://scenes/score.tscn"
}

var hard_mode = false

func set_difficulty(d):
	if d == 0: hard_mode = false
	elif d == 1: hard_mode = true

# Called when the node enters the scene tree for the first time.
func _ready():
	cur_scene = scenes.menu
	cur_scene_node.get_child(0).connect('btn',self,'_on_signal_scene')

func remove_cur_scene():
	if cur_scene_node.get_children().size() > 0:
		for scene in cur_scene_node.get_children():
			scene.queue_free()

func _on_signal_scene(s):
	var cur_signal_scene = null
	print(s)
	
	match(s):
		'menu': cur_signal_scene = scenes.menu
		'start': cur_signal_scene = scenes.start
		'freeplay': cur_signal_scene = scenes.freeplay
		'tutorial': cur_signal_scene = scenes.tutorial
		'score': cur_signal_scene = scenes.score
		'settings': cur_signal_scene = scenes.settings
		'quit': get_tree().quit()
	
	if cur_signal_scene != null:
		cur_scene = cur_signal_scene
		load_scene(cur_scene)
	else:
		print('Exiting OR Unknown scene reached.')

func load_scene(scene):
	remove_cur_scene()
	
	var loaded_scene = load(scene).instance()
	cur_scene_node.add_child(loaded_scene)
	if  scene == scenes.freeplay:
		$AudioManager.play_game()
	elif scene == scenes.score:
		$AudioManager.play_menu()
	
	if scene == scenes.menu :
		loaded_scene.connect('btn',self,'_on_signal_scene')
	elif scene == scenes.settings:
		loaded_scene.connect('difficulty',self,'set_difficulty')
		loaded_scene.diff_slider(int(hard_mode))
		loaded_scene.connect('btn',self,'_on_signal_scene')
	elif scene == scenes.tutorial:
		loaded_scene.connect('btn',self,'_on_signal_scene')
	elif scene == scenes.freeplay:
		loaded_scene.connect('btn',self,'_on_signal_scene')
		loaded_scene.find_node('Pause').connect('btn',self,'_on_signal_scene')
		loaded_scene.connect('game_done',self,'game_done')
		if (hard_mode): loaded_scene.hard_mode()
		
	elif scene == scenes.score:
		loaded_scene.connect('btn',self,'_on_signal_scene')
		return loaded_scene
	else:
		print('Missing scene! '+str(scene))

func game_done(r):
	var score_scene = load_scene(scenes.score)
	score_scene.set_score(r)
