class_name TrashManager
extends Node

signal delivered()

@onready var ui: CanvasLayer = get_node("/root/Game/UI")
var player: Player
@onready var level: Node2D = get_node("/root/Game/LevelManager/Level")

var trashes_nodes: Array[Node]
var interactable_trashes: Array[Trash]
var current_trash_active: Trash
var deliver_point: DeliverPoint
var pick_trash_button: PackedScene = preload("res://TSCN/UI/ui_interact_button.tscn")
var button_ui: Sprite2D
var control: Control

var cannot_pick_trash: PackedScene = preload("res://TSCN/UI/cannot_pick_trash.tscn")
var cannot_pick_ui: CannotInteract
var collected_trash_on_level: int = 0
var money_received_on_level: int = 0

var health_manager: HealthManager

func _ready():
	initialize()
	pass

func initialize():
	collected_trash_on_level = 0
	level = null
	player = null
	health_manager = get_node("/root/Game/HealthManager")
	trashes_nodes.clear()
	player = get_node("/root/Game/LevelManager/Level/Player")
	level = get_node("/root/Game/LevelManager/Level")
	if health_manager.is_game_over:
		player.data.money -= money_received_on_level
	money_received_on_level = 0
	var money_ui = get_node("/root/Game/UI/Control/Counters/Money/Label")
	money_ui.change_money()
	player.player_grabbed_trash.connect(grab_trash)
	player.player_released_trash.connect(release_trash)
	player.player_delivered_trash.connect(deliver_trash)
	trashes_nodes = level.get_children()
	for trash in trashes_nodes:
		if trash is Trash:
			trash.player_entered_interaction_range.connect(start_interaction_ui)
			trash.player_left_interaction_range.connect(end_interaction_ui)
			trash.player_dropped_trash.connect(release_trash)
	current_trash_active = null
	control = ui.get_child(0)
	set_deliver_point()

func set_deliver_point():
	deliver_point = null
	deliver_point = get_node("/root/Game/LevelManager/Level/DeliverPoint")
	deliver_point.player_delivering.connect(set_possible_delivery)
	deliver_point.player_left_point.connect(set_possible_delivery)

func start_interaction_ui(trash: Trash):
	if !player.showing_button && !player.carrying_trash:
		show_ui(trash)
	elif current_trash_active != trash && interactable_trashes.size() == 0:
		interactable_trashes.append(trash)
	pass

func show_ui(trash: Trash):
	if !player.carrying_trash:
		if trash.get_node_or_null("UI_Interact_Button") == null:
			button_ui = pick_trash_button.instantiate()
			trash.add_child(button_ui)
			button_ui.global_position.y -= 48
		current_trash_active = trash
		player.nearby_trash = true
		player.showing_button = true

func end_interaction_ui(trash: Trash):
	if current_trash_active == trash && player.carrying_trash:
		if trash.get_node_or_null("UI_Interact_Button") != null:
			button_ui.queue_free()
			player.showing_button = false
		current_trash_active = null
		player.nearby_trash = false
		if interactable_trashes.size() != 0:
			current_trash_active = interactable_trashes[0]
			interactable_trashes.clear()
			show_ui(current_trash_active)
		if ui.get_node_or_null("CannotPickTrash") != null:
			ui.get_node("CannotPickTrash").queue_free()
	else:
		if trash.get_node_or_null("UI_Interact_Button") != null:
			button_ui.queue_free()
			player.showing_button = false
		interactable_trashes.erase(trash)
		player.nearby_trash = false
		
		if ui.get_node_or_null("CannotPickTrash") != null:
			ui.get_node("CannotPickTrash").queue_free()
	pass

func grab_trash():
	if current_trash_active.trash_data.is_heavy && player.data.current_upgrades.find(player.data.Upgrades.STRONG_ARM) != -1:
		current_trash_active.set_name("Grabbed_Trash")
		player.trash_carried = current_trash_active
		current_trash_active.reparent(player)
		player.carrying_trash = true
		interactable_trashes.clear()
		$PickTrash.play()
	elif current_trash_active.trash_data.is_heavy:
		$CantPick.play()
		cannot_pick_trash_reason("É muito pesado para carregar.")
	elif current_trash_active.trash_data.is_chemical && player.data.current_upgrades.find(player.data.Upgrades.SPECIAL_STORAGE) != -1:
		current_trash_active.set_name("Grabbed_Trash")
		player.trash_carried = current_trash_active
		current_trash_active.reparent(player)
		player.carrying_trash = true
		interactable_trashes.clear()
		$PickTrash.play()
	elif current_trash_active.trash_data.is_chemical:
		$CantPick.play()
		cannot_pick_trash_reason("Irá contaminar toda a água sem armazenamento apropriado.")
	elif current_trash_active.trash_data.is_common:
		current_trash_active.set_name("Grabbed_Trash")
		player.trash_carried = current_trash_active 
		current_trash_active.reparent(player)
		player.carrying_trash = true
		interactable_trashes.clear()
		$PickTrash.play()
	pass

func cannot_pick_trash_reason(reason: String):
	if ui.get_node_or_null("CannotPickTrash") == null:
		cannot_pick_ui = cannot_pick_trash.instantiate()
		cannot_pick_ui.reason = reason
		ui.add_child(cannot_pick_ui)

func release_trash(_trash: Node2D):
	if player.trash_carried == _trash:
		var trash: Trash = _trash as Trash
		var interactable_area: Area2D = _trash.get_node("InteractableArea")
		player.carrying_trash = false
		if interactable_area.overlaps_body(player):
			current_trash_active = _trash
			player.trash_carried = null
			show_ui(trash)
		else:
			current_trash_active = null
			player.trash_carried = null
			player.carrying_trash = false
		trash.call_deferred("reparent", level)
	pass

func set_possible_delivery(action: String):
	if player.carrying_trash && action == "Entering":
		if !player.showing_button:
			button_ui = pick_trash_button.instantiate()
			player.add_child(button_ui)
			button_ui.global_position.y -= 48
			player.showing_button = true
		player.about_to_deliver = true
	elif action == "Leaving" && player.carrying_trash:
		player.about_to_deliver = false
		player.get_node("UI_Interact_Button").queue_free()
		player.showing_button = false
	pass

func deliver_trash():
	$Delivered.play()
	$AddCash.play()
	money_received_on_level += player.trash_carried.trash_data.reward_money
	player.data.add_money(player.trash_carried.trash_data.reward_money)
	interactable_trashes.erase(player.trash_carried)
	collected_trash_on_level += 1
	player.about_to_deliver = false
	player.trash_carried.queue_free()
	await(get_tree().physics_frame)
	call_deferred("reset_deliver_point")

func reset_deliver_point():
	player.carrying_trash = false
	current_trash_active = null
	player.nearby_trash = false
	player.showing_button = true
	delivered.emit()
	pass
