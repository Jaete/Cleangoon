class_name PlayerController
extends Resource

const UP: int = -1
const DOWN: int = 1
const LEFT: int = -1
const RIGHT: int = 1
const STOP: int = 0

var vertical_movement: int = 0
var horizonal_movement: int = 0
var is_boosting: bool = false

func get_input():
	check_boost()
	get_vertical_movement()
	get_horizontal_movement()
	is_stopped()

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

func check_boost():
	if Input.is_action_pressed("Boost"):
		is_boosting = true
	else:
		is_boosting = false

func is_stopped():
	if !Input.is_anything_pressed():
		vertical_movement = STOP
		horizonal_movement = STOP
