class_name UpgradeShop
extends Node

@onready var player: Player = get_node("/root/Player_")
@onready var delivery_point: DeliverPoint = get_node("/root/Game/LevelManager/Level/DeliverPoint")
@onready var ui: CanvasLayer = get_node("/root/Game/UI")

var shop: PackedScene = preload("res://TSCN/UI/shop_ui.tscn")
var open_shop_button: PackedScene =  preload("res://TSCN/UI/ui_interact_button.tscn")
var button_ui: Sprite2D
var shop_ui: Control

var confirm_buy: PackedScene
var confirm_ui: Control

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

var upgrades_prices: Array[String] = [
	"1200",
	"1000",
	"2000",
	"3000",
]

func _ready():
	delivery_point.player_buying.connect(set_possible_shop)
	player.player_opened_shop.connect(open_shop)
	pass

func set_possible_shop(action: String):
	if action == "Entering":
		if !player.showing_button:
			button_ui = open_shop_button.instantiate()
			player.add_child(button_ui)
			player.showing_button = true 
			button_ui.global_position.y -= 48
		player.about_to_open_shop = true
	if action == "Leaving":
		if player.showing_button:
			player.get_node("UI_Interact_Button").queue_free()
			player.showing_button = false      
		player.about_to_open_shop = false

func open_shop():
	shop_ui = shop.instantiate()
	shop_ui.notify_shop_manager.connect(should_confirm_buy)
	ui.add_child(shop_ui)
	pass

func close_shop():
	shop_ui.queue_free()

func _process(_delta):
	if Input.is_action_just_pressed("CloseWindow"):
		close_shop()

func should_confirm_buy(price: int, upgrade: int):
	var can_buy: bool = false
	if player.data.money < price:
		confirm_buy = load("res://TSCN/UI/cannot_buy.tscn")
	else:
		confirm_buy = load("res://TSCN/UI/confirm_buy.tscn")
		can_buy = true
	confirm_ui = confirm_buy.instantiate()
	if can_buy:
		confirm_ui.upgrade_id = upgrade
		confirm_ui.price = price
		confirm_ui.player_bought.connect(player_buy)
	shop_ui.add_child(confirm_ui)
	pass

func player_buy(upgrade: int, price: int):
	$UpgradeBought.play()
	player.data.add_upgrade(upgrade)
	player.data.remove_money(price)
	upgrades_available.erase(upgrade)
	shop_ui.queue_free()
