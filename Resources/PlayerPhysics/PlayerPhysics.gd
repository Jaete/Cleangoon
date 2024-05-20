class_name PlayerPhysics
extends Resource

@export var V_MAX_SPEED: float = 100.0
@export var  V_ACCELERATION: float = 250.0
@export var  H_MAX_SPEED: float = 100.0
@export var  H_ACCELERATION: float = 150.0

const LEFT: float = -1.0
const RIGHT: float = 1.0
const STOP: float = 0.0

func move(player: Player, is_boosting: bool, h_movement: int, v_movement: int):
	if abs(player.linear_velocity.x) >= (H_MAX_SPEED):
		if player.controller.horizonal_movement == 0 && player.linear_velocity.x >= 0:
			player.linear_velocity.x -= H_MAX_SPEED * player.get_physics_process_delta_time()
		elif player.controller.horizonal_movement == 0 && player.linear_velocity.x <= 0:
			player.linear_velocity.x += H_MAX_SPEED * player.get_physics_process_delta_time()
		else:
			player.linear_velocity.x = H_MAX_SPEED * h_movement
	else:
		player.apply_central_force(Vector2(h_movement * H_ACCELERATION, 0))
	if v_movement == 1:
		player.constant_force.y = 0
	else:
		if player.linear_velocity.y <= -(V_MAX_SPEED):
			player.constant_force.y = -(V_MAX_SPEED)
		else:
			player.apply_central_force(Vector2(0, v_movement * V_ACCELERATION))
	pass
