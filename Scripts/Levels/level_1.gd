extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var level_manager: LevelManager = get_node("/root/Game/LevelManager")
	add_trash(Vector2(641,672))
	add_trash(Vector2(813,672))
	add_trash(Vector2(849,772))
	add_trash(Vector2(816,810))
	add_trash(Vector2(849,810))
	if get_node("/root/Game/HealthManager").is_game_over:
		get_node("/root/Game/PlayerData").current_upgrades.clear()
	for upgrade in level_manager.upgrades_on_level:
		get_node("/root/Game/PlayerData").current_upgrades.append(upgrade)
		get_node("Player").check_new_upgrade(upgrade)
	level_manager.set_upgrades_on_level()
	level_manager.trash_manager.call_deferred("initialize")
	level_manager.shop_manager.call_deferred("initialize")
	var ui: Control = get_node("/root/Game/UI/Control")
	if !ui.visible:
		ui.visible = true
	var game: Game = get_node("/root/Game")
	game.a_just_pressed = false
	game.scene = 1
	game.level_changed.connect(get_node("/root/Game").cutscene)
	if !get_node("/root/Game/HealthManager").is_game_over:
		call_deferred("start_cutscene")
	get_node("/root/Game/HealthManager").call_deferred("initialize")
	Soundtrack.stream = preload("res://Assets/Audio/Stream Loops 2024-05-22.ogg")
	Soundtrack.play()
	pass

func add_trash(coords: Vector2):
	var trash: Trash = preload("res://TSCN/Entities/trash.tscn").instantiate()
	trash.trash_data = preload("res://Resources/TrashData/Data/common.tres")
	var level: Node2D = get_node("/root/Game/LevelManager/Level")
	level.add_child(trash)
	trash.global_position = coords

func start_cutscene():
	get_node("/root/Game").level_changed.emit()
