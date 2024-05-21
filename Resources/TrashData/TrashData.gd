class_name TrashData
extends Resource

@export var is_heavy: bool
@export var is_chemical: bool
@export var is_common: bool

var reward_money: int
var ground_texture: Texture2D
var lifted_texture: Texture2D
var shape: Shape2D
var interaction_area: Shape2D
var offset: Vector2

func initialize():
	if is_heavy:
		reward_money = 200
		match randi_range(1,2):
			1:
				ground_texture = load("res://Assets/Sprites/Trash/Heavy/oven.png")
				lifted_texture = ground_texture
				offset = Vector2(0, -4)
				shape = load("res://Resources/TrashData/Shapes/oven.tres")       
				interaction_area = load("res://Resources/TrashData/InteractionAreas/heavy.tres")
			2:
				ground_texture = load("res://Assets/Sprites/Trash/Heavy/couch.png")
				lifted_texture = ground_texture
				offset = Vector2(0, -8)
				shape = load("res://Resources/TrashData/Shapes/couch.tres")       
				interaction_area = load("res://Resources/TrashData/InteractionAreas/heavy.tres")
			#3:
			#4:
	if is_chemical:
		reward_money = 300
	if is_common:
		ground_texture = load("res://Assets/Sprites/Trash/Common/common-ground.png")
		lifted_texture = load("res://Assets/Sprites/Trash/Common/common-lifted.png")
		shape = load("res://Resources/TrashData/Shapes/common.tres")
		offset = Vector2(0, -12)
		interaction_area = load("res://Resources/TrashData/InteractionAreas/common.tres")
		reward_money = 100
		
