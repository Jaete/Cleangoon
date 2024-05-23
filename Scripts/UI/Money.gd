class_name UIMoney
extends Label

@onready var player: Player = get_node("/root/Player_")

func _process(delta):
	
	set_text(str("R$ ", player.data.money, ",00"))
