class_name LevelManager
extends Node

signal level_completed()
signal can_buy_something()

var trash_to_pass: int
var current_level: int
var current_level_node: Node2D
var trash_manager: TrashManager
var shop_manager: UpgradeShop
var next_level: PackedScene
var load_scene: Node2D

var upgrades_on_level: Array[int]

func _ready():
	trash_manager = get_node("/root/Game/TrashCollector")
	shop_manager = get_node("/root/Game/UpgradeShop")
	trash_manager.delivered.connect(check_if_collected_all)
	current_level_node = get_node("Level")
	trash_to_pass = 15
	pass

func check_if_collected_all():
	if current_level == 0 && trash_manager.collected_trash_on_level == 10:
		can_buy_something.emit()
	if trash_manager.collected_trash_on_level == trash_to_pass:
		level_completed.emit()

func change_level(level: PackedScene, new_value: int):
	next_level = level
	var level_instance: Node2D = next_level.instantiate()
	level_instance.name = "Level"
	current_level_node = level_instance
	add_child(current_level_node)
	remove_child(load_scene)
	load_scene.queue_free()
	trash_to_pass = new_value
	current_level += 1

func load_level(level: PackedScene, new_value: int):
	var loading: PackedScene = preload("res://TSCN/UI/loading.tscn")
	load_scene = loading.instantiate()
	remove_child(current_level_node)
	current_level_node.free()
	add_child(load_scene)
	var ui: CanvasLayer = get_node("/root/Game/UI")
	ui.visible = false
	await(get_tree().create_timer(2).timeout)
	ui.visible = true
	call_deferred("change_level", level, new_value)

func end_game():
	pass

func game_over():
	var ui: CanvasLayer = get_node("/root/Game/UI")
	ui.get_node("Control").visible = false
	var boost_counters = ui.get_node("Control/Boost").get_children()
	for counter in boost_counters:
		counter.queue_free()
	var game_over_packed: PackedScene = preload("res://TSCN/UI/game_over.tscn")
	var game_over_scene: Control = game_over_packed.instantiate()
	ui.add_child(game_over_scene)

func set_upgrades_on_level():
	var player_current_upgrades: Array[int] = []
	for upgrade in get_node("/root/Game/PlayerData").current_upgrades:
		player_current_upgrades.append(upgrade)
	for upgrade in player_current_upgrades:
		upgrades_on_level.append(upgrade)
