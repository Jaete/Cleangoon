class_name MainCamera
extends Camera2D

@onready var player: Player = get_node("/root/Game/LevelManager/Level/Player")

func _process(_delta):
	global_position = player.global_position
