class_name AnimationHelper
extends Node

@onready var player: Player = $".."
@onready var sprite: Sprite2D = $"../Sprite2D"

func check_direction():
	if player.linear_velocity.x < 0:
		sprite.flip_h = true
	elif player.linear_velocity.x > 0:
		sprite.flip_h = false
	pass

func rise():
	if sprite.is_flipped_h():
		if sprite.rotation_degrees < 15:
			sprite.rotation_degrees += 1
	else:
		if sprite.rotation_degrees > -15:
			sprite.rotation_degrees -= 1

func fall():
	if !sprite.is_flipped_h():
		if sprite.rotation_degrees < 15:
			sprite.rotation_degrees += 1
	else:
		if sprite.rotation_degrees > -15:
			sprite.rotation_degrees -= 1

func align():
	sprite.rotation_degrees = 0
