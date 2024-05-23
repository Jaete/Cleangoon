class_name TrashCollector
extends Node

signal player_released_trash()

@onready var ui: CanvasLayer = get_node("/root/Ui")
@onready var player: Player = get_node("/root/Player_")
@onready var level: Node2D = get_node("/root/Level")

var trashes_nodes: Array[Node]
var interactable_trashes: Array[Trash]
var current_trash_active: Trash
var pick_trash_button: PackedScene =  preload("res://TSCN/UI/ui_interact_button.tscn")
var button_ui: Sprite2D
var control: Control

func _ready():
	player.player_grabbed_trash.connect(grab_trash)
	player.player_released_trash.connect(release_trash)
	trashes_nodes = get_tree().get_nodes_in_group("Trash")
	for trash in trashes_nodes:
		current_trash_active = trash
		current_trash_active.player_entered_interaction_range.connect(start_interaction_ui)
		current_trash_active.player_left_interaction_range.connect(end_interaction_ui)
		current_trash_active.player_dropped_trash.connect(release_trash)
	current_trash_active = null
	control = ui.get_child(0)
	pass

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

func end_interaction_ui(trash: Trash):
	if current_trash_active == trash:
		if is_instance_valid(button_ui):
			button_ui.queue_free()
		current_trash_active = null
		if interactable_trashes.size() != 0:
			current_trash_active = interactable_trashes[0]
			interactable_trashes.clear()
			show_ui(current_trash_active)
	else:
		interactable_trashes.erase(trash)

func grab_trash():
	current_trash_active.set_name("Grabbed_Trash")
	player.trash_carried = current_trash_active
	current_trash_active.reparent(player)
	pass

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

func _process(delta):
	pass
