class_name Player
extends RigidBody2D

@export_category("Physics Movement")
@export var physics: PlayerPhysics
@export_category("Player Controller")
@export var controller: PlayerController
@export_category("Animation Helper")
@export var animation: AnimationHelper
@export var sprite: Sprite2D
@export_category("Player Data")
@export var data: PlayerData

func _ready():
	mass = 0.5
	gravity_scale = 0.3

func _physics_process(delta):
	controller.get_input()
	animation.check_direction(self, sprite)
	physics.move(self, controller.is_boosting, controller.horizonal_movement, controller.vertical_movement)
	if controller.vertical_movement < 0:
		animation.rise(sprite)
	elif controller.vertical_movement > 0 && linear_velocity.y > 0:
		animation.fall(sprite)
	else:
		animation.align(sprite)
	pass
