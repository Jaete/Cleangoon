class_name MainCamera
extends Camera2D

@onready var player: Player = get_node("/root/Player_")

func _process(delta):
	global_position = player.global_position
