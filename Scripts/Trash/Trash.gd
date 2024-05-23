class_name Trash
extends Node2D

signal player_entered_interaction_range()
signal player_left_interaction_range()
signal player_dropped_trash()

@export_category("Object data")
@export var trash_data: TrashData
@export var sprite: Sprite2D
@export var body: CollisionShape2D
@export var physics_body: RigidBody2D
@export var interactable_area: CollisionShape2D

var is_on_ground: bool

func _ready():
	trash_data.initialize()
	sprite.texture = trash_data.lifted_texture
	body.shape = trash_data.shape
	sprite.offset = trash_data.offset
	interactable_area.shape = trash_data.interaction_area

func _physics_process(delta):
	var parent: Node2D = get_parent()
	if parent is Player:
		global_position = parent.global_position
		if parent.sprite.is_flipped_h():
			global_position.x -= 28
		else:
			global_position.x += 28
		global_position.y += 28

func _on_body_entered(body):
	if body is TileMap:
		sprite.texture = trash_data.ground_texture
		player_dropped_trash.emit(self)
		is_on_ground = true
	pass

func _on_body_exited(body):
	if body is TileMap:
		sprite.texture = trash_data.lifted_texture
		is_on_ground = false
	pass

func _on_interactable_area_body_entered(body):
	if body is Player:
		player_entered_interaction_range.emit(self)
	pass

func _on_interactable_area_body_exited(body):
	if body is Player:
		player_left_interaction_range.emit(self)
	pass
