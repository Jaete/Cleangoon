class_name UIShop
extends Control

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

@onready var player: Player = get_node("/root/Player_")
@onready var shop: UpgradeShop = get_node("/root/Game/UpgradeShop")

var card_upgrade: PackedScene = preload("res://TSCN/UI/card_upgade.tscn")
var card_upgrade_ui: CardUpgrade

# Called when the node enters the scene tree for the first time.
func _ready():
	for upgrade in shop.upgrades_available:
		card_upgrade_ui = card_upgrade.instantiate()
		card_upgrade_ui.card_name = upgrades_available_names[upgrade]
		card_upgrade_ui.card_description = upgrades_available_descriptions[upgrade] 
		card_upgrade_ui.card_price = "R$ " + shop.upgrades_prices[upgrade] + ",00"
		get_node("ScrollContainer/HBoxContainer").add_child(card_upgrade_ui)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	Input.action_press("Rise")
	pass

func _exit_tree():
	Input.action_release("Rise")
