class_name PlayerData
extends Node

@export_group("Lantern settings")
@export var polygon_left: PackedVector2Array
@export var polygon_right: PackedVector2Array
@export var light_left: Vector2
@export var light_right: Vector2

@export_group("Boost settings")
@export var boost_time: float = 0.1
@export var boost_recovery: float = 10

var boost_ui: PackedScene = preload("res://TSCN/UI/stamina_pip.tscn")

enum Upgrades {
	BOOST = 0,
	GRASS_CUTTER,
	STRONG_ARM,
	FLASHLIGHT,
	SPECIAL_STORAGE,
}

@export var money: int = 1400
var trash_collected: int = 0
var current_upgrades: Array[int] = []

var boost_quantity: int = 3

func add_money(quantity: int):
	money += quantity
	pass

func remove_money(quantity: int):
	money -= quantity
	pass

func collect_trash():
	trash_collected += 1
	pass

func add_upgrade(upgrade: int):
	current_upgrades.append(upgrade)
	pass

func check_for_upgrade(_upgrade: int):
	pass

func decrement_boost_quantity():
	boost_quantity -= 1
	pass

func increment_boost_quantity():
	boost_quantity += 1
