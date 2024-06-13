class_name PlayerData
extends Resource

enum Upgrades {
	GRASS_CUTTER = 0,
	STRONG_ARM,
	FLASHLIGHT,
	SPECIAL_STORAGE,
}

var money: int = 900
var trash_collected: int = 0
var current_upgrades: Array[int] = []

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
	print("upgrade ADICIONADO -> ", upgrade)
	pass

func check_for_upgrade(upgrade: int):
	if(current_upgrades.find(upgrade) != 1):
		print("Player POSSUI upgrade")
	else:
		print("Player NAO POSSUI upgrade")


