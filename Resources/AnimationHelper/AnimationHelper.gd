class_name AnimationHelper
extends Resource

var flipped: bool = false
var going_right: bool 

func check_direction(player: Player, sprite: Sprite2D, arm: Sprite2D, light: PointLight2D, shadow: LightOccluder2D):
	if player.controller.horizonal_movement < 0:
		sprite.flip_h = true
		arm.flip_h = true
		arm.position = Vector2(-24, 1)
		arm.rotation_degrees = 30
		light.position = player.data.light_left
		shadow.occluder.set_cull_mode(OccluderPolygon2D.CULL_CLOCKWISE)
		shadow.occluder.polygon = player.data.polygon_left
	elif player.controller.horizonal_movement > 0:
		sprite.flip_h = false
		arm.flip_h = false
		arm.position = Vector2(7, 12)
		arm.rotation_degrees = -30
		light.position = player.data.light_right
		shadow.occluder.set_cull_mode(OccluderPolygon2D.CULL_COUNTER_CLOCKWISE)
		shadow.occluder.polygon = player.data.polygon_right
	pass

func rise(sprite: Sprite2D, arm: Sprite2D):
	if sprite.is_flipped_h():
		if sprite.rotation_degrees < 15:
			sprite.rotation_degrees += 1
	else:
		if sprite.rotation_degrees > -15:
			sprite.rotation_degrees -= 1

func fall(sprite: Sprite2D, arm: Sprite2D):
	if !sprite.is_flipped_h():
		if sprite.rotation_degrees < 15:
			sprite.rotation_degrees += 1
	else:
		if sprite.rotation_degrees > -15:
			sprite.rotation_degrees -= 1

func align(sprite: Sprite2D, arm: Sprite2D):
	sprite.rotation_degrees = 0
	if sprite.is_flipped_h():
		arm.rotation_degrees = 30
	else:
		arm.rotation_degrees = -30
	pass
