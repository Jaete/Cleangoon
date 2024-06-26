extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var level_manager: LevelManager = get_node("/root/Game/LevelManager")
	level_manager.trash_manager.call_deferred("initialize")
	level_manager.shop_manager.call_deferred("initialize")
	if get_node("/root/Game/HealthManager").is_game_over:
		get_node("/root/Game/PlayerData").current_upgrades = level_manager.upgrades_on_level
	level_manager.set_upgrades_on_level()
	get_node("/root/Game").a_just_pressed = false
	get_node("/root/Game").scene = 0
	get_node("/root/Game").level_changed.connect(get_node("/root/Game").cutscene)
	get_node("/root/Game/HealthManager").call_deferred("initialize")
	Soundtrack.stream = preload("res://Assets/Audio/Stream Loops 2024-05-08.ogg")
	Soundtrack.play()
	pass

func start_cutscene():
	get_node("/root/Game").level_changed.emit()
