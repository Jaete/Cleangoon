class_name Player
extends RigidBody2D

signal player_grabbed_trash()
signal player_released_trash()
signal player_delivered_trash()

@export_category("Physics Movement")
@export var physics: PlayerPhysics
@export_category("Player Controller")
@export var controller: PlayerController
@export_category("Animation Helper")
@export var animation: AnimationHelper
@export var sprite: Sprite2D
@export_category("Player Data")
@export var data: PlayerData

var nearby_trash: bool = false
var carrying_trash: bool = false
var trash_carried: Trash
var about_to_deliver: bool

func _ready():
	mass = 0.5
	gravity_scale = 0.3

func _physics_process(delta):
	controller.get_input()
	animation.check_direction(self, sprite)
	handle_physics()
	rotate_player()
	check_for_actions()
	pass

func rotate_player():
	if controller.vertical_movement < 0:
		animation.rise(sprite)
	elif controller.vertical_movement > 0 && linear_velocity.y > 0:
		animation.fall(sprite)
	else:
		animation.align(sprite)

func handle_physics():
	physics.move(self, controller.is_boosting, controller.horizonal_movement, controller.vertical_movement)
	if controller.is_stopped() && abs(linear_velocity.x) >= 0.1 && get_contact_count() > 0:
		sleeping = true
	else:
		sleeping = false

func check_for_actions():
	if controller.input_action == controller.GRAB && carrying_trash:
		carrying_trash = false
		player_released_trash.emit(trash_carried)
	elif controller.input_action == controller.GRAB && !carrying_trash && nearby_trash:
		player_grabbed_trash.emit()
		carrying_trash = true
		controller.get_input()
	if about_to_deliver && controller.input_action == controller.GRAB:
		player_delivered_trash.emit(self)

func _process(delta):
	pass

func _on_body_entered(body):
	pass # Replace with function body.
