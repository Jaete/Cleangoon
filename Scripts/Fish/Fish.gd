class_name Fish
extends RigidBody2D

@onready var down_ray: RayCast2D = $Down
@onready var top_ray: RayCast2D = $Top
@onready var left_ray: RayCast2D = $Left
@onready var right_ray: RayCast2D = $Right

@onready var return_left: RayCast2D = $ReturnWallDetect/ReturnLeft
@onready var return_right: RayCast2D = $ReturnWallDetect/ReturnRight
@onready var return_top: RayCast2D = $ReturnWallDetect/ReturnTop
@onready var return_down = $ReturnWallDetect/ReturnDown

@export_category("Data")
@export var fish_data: FishData

@export_category("Composition")
@export var mouth_shape: CollisionShape2D
@export var sight_shape_left: CollisionPolygon2D
@export var sight_shape_right: CollisionPolygon2D
@export var sight: Area2D

@export_category("Animation Helper")
@export var animation: AnimationHelper
@export var sprite: Sprite2D

@export_category("Behaviour")
@export var behaviour: FishBehaviour
var flipping: bool



func _ready():
	fish_data.initialize()
	sprite.texture = fish_data.sprite_texture
	mouth_shape.position = fish_data.mouth_position
	sight_shape_left.polygon = fish_data.sight_polygon_left.segments
	sight_shape_right.polygon = fish_data.sight_polygon_right.segments
	sight_shape_left.disabled = true
	sight_shape_right.disabled = false
	sight.position.x += fish_data.sight_offset_x
	sight.position.y += fish_data.SIGHT_OFFSET_Y
	mass = 0.5
	gravity_scale = 0.3
	behaviour.wandering = true
	behaviour.spawn_point = global_position
	behaviour.point_reached.connect(behaviour.seek_player)
	behaviour.turn.connect(behaviour.flip)

func _physics_process(_delta):
	if behaviour.triggered:
		behaviour.follow(self, get_node("/root/Game/LevelManager/Level/Player").global_position)
	if behaviour.returning_to_spawn && !behaviour.triggered:
		behaviour.follow(self, behaviour.spawn_point)
		behaviour.spawn_point_reached(self)
	if behaviour.searching && !behaviour.triggered && !behaviour.returning_to_spawn:
		behaviour.follow(self, behaviour.last_seen_coords)
		behaviour.search_point_reached(self)
	if !behaviour.returning_to_spawn && !behaviour.triggered && !behaviour.searching:
		behaviour.wander(self)
	if flipping:
		sight_shape_left.disabled = !sight_shape_left.disabled
		sight_shape_right.disabled = !sight_shape_right.disabled
		flipping = false
	pass

func _on_sight(body):
	detect(body)
	pass

func _on_mouth_area_entered(area):
	if area.name == "SurfaceWater":
		behaviour.triggered = false
		behaviour.returning_to_spawn = true
	pass

func _on_sight_left(body):
	detect(body)
	pass

func detect(body):
	if body is Player && !behaviour.returning_to_spawn && !$Top.get_collider() is StaticBody2D:
		behaviour.wandering = false
		behaviour.triggered = true
		behaviour.target = body
	#if body is StaticBody2D && !behaviour.triggered:
		#behaviour.wander_direction *= -1
		#behaviour.turn.emit(self)
		#flipping = true

func _on_body_entered(body):
	if body is Player:
		behaviour.wandering = false
		behaviour.triggered = true
		behaviour.target = body
	if body is StaticBody2D && behaviour.returning_to_spawn:
		$StuckTimer.start()
	pass

func _on_right_collided(collider):
	turn(collider)
	pass

func _on_left_collided(collider):
	turn(collider)
	pass

func turn(collider):
	if (collider is StaticBody2D || collider is Trash) && !behaviour.triggered:
		behaviour.wander_direction *= -1
		behaviour.turn.emit(self)
		flipping = true


func _on_wall_detect_body_entered(body):
	if !body is Player:
		if body is StaticBody2D || body is Trash && !behaviour.triggered && behaviour.returning_to_spawn:
			behaviour.near_object = true
	pass # Replace with function body.


func _on_wall_detect_body_exited(body):
	if body is StaticBody2D || body is Trash && !behaviour.triggered && behaviour.returning_to_spawn:
		behaviour.near_object = false
	pass # Replace with function body.

func _on_return_left_collided(collider):
	if collider is StaticBody2D || collider is Trash:
		behaviour.wall_on_right = true

func _on_return_right_collided(collider):
	if collider is StaticBody2D || collider is Trash:
		behaviour.wall_on_left = true

func _on_return_right_stop_colliding():
	behaviour.wall_on_right = false

func _on_return_left_stop_colliding():
	behaviour.wall_on_left = false



func _on_return_down_stop_colliding():
	behaviour.cannot_go_down = false
	pass # Replace with function body.


func _on_return_down_collided(collider):
	if collider is StaticBody2D:
		behaviour.cannot_go_down = true
	pass # Replace with function body.


func _on_return_top_collided(collider):
	if collider is StaticBody2D:
		behaviour.cannot_go_down = true
	pass # Replace with function body.


func _on_return_top_stop_colliding():
	behaviour.cannot_go_down = false
	pass # Replace with function body.

func _on_stuck_timer_timeout():
	global_position = behaviour.spawn_point
	behaviour.spawn_point_reached(self)
	pass # Replace with function body.
