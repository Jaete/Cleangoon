class_name DeliverPoint
extends Node2D

signal player_entered_point()
signal player_left_point()

func _on_range_body_entered(body):
	if body is Player:
		var player: Player = body
		if player.carrying_trash:
			player_entered_point.emit(player, "Entering")
	pass


func _on_range_body_exited(body):
	if body is Player:
		var player: Player = body
		if player.carrying_trash:
			player_entered_point.emit(player, "Leaving")
	pass
