class_name MainCamera
extends Camera2D

@onready var player: Player = $"../Player"

func _process(delta):
	global_position = player.global_position
