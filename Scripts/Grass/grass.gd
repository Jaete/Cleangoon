class_name Grass
extends StaticBody2D

@export_category("Settings")
@export var upper_polygon: CollisionPolygon2D
@export var lower_polygon: CollisionPolygon2D
@export var interaction_area: Area2D
@export var sprite: Sprite2D

var button_ui: Sprite2D
@onready var button: PackedScene = preload("res://TSCN/UI/ui_interact_button.tscn")
@onready var ui: CanvasLayer = get_node("/root/Game/UI")
var cannot_cut: CannotInteract

var cutted: bool = false
var player_on_area: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	upper_polygon.polygon = preload("res://Resources/Grass/closed_upper_shape.tres").segments
	lower_polygon.polygon = preload("res://Resources/Grass/closed_lower_shape.tres").segments
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("Interact") && player_on_area:
		var player: Player = get_node("/root/Player_")
		if player.data.current_upgrades.find(player.data.Upgrades.GRASS_CUTTER) != -1:
			cut_grass()
		else:
			if ui.get_node_or_null("CannotPickTrash") == null:
				cannot_cut = preload("res://TSCN/UI/cannot_pick_trash.tscn").instantiate()
				cannot_cut.reason = "Precisa de algo afiado para cortar isto."
				ui.add_child(cannot_cut)

func cut_grass():
	sprite.texture = preload("res://Assets/Sprites/Environment/thick-grass-cutted.png")
	upper_polygon.polygon = preload("res://Resources/Grass/open_upper_shape.tres").segments
	lower_polygon.polygon = preload("res://Resources/Grass/open_lower_shape.tres").segments
	pass


func _on_grass_interaction_body_entered(body):
	if body is Player:
		if get_node_or_null("UI_Interact_Button") == null:
			button_ui = button.instantiate()
			add_child(button_ui)
		player_on_area = true
	pass # Replace with function body.


func _on_grass_interaction_body_exited(body):
	if body is Player:
		if get_node_or_null("UI_Interact_Button") != null:
			get_node("UI_Interact_Button").queue_free()
		if ui.get_node_or_null("CannotPickTrash") != null:
			ui.get_node("CannotPickTrash").queue_free()
		player_on_area = false
	pass # Replace with function body.
