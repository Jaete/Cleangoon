class_name Fish
extends RigidBody2D

@export_category("Data")
@export var fish_data: FishData

@export_category("Composition")
@export var sprite: Sprite2D
@export var mouth_shape: CollisionShape2D
@export var sight: CollisionPolygon2D

@export_category("Behaviour")
@export var navigation_agent: NavigationAgent2D
var last_seen_coords: Vector2
var triggered: bool
var target: RigidBody2D

func _ready():
	fish_data.initialize()
	sprite.texture = fish_data.sprite_texture
	mouth_shape.position = fish_data.mouth_position
	sight.polygon = fish_data.sight_polygon.segments
	sight.position.x += fish_data.sight_offset_x
	sight.position.y += fish_data.SIGHT_OFFSET_Y
	mass = 0.5
	gravity_scale = 0.3

func _physics_process(delta):
	if triggered:
		follow(target)
	pass

func _on_sight(body):
	if body is Player:
		triggered = true
		target = body
	pass

func follow(body: RigidBody2D):
	var player_direction: Vector2
	player_direction.x = global_position.x - body.global_position.x
	player_direction.y = global_position.y - body.global_position.y
	if player_direction.x > 0:
		apply_central_force(Vector2(fish_data.horizontal_speed * -1, 0))
	else:
		apply_central_force(Vector2(fish_data.horizontal_speed, 0))
	if player_direction.y > 0:
		apply_central_force(Vector2(0, fish_data.vertical_speed * -1))
	else:
		apply_central_force(Vector2(0, fish_data.vertical_speed))
	look_at(body.global_position )
	#if player_direction.x < 0:
		#player_direction.x = -1
	#else:
		#player_direction.x = 1
	#if player_direction.y < 0:
		#player_direction.y = -1
	#else:
		#player_direction.y = 1
	#apply_central_force(Vector2(fish_data.horizontal_speed * player_direction.x, fish_data.vertical_speed * player_direction.y))
	pass

func _on_lost_sight(body):
	last_seen_coords = body.global_position
	if body is Player:
		search(last_seen_coords)
	pass

func search(coords: Vector2):
	pass
