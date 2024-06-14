class_name Trash
extends Node2D

signal player_entered_interaction_range()
signal player_left_interaction_range()
signal player_dropped_trash()

@export_category("Object data")
@export var trash_data: TrashData
@export var sprite: Sprite2D
@export var animated_sprite: AnimatedSprite2D 
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
	if trash_data.is_chemical:
		sprite.visible = false
		animated_sprite.visible = true
		animated_sprite.play("default")

func _physics_process(_delta):
	var parent: Node2D = get_parent()
	if parent is Player:
		global_position = parent.global_position
		if parent.sprite.is_flipped_h():
			global_position.x -= 28
			if trash_data.is_heavy:
				global_position.x -= 25
		else:
			global_position.x += 28
			if trash_data.is_heavy:
				global_position.x += 25
		global_position.y += 28

func _on_body_entered(_body):
	if _body is TileMap:
		sprite.texture = trash_data.ground_texture
		player_dropped_trash.emit(self)
		is_on_ground = true
	pass

func _on_body_exited(_body):
	if _body is TileMap:
		sprite.texture = trash_data.lifted_texture
		animated_sprite.play("lifted_default")
		is_on_ground = false
	pass

func _on_interactable_area_body_entered(_body):
	if _body is Player:
		player_entered_interaction_range.emit(self)
	pass

func _on_interactable_area_body_exited(_body):
	var player: Player = get_node("/root/Player_")
	print(player.carrying_trash)
	if _body is Player && !player.carrying_trash:
		print("LEFT RANGES")
		player_left_interaction_range.emit(self)
	pass
