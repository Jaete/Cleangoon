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
