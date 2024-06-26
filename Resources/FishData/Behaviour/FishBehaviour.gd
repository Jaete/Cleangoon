class_name FishBehaviour
extends Resource

signal point_reached()
signal turn()

@export var weight: float
@export var V_MAX_SPEED: float = 100.0
@export var  V_ACCELERATION: float = 250.0
@export var  H_MAX_SPEED: float = 100.0
@export var  H_ACCELERATION: float = 150.0

var spawn_point: Vector2
var last_seen_coords: Vector2
var triggered: bool
var target: RigidBody2D
var player_direction: Vector2
var returning_to_spawn: bool
var searching: bool
var wandering: bool
var wander_direction: int = 1
var near_object: bool
var cannot_go_down: bool
var cannot_go_up: bool
var wall_on_left: bool
var wall_on_right: bool

func follow(fish: Fish, point: Vector2):
	var x_distance: float = fish.global_position.x - point.x
	var y_distance: float = fish.global_position.y - point.y
	var vertical_movement: int
	var horizontal_movement: int
	if !near_object || triggered:
		if x_distance > 0 && y_distance > 0:
			horizontal_movement = -1
			vertical_movement = -1
		if x_distance < 0 && y_distance > 0:
			horizontal_movement = 1
			vertical_movement = -1
		if x_distance > 0 && y_distance < 0:
			horizontal_movement = -1
			vertical_movement = 1
		if x_distance < 0 && y_distance < 0:
			horizontal_movement = 1
			vertical_movement = 1
	else:
		if wall_on_left && wall_on_right && cannot_go_down:
			horizontal_movement = 0
			vertical_movement = -1
		elif wall_on_left && wall_on_right && cannot_go_up:
			horizontal_movement = 0
			vertical_movement = 1
		elif wall_on_left && wall_on_right:
			horizontal_movement = 0
		elif wall_on_left:
			horizontal_movement = 1
		elif wall_on_right:
			horizontal_movement = -1
	accelerate(fish, horizontal_movement, vertical_movement)
	fish.sprite.look_at(point)
	if fish.sprite.rotation_degrees < 90:
		fish.sprite.rotation_degrees += 45
	else:
		fish.sprite.rotation_degrees -= 45
	if fish.sprite.rotation_degrees > 180:
		fish.sprite.rotation_degrees = 0
	if fish.sprite.rotation_degrees > 90:
		fish.sprite.flip_v = true
	else:
		fish.sprite.flip_v = false
	pass

func wander(fish: Fish):
	if fish.global_position.y > spawn_point.y:
		accelerate(fish, wander_direction, -1)
	if fish.global_position.y < spawn_point.y:
		accelerate(fish, wander_direction, 1)
	if wander_direction > 0:
		fish.sprite.flip_h = false
		fish.sprite.flip_v = false
		fish.sprite.rotation_degrees = 45
	else:
		#fish.sprite.flip_h = true
		fish.sprite.flip_v = true
		fish.sprite.rotation_degrees = 135
	pass

func accelerate(fish: RigidBody2D, direction_x: float, direction_y):
	if abs(fish.linear_velocity.x) >= H_MAX_SPEED && abs(fish.linear_velocity.y) < V_MAX_SPEED:
		fish.linear_velocity.x = H_MAX_SPEED * direction_x
		fish.apply_central_force(Vector2(0, V_ACCELERATION * direction_y))
	elif abs(fish.linear_velocity.y) >= V_MAX_SPEED && abs(fish.linear_velocity.x) < H_MAX_SPEED:
		fish.linear_velocity.y = V_MAX_SPEED * direction_y
		fish.apply_central_force(Vector2(H_ACCELERATION * direction_x, 0))
	elif abs(fish.linear_velocity.x) >= H_MAX_SPEED && abs(fish.linear_velocity.y) >= V_MAX_SPEED:
		fish.linear_velocity.x = H_MAX_SPEED * direction_x
		fish.linear_velocity.y = V_MAX_SPEED * direction_y
	else:
		fish.apply_central_force(Vector2(H_ACCELERATION * direction_x, V_ACCELERATION * direction_y))

func spawn_point_reached(fish: Fish):
	var spawn_distance_x: float = fish.global_position.x - fish.behaviour.spawn_point.x
	var spawn_distance_y: float = fish.global_position.y - fish.behaviour.spawn_point.y
	if spawn_distance_x < randi_range(1,10) && spawn_distance_y < randi_range(1,10):
		returning_to_spawn = false
		cannot_go_down = false
		point_reached.emit(fish.sight)
	pass

func search_point_reached(fish: Fish):
	var search_distance_x: float = fish.global_position.x - fish.spawn_point.x
	var search_distance_y: float = fish.global_position.y - fish.spawn_point.y
	if search_distance_x < randi_range(1,10) && search_distance_y < randi_range(1,10):
		returning_to_spawn = false
		point_reached.emit(fish.sight)
	pass

func seek_player(sight: Area2D):
	var bodies: Array[Node2D] = sight.get_overlapping_bodies()
	for body in bodies:
		if body is Player:
			triggered = true
			returning_to_spawn = false
	pass

func flip(fish: Fish):
	fish.mouth_shape.position.x *= -1
	fish.get_node("Top").position.x *= -1
	pass
