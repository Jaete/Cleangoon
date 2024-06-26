extends Button

func _ready():
	grab_focus()

func _on_mouse_entered():
	$"Hover".play()
	pass

func _on_pressed():
	$"Click".play()
	var level_manager: LevelManager = get_node("/root/Game/LevelManager")
	if level_manager.current_level == 1:
		level_manager.load_level(preload("res://TSCN/Levels/level_1.tscn"), 35)
	else:
		level_manager.load_level(preload("res://TSCN/Levels/level_1.tscn"), 55)
	$"..".queue_free()
	pass # Replace with function body.
