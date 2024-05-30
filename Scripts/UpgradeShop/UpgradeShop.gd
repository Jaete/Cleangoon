class_name UpgradeShop
extends Node

@onready var player: Player = get_node("/root/Player_")
@onready var delivery_point: DeliverPoint = get_node("/root/Game/LevelManager/Level/DeliverPoint")
@onready var ui: CanvasLayer = get_node("/root/Game/UI")

var shop: PackedScene = preload("res://TSCN/UI/shop_ui.tscn")
var open_shop_button: PackedScene =  preload("res://TSCN/UI/ui_interact_button.tscn")
var button_ui: Sprite2D
var shop_ui: Control

enum Upgrades {
	GRASS_CUTTER = 0,
	STRONG_ARM,
	FLASHLIGHT,
	SPECIAL_STORAGE,
}

var upgrades_available: Array[int] = [
	Upgrades.GRASS_CUTTER,
	Upgrades.STRONG_ARM,
	Upgrades.FLASHLIGHT,
	Upgrades.SPECIAL_STORAGE,
]

func _ready():
	delivery_point.player_buying.connect(set_possible_shop)
	player.player_opened_shop.connect(open_shop)
	pass

func set_possible_shop(action: String):
	if action == "Entering":
		button_ui = open_shop_button.instantiate()
		player.add_child(button_ui)
		button_ui.global_position.y -= 48
		player.about_to_open_shop = true
	if action == "Leaving":
		player.about_to_open_shop = false
		player.get_node("UI_Interact_Button").queue_free()         

func open_shop():
	shop_ui = shop.instantiate()
	ui.add_child(shop_ui)
	pass

func close_shop():
	shop_ui.queue_free()

func _process(_delta):
	if Input.is_action_just_pressed("CloseWindow"):
		close_shop()
