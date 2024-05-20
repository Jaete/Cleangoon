class_name AnimationHelper
extends Resource

func check_direction(player: Player, sprite: Sprite2D):
	if player.controller.horizonal_movement < 0:
		sprite.flip_h = true
	elif player.controller.horizonal_movement > 0:
		sprite.flip_h = false
	pass

func rise(sprite: Sprite2D):
	if sprite.is_flipped_h():
		if sprite.rotation_degrees < 15:
			sprite.rotation_degrees += 1
	else:
		if sprite.rotation_degrees > -15:
			sprite.rotation_degrees -= 1

func fall(sprite: Sprite2D):
	if !sprite.is_flipped_h():
		if sprite.rotation_degrees < 15:
			sprite.rotation_degrees += 1
	else:
		if sprite.rotation_degrees > -15:
			sprite.rotation_degrees -= 1

func align(sprite: Sprite2D):
	sprite.rotation_degrees = 0
