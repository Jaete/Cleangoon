class_name PlayerController
extends Node

enum Controls {
	MOVE_LEFT = 1,
	MOVE_RIGHT = -1,
	RISE = 2,
	BOOST_LEFT = 3,
	BOOST_RIGHT = 4,
	STOPPED = 0
}

var current_action: int = 0



func get_input():
	if Input.is_action_pressed("Rise"):
		current_action = Controls.RISE
	elif Input.is_action_pressed("Boost"):
		if Input.is_action_pressed("Move_Left"):
			current_action = Controls.BOOST_LEFT
		elif Input.is_action_pressed("Move_Right"):
			current_action = Controls.BOOST_RIGHT
		return
	elif Input.is_action_pressed("Move_Left"):
		current_action = Controls.MOVE_LEFT
		return
	elif Input.is_action_pressed("Move_Right"):
		current_action = Controls.MOVE_RIGHT
		return
	else:
		current_action = Controls.STOPPED
	
