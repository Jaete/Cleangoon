class_name FishData
extends Resource

const SIGHT_OFFSET_Y: int = 18

@export_category("Statistics")
@export var salmon: bool
@export var mudfish: bool
@export var sight_offset_x: int
@export var weight: float
@export var horizontal_speed: float
@export var vertical_speed: float

var sprite_texture: Texture2D
var mouth_position: Vector2
var sight_polygon: ConcavePolygonShape2D

func initialize():
	if salmon:
		sprite_texture = load("res://Assets/Sprites/Fish/Salmon Large.png")
		sight_polygon = load("res://Resources/FishData/Shapes/salmon_sight.tres")
		mouth_position = Vector2(30,-2)
	if mudfish:
		sprite_texture = load("res://Assets/Sprites/Fish/Mudfish Large.png")
		sight_polygon = load("res://Resources/FishData/Shapes/mudfish_sight.tres")
		mouth_position = Vector2(22,-2)
	pass
