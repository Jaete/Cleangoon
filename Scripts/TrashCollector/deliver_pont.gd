class_name DeliverPoint
extends Node2D

signal player_delivering()
signal player_buying()
signal player_left_point()

func _ready():
	var trash_manager: TrashManager = get_node("/root/Game/TrashCollector")
	trash_manager.delivered.connect(renovate_interaction)

func _on_range_body_entered(body):
	if body is Player:
		var player: Player = body
		if player.carrying_trash:
			player_delivering.emit("Entering")
		else:
			player_buying.emit("Entering")
	pass

func _on_range_body_exited(body):
	if body is Player:
		var player: Player = body
		if player.carrying_trash:
			player_delivering.emit("Leaving")
		else:
			player_buying.emit("Leaving")
	pass

func renovate_interaction():
	player_buying.emit("Entering")
