class_name TrashManager
extends Node

@onready var ui: CanvasLayer = get_node("/root/Game/UI")
@onready var player: Player = get_node("/root/Player_")
@onready var level: Node2D = get_node("/root/Game/LevelManager/Level")

var trashes_nodes: Array[Node]
var interactable_trashes: Array[Trash]
var current_trash_active: Trash
var pick_trash_button: PackedScene =  preload("res://TSCN/UI/ui_interact_button.tscn")
var button_ui: Sprite2D
var control: Control

var cannot_pick_trash: PackedScene = preload("res://TSCN/UI/cannot_pick_trash.tscn")
var cannot_pick_ui: CannotInteract
var collected_trash_on_level: int = 0

func _ready():
	player.player_grabbed_trash.connect(grab_trash)
	player.player_released_trash.connect(release_trash)
	player.player_delivered_trash.connect(deliver_trash)
	trashes_nodes = get_tree().get_nodes_in_group("Trash")
	for trash in trashes_nodes:
		current_trash_active = trash
		current_trash_active.player_entered_interaction_range.connect(start_interaction_ui)
		current_trash_active.player_left_interaction_range.connect(end_interaction_ui)
		current_trash_active.player_dropped_trash.connect(release_trash)
	current_trash_active = null
	control = ui.get_child(0)
	set_deliver_point()
	pass

func set_deliver_point():
	var deliver_point: DeliverPoint = get_node("/root/Game/LevelManager/Level/DeliverPoint")
	deliver_point.player_delivering.connect(set_possible_delivery)
	deliver_point.player_left_point.connect(set_possible_delivery)

func start_interaction_ui(trash: Trash):
	if current_trash_active == null:
		show_ui(trash)
	elif current_trash_active != trash && interactable_trashes.size() == 0:
		interactable_trashes.append(trash)
	pass

func show_ui(trash: Trash):
	button_ui = pick_trash_button.instantiate()
	trash.add_child(button_ui)
	button_ui.global_position.y -= 48
	current_trash_active = trash
	player.nearby_trash = true

func end_interaction_ui(trash: Trash):
	if current_trash_active == trash:
		if is_instance_valid(button_ui):
			button_ui.queue_free()
		current_trash_active = null
		player.nearby_trash = false
		if interactable_trashes.size() != 0:
			current_trash_active = interactable_trashes[0]
			interactable_trashes.clear()
			show_ui(current_trash_active)
		if ui.get_node_or_null("CannotPickTrash") != null:
			ui.get_node("CannotPickTrash").queue_free()
	else:
		if is_instance_valid(button_ui):
			button_ui.queue_free()
		interactable_trashes.erase(trash)
		player.nearby_trash = false
		if ui.get_node_or_null("CannotPickTrash") != null:
			ui.get_node("CannotPickTrash").queue_free()
	pass

func grab_trash():
	print("IS HEAVY: ", current_trash_active.trash_data.is_heavy)
	print("PLAYER HAVE ARM: ", player.data.current_upgrades.find(player.data.Upgrades.STRONG_ARM))
	if current_trash_active.trash_data.is_heavy && player.data.current_upgrades.find(player.data.Upgrades.STRONG_ARM) != -1:
		current_trash_active.set_name("Grabbed_Trash")
		player.trash_carried = current_trash_active
		current_trash_active.reparent(player)
		player.carrying_trash = true
	elif current_trash_active.trash_data.is_heavy:
		cannot_pick_trash_reason("É muito pesado para carregar.")
	elif current_trash_active.trash_data.is_chemical && player.data.current_upgrades.find(player.data.Upgrades.SPECIAL_STORAGE) != -1:
		current_trash_active.set_name("Grabbed_Trash")
		player.trash_carried = current_trash_active
		current_trash_active.reparent(player)
		player.carrying_trash = true
	elif current_trash_active.trash_data.is_chemical:
		cannot_pick_trash_reason("Irá contaminar toda a água sem armazenamento apropriado.")
	elif current_trash_active.trash_data.is_common:
		current_trash_active.set_name("Grabbed_Trash")
		player.trash_carried = current_trash_active
		current_trash_active.reparent(player)
		player.carrying_trash = true
	pass

func cannot_pick_trash_reason(reason: String):
	if ui.get_node_or_null("CannotPickTrash") == null:
		cannot_pick_ui = cannot_pick_trash.instantiate()
		cannot_pick_ui.reason = reason
		ui.add_child(cannot_pick_ui)

func release_trash(_trash: Node2D):
	var trash: Node2D = _trash
	var interactable_area: Area2D = _trash.get_node("InteractableArea")
	if interactable_area.overlaps_body(player):
		current_trash_active = _trash
		player.trash_carried = _trash
	else:
		current_trash_active = null
		player.trash_carried = null
	trash.call_deferred("reparent", level)
	pass

func set_possible_delivery(action: String):
	if player.carrying_trash && action == "Entering":
		button_ui = pick_trash_button.instantiate()
		player.add_child(button_ui)
		button_ui.global_position.y -= 48 
		player.about_to_deliver = true
	elif action == "Leaving" && player.carrying_trash:
		player.about_to_deliver = false
		player.get_node("UI_Interact_Button").queue_free()
	pass

func deliver_trash():
	player.data.money += player.trash_carried.trash_data.reward_money
	player.trash_carried.queue_free()
	collected_trash_on_level += 1
	player.about_to_deliver = false
	
