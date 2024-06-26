class_name PlayerController
extends Resource

const UP: int = -1
const DOWN: int = 1
const LEFT: int = -1
const RIGHT: int = 1
const STOP: int = 0
const GRAB: int = 2

var vertical_movement: int = 0
var horizonal_movement: int = 0
var input_action: int = 0
var is_boosting: bool = false

var is_joypad_active: bool = false

func get_input():
	check_boost()
	get_vertical_movement()
	get_horizontal_movement()
	is_stopped()
	check_for_action()

func get_vertical_movement():
	if Input.is_action_pressed("Rise"):
		vertical_movement = UP
	else:
		vertical_movement = DOWN

func get_horizontal_movement():
	if Input.is_action_pressed("Move_Left") && Input.is_action_pressed("Move_Right"):
		horizonal_movement = STOP
	elif Input.is_action_pressed("Move_Left"):
		horizonal_movement = LEFT
	elif Input.is_action_pressed("Move_Right"):
		horizonal_movement = RIGHT
	elif !Input.is_action_pressed("Move_Left") && !Input.is_action_pressed("Move_Right"):
		horizonal_movement = STOP

func check_boost():
	if Input.is_action_just_pressed("Boost"):
		is_boosting = true
	else:
		is_boosting = false

func is_stopped() -> bool:
	if !Input.is_anything_pressed():
		return true
	return false

func check_for_action():
	if Input.is_action_just_pressed("Interact"):
		input_action = GRAB
	else:
		input_action = STOP
	pass

func joypad_active():
	if Input.get_connected_joypads().size() != 0:
		is_joypad_active = true
