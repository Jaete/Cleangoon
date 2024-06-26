class_name TrashCounter
extends Label

@onready var trash_manager: TrashManager = get_node("/root/Game/TrashCollector")

func _process(_delta):
	set_text(str("Coletados: ", trash_manager.collected_trash_on_level))
