extends Control

@onready var propulse: Sprite2D = $space
@onready var a_button: Sprite2D = $KeyboardLettersAndSymbols

@onready var space_icon: Texture2D = preload("res://Assets/UI/space-icon.png")
@onready var key_a_icon: Texture2D = preload("res://Assets/UI/Keyboard Letters and Symbols.png")
@onready var joy_icons: Texture2D = preload("res://Assets/UI/gdb-xbox-2.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	if Input.get_connected_joypads().size() == 0:
		set_keyboard_icon()
	else:
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
	propulse.texture = space_icon
	propulse.scale = Vector2(0.6, 0.6)
	propulse.region_enabled = false
	a_button.texture = key_a_icon
	a_button.region_enabled = true
	a_button.region_rect = Rect2(0, 32, 16, 16)
	pass

func set_joypad_icon():
	propulse.texture = joy_icons
	propulse.scale = Vector2(2.5, 2.5)
	propulse.region_enabled = true
	propulse.region_rect = Rect2(336, 66, 16, 16)
	a_button.texture = joy_icons
	a_button.region_enabled = true
	a_button.region_rect = Rect2(16, 48, 16, 16)
	pass
