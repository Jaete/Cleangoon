class_name Player
extends RigidBody2D

@onready var controller: PlayerController = $PlayerController
@onready var animation: AnimationHelper = $AnimationHelper

const V_SPEED: float = 200.0
const H_SPEED: float = 200.0
const LEFT: float = -1.0
const RIGHT: float = 1.0
const STOP: float = 0.0

var v_direction: float = 0.0
var h_direction: float = 0.0
var boosting: bool = true

func _ready():
	mass = 0.5
	gravity_scale = 0.3
	

func _physics_process(delta):
	process_input()
	animation.check_direction()
	move(boosting)
	if v_direction != 0:
		animation.rise()
	elif v_direction == 0 && linear_velocity.y > 5:
		animation.fall()
	else:
		animation.align()
	
	pass

func process_input():
	#Check vertical movement direction
	if Input.is_action_pressed("Rise"):
		v_direction = -1
	else:
		v_direction = 0
	#Check if trying to boost
	if Input.is_action_pressed("Boost"):
		boosting = true
	else:
		boosting = false
	#Check horizontal movement direction
	if Input.is_action_pressed("Move_Left"):
		h_direction = -1
	elif Input.is_action_pressed("Move_Right"):
		h_direction = 1
	elif !Input.is_action_pressed("Move_Left") && !Input.is_action_pressed("Move_Right"):
		h_direction = 0
	pass

func move(is_boosting: bool):
	if h_direction == STOP:
		constant_force.x = 0
	if v_direction == STOP:
		constant_force.y = 0
	if linear_velocity.x > H_SPEED / 2 || linear_velocity.x < -(H_SPEED / 2):
		linear_velocity.x = H_SPEED / 2 * h_direction
	else:
		apply_central_force(Vector2(h_direction * H_SPEED, STOP))
	if linear_velocity.y <= -(V_SPEED / 2) && v_direction != 0:
		linear_velocity.y = V_SPEED / 2 * v_direction
	elif linear_velocity.y >= (V_SPEED / 2) && v_direction == 0:
		linear_velocity.y = V_SPEED / 2
	else:
		apply_central_force(Vector2(STOP, v_direction * V_SPEED))
	pass
