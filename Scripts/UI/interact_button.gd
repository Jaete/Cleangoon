extends Sprite2D

var key_a_icon: Texture2D = preload("res://Assets/UI/Keyboard Letters and Symbols.png")
var joy_a_icon: Texture2D = preload("res://Assets/UI/gdb-xbox-2.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	if get_node("/root/Game").keyboard_mode:
		set_keyboard_icon()
	if get_node("/root/Game").joypad_mode:
		set_joypad_icon()
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouse:
		set_keyboard_icon()
	if event is InputEventKey:
		set_keyboard_icon()
	if event is InputEventJoypadButton || event is InputEventJoypadMotion:
		set_joypad_icon()

func set_keyboard_icon():
	$".".texture = key_a_icon
	$".".region_enabled = true
	$".".region_rect = Rect2(0, 32, 16, 16)

func set_joypad_icon():
	$".".texture = joy_a_icon
	$".".region_enabled = true
	$".".region_rect = Rect2(16, 48, 16, 16)
