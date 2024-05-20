class_name PlayerData
extends Resource

enum Upgrades {
	GRASS_CUTTER = 1,
	STRONG_ARM,
	FLASHLIGHT,
	SPECIAL_STORAGE,
}

var money: int = 0
var trash_collected: int = 0
var current_upgrades: Array[int] = []

func add_money():
	pass

func remove_money(quantity: int):
	money -= quantity
	pass

func collect_trash():
	trash_collected += 1
	pass

func add_upgrade(upgrade):
	current_upgrades.append(upgrade)
	pass
