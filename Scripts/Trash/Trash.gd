class_name Trash
extends Node2D

@export_category("Object data")
@export var trash_data: TrashData
@export var sprite: Sprite2D
@export var body: CollisionShape2D
@export var interactable_area: CollisionShape2D

var is_on_ground: bool

func _ready():
	trash_data.initialize()
	sprite.texture = trash_data.lifted_texture
	body.shape = trash_data.shape
	sprite.offset = trash_data.offset
	interactable_area.shape = trash_data.interaction_area
	

func _on_body_entered(body):
	if body is TileMap:
		sprite.texture = trash_data.ground_texture
	pass # Replace with function body.

func _on_body_exited(body):
	if body is TileMap:
		sprite.texture = trash_data.lifted_texture
	pass # Replace with function body.
