class_name UIShop
extends Control

signal notify_shop_manager()

var upgrades_available_names: Array[String] = [
	"Modo TURBO",
	"GINSU 2000",
	"Braço mecânico",
	"Lanterna",
	"Compartimento especial",
]

var upgrades_available_descriptions: Array[String] = [
	"Navega da maneira mais rápida, com curta duração.",
	"Corta a mais dura das vegetações.",
	"Levanta o mais pesado lixo.",
	"Ilumina o mais escuro caminho",
	"Carrega o mais perigoso dos lixos.",
]

@onready var player: Player = get_node("/root/Game/LevelManager/Level/Player")
@onready var shop: UpgradeShop = get_node("/root/Game/UpgradeShop")

var card_upgrade: PackedScene = preload("res://TSCN/UI/card_upgade.tscn")
var card_upgrade_ui: CardUpgrade

# Called when the node enters the scene tree for the first time.
func _ready():
	var card_index: int = 0
	var upgrade_cards: Array[CardUpgrade] = []
	for upgrade in shop.upgrades_available:
		card_upgrade_ui = card_upgrade.instantiate()
		card_upgrade_ui.upgrade_id = upgrade
		card_upgrade_ui.card_name = upgrades_available_names[upgrade]
		card_upgrade_ui.card_description = upgrades_available_descriptions[upgrade] 
		card_upgrade_ui.card_price = shop.upgrades_prices[upgrade]
		card_upgrade_ui.card_clicked.connect(emit_to_manager)
		upgrade_cards.append(card_upgrade_ui as CardUpgrade)
		get_node("ScrollContainer/HBoxContainer").add_child(card_upgrade_ui)
	for card in upgrade_cards:
		if card_index == 0:
			card.focus_neighbor_right = upgrade_cards[card_index + 1].get_path()
			card.call_deferred("grab_focus")
		elif card_index == upgrade_cards.size() - 1:
			card.focus_neighbor_left = upgrade_cards[card_index - 1].get_path()
		else:
			card.focus_neighbor_left = upgrade_cards[card_index - 1].get_path()
			card.focus_neighbor_right = upgrade_cards[card_index + 1].get_path()
		card_index += 1
	get_node("/root/Game").on_ui = true
	$Open.play()
	pass

func emit_to_manager(price: int, upgrade):
	notify_shop_manager.emit(price, upgrade)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	Input.action_press("Rise")
	pass

func _exit_tree():
	get_node("/root/Game").on_ui = false
	Input.action_release("Rise")
