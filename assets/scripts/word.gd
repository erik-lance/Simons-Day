extends Node2D

export (Color) var blue = Color("#4682b4")
export (Color) var green = Color("#639765")
export (Color) var red = Color("#a65455")

export (String) var word
onready var text = $Label
onready var code_text = text.text

export (int) var orig_speed = 10
export (int) var speed = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	set_word(word)

func get_anim_player(): return $AnimationPlayer
func return_orig_speed(): speed = orig_speed
func get_orig_speed(): return orig_speed
func set_orig_speed(s): orig_speed = s
func set_speed(s): speed = s

func get_word(): return word
func set_word(w):
	word = w
	set_label()

func _physics_process(delta):
	self.position.x -= speed*delta

func set_label():
	var size = text.get_font("font").get_string_size(word)
	text.rect_size.x = size.x + 1
	text.rect_position.x = -size.x / 2
	text.rect_position.y = -size.y / 2 + -size.y
	
	var shape = RectangleShape2D.new()
	shape.set_extents(Vector2(size.x / 2, size.y / 2))
	$Area2D/CollisionShape2D.set_shape(shape)
	
	code_text = word
	text.parse_bbcode(set_center_tags(code_text))

# Code for setting the bbcode
func set_next_character(next_ch_idx: int):
	var blue_text = get_bbcode_color_tag(blue) + code_text.substr(0, next_ch_idx) + get_bbcode_end_color_tag()
	var green_text = get_bbcode_color_tag(green) + code_text.substr(next_ch_idx, 1) + get_bbcode_end_color_tag()
	var red_text = ""

	if next_ch_idx != code_text.length():
		self.z_index = 50
		red_text = get_bbcode_color_tag(red) + code_text.substr(next_ch_idx + 1, code_text.length() - next_ch_idx + 1) + get_bbcode_end_color_tag()

	text.parse_bbcode(set_center_tags(blue_text + green_text + red_text))

func set_center_tags(string_to_center: String):
	return "[center]\n" + string_to_center + "[/center]"


func get_bbcode_color_tag(color: Color) -> String:
	return "[color=#" + color.to_html(false) + "]"


func get_bbcode_end_color_tag() -> String:
	return "[/color]"

func stutter(s = 50):
	speed = s
	$Timer.start()

func _on_Timer_timeout():
	speed = orig_speed
