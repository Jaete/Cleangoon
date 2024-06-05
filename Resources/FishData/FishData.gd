class_name FishData
extends Resource

const SIGHT_OFFSET_Y: int = 18

@export_category("Statistics")
@export var salmon: bool
@export var mudfish: bool
@export var sight_offset_x: int
@export var damage: int

var sprite_texture: Texture2D
var mouth_position: Vector2
var sight_polygon_right: ConcavePolygonShape2D
var sight_polygon_left: ConcavePolygonShape2D

func initialize():
	if salmon:
		sprite_texture = load("res://Assets/Sprites/Fish/Salmon Large.png")
		sight_polygon_right = load("res://Resources/FishData/Shapes/salmon_sight_right.tres")
		sight_polygon_left = load("res://Resources/FishData/Shapes/salmon_sight_left.tres")
		mouth_position = Vector2(30,-2)
	if mudfish:
		sprite_texture = load("res://Assets/Sprites/Fish/Mudfish Large.png")
		sight_polygon_right = load("res://Resources/FishData/Shapes/mudfish_sight_right.tres")
		sight_polygon_left = load("res://Resources/FishData/Shapes/mudfish_sight_left.tres")
		mouth_position = Vector2(22,-2)
	pass
