class_name UpgradeShop
extends Node

signal player_bought()
signal player_bought_update_UI()

@onready var player: Player = get_node("/root/Game/LevelManager/Level/Player")
@onready var delivery_point: DeliverPoint = get_node("/root/Game/LevelManager/Level/DeliverPoint")
@onready var ui: CanvasLayer = get_node("/root/Game/UI")

var shop: PackedScene = load("res://TSCN/UI/shop_ui.tscn")
var open_shop_button: PackedScene =  preload("res://TSCN/UI/ui_interact_button.tscn")
var button_ui: Sprite2D
var shop_ui: Control

var confirm_buy: PackedScene
var confirm_ui: Control

var shop_opened: bool

enum Upgrades {
	BOOST = 0,
	GRASS_CUTTER,
	STRONG_ARM,
	FLASHLIGHT,
	SPECIAL_STORAGE,
}

var upgrades_available: Array[int] = [
	Upgrades.BOOST,
	Upgrades.GRASS_CUTTER,
	Upgrades.STRONG_ARM,
	Upgrades.FLASHLIGHT,
	Upgrades.SPECIAL_STORAGE,
]

var upgrades_prices: Array[String] = [
	"1000",
	"2000",
	"1000",
	"2500",
	"3000",
]

var opened_card: bool = false
var selected_card: int

func _ready():
	initialize()
	pass

func initialize():
	delivery_point = null
	player = null
	player = get_node("/root/Game/LevelManager/Level/Player")
	delivery_point = get_node("/root/Game/LevelManager/Level/DeliverPoint")
	delivery_point.player_buying.connect(set_possible_shop)
	player.player_opened_shop.connect(open_shop)
	upgrades_available = [
		Upgrades.BOOST,
		Upgrades.GRASS_CUTTER,
		Upgrades.STRONG_ARM,
		Upgrades.FLASHLIGHT,
		Upgrades.SPECIAL_STORAGE,
	]
	for upgrade in upgrades_available:
		var upgrade_to_search = upgrade
		var player_upgrades: Array[int] = get_node("../PlayerData").current_upgrades 
		if player_upgrades.find(upgrade_to_search) != -1:
			upgrades_available.erase(upgrade_to_search)

func set_possible_shop(action: String):
	if action == "Entering":
		if !player.showing_button:
			if player.get_node_or_null("UI_Interact_Button") == null:
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
	if !shop_opened:
		shop_ui = shop.instantiate()
		shop_ui.notify_shop_manager.connect(should_confirm_buy)
		ui.add_child(shop_ui)
		shop_opened = true
	pass

func close_shop():
	if is_instance_valid(shop_ui):
		shop_ui.queue_free()
		shop_opened = false

func _process(_delta):
	if Input.is_action_just_pressed("CloseWindow") && !opened_card:
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
	confirm_ui.player_canceled.connect(regrab_focus)
	selected_card = upgrades_available[upgrade]
	shop_ui.add_child(confirm_ui)
	opened_card = true
	pass

func regrab_focus():
	var selected: CardUpgrade = ui.get_node("ShopUi/ScrollContainer/HBoxContainer").get_child(selected_card)
	selected.grab_focus()

func player_buy(upgrade: int, price: int):
	$UpgradeBought.play()
	player.data.add_upgrade(upgrade)
	player.data.remove_money(price)
	var trash_manager: TrashManager = $"../TrashCollector"
	trash_manager.money_received_on_level -= price
	upgrades_available.erase(upgrade)
	close_shop()
	player_bought.emit(upgrade)
	player_bought_update_UI.emit()
	shop_opened = false
	opened_card = false
