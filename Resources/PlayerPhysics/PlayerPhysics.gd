class_name PlayerPhysics
extends Resource

@export var V_MAX_SPEED: float = 100.0
@export var  V_ACCELERATION: float = 250.0
@export var  H_MAX_SPEED: float = 100.0
@export var  H_ACCELERATION: float = 150.0
@export var H_BOOST_SPEED: float = 300.0
@export var H_BOOST_ACCELERATION = 220.0
@export var V_BOOST_SPEED: float = 200.0
@export var V_BOOST_ACCELERATION: float = 350.0

const LEFT: float = -1.0
const RIGHT: float = 1.0
const STOP: float = 0.0

func move(player: Player, _is_boosting: bool, h_movement: int, v_movement: int):
	if !_is_boosting:
		accelerate(player, H_MAX_SPEED, H_ACCELERATION, V_MAX_SPEED, V_ACCELERATION, h_movement, v_movement)
	else:
		accelerate(player, H_BOOST_SPEED,H_BOOST_ACCELERATION, V_BOOST_SPEED, V_BOOST_ACCELERATION, h_movement, v_movement)
	pass

func accelerate(player: Player, h_speed: float, accel: float, v_speed: float, v_accel: float, h_movement, v_movement):
	if abs(player.linear_velocity.x) > (h_speed):
		if player.linear_velocity.x >= 0:
			player.linear_velocity.x -= h_speed * player.get_physics_process_delta_time() * 5
		elif player.linear_velocity.x <= 0:
			player.linear_velocity.x += h_speed * player.get_physics_process_delta_time() * 5
		#elif player.controller.horizonal_movement != 0 && player.linear_velocity.x - h_speed * h_movement < h_speed:
			#player.linear_velocity.x -= h_speed * h_movement
		#else:
			#player.linear_velocity.x = h_speed * h_movement
	else:
		player.apply_central_force(Vector2(h_movement * accel, 0))
	if v_movement == 1:
		player.constant_force.y = 0
	else:
		if player.linear_velocity.y <= -(v_speed):
			player.constant_force.y = -(v_speed)
		else:
			
			player.apply_central_force(Vector2(0, v_movement * v_accel))
