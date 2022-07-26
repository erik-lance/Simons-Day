extends Control

onready var anim = $AnimationPlayer
onready var title = $CanvasLayer/Speaker/CenterContainer/Label
onready var text = $CanvasLayer/MainDiag/Label
onready var text_emotion = text.get_child(0)

onready var voice = $CanvasLayer/DialogueBlip

export (String, FILE, "*.json") var diag_script

var dialogues = []
var cur_line = 0

var voice_bank = {
	simon  =  load("res://assets/audio/maarte.wav"),
	flynn = load("res://assets/audio/unknown.wav")
}
var cur_voice

# Called when the node enters the scene tree for the first time.
func _ready():
	play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _input(event):
	if event.is_action_released("next_dialogue"):
		advance()

func play():
	dialogues = load_dialogue()
	title.text = dialogues[cur_line]['title']
	text.text = dialogues[cur_line]['text']

func advance():
	cur_line += 1
	
	if (cur_line < dialogues.size()):
		title.text = dialogues[cur_line]['title']
		text.text = dialogues[cur_line]['text']
		
		match(title.text):
			'Simon': cur_voice = voice_bank.simon
			'Flynn': cur_voice = voice_bank.flynn
		
		text_emotion.interpolate_property(
			text, "percent_visible",
			0.0, 1.0, 1.0, text_emotion.TRANS_LINEAR, text_emotion.EASE_IN_OUT
		)
		text_emotion.start()
	
	
	

func load_dialogue():
	var file = File.new()
	
	if file.file_exists(diag_script):
		file.open(diag_script, file.READ)
		return parse_json(file.get_as_text())
	else:
		print('Error, no file for dialogue manager.')


func _on_Tween_tween_step(object, key, elapsed, value):
	voice.stream = cur_voice
	voice.play()
	pass # Replace with function body.


func _on_AnimationPlayer_animation_finished(anim_name):
	pass # Replace with function body.
