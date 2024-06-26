class_name UIMoney
extends Label

@onready var tr_mgr: TrashManager = get_node("/root/Game/TrashCollector")
@onready var up_shp: UpgradeShop = get_node("/root/Game/UpgradeShop")

func _ready():
	up_shp.player_bought_update_UI.connect(change_money)
	tr_mgr.delivered.connect(change_money)
	change_money()

func change_money():
	var player_data: PlayerData = get_node("/root/Game/PlayerData")
	if player_data != null:
		set_text(str("R$ ", player_data.money, ",00"))
