class_name HealthManager
extends Node

signal update_healthbar()

@onready var player: Player = get_node("/root/Player_")
@onready var ui: CanvasLayer = get_node("/root/Game/UI")

const MAX_HEALTH: int = 100
var current_health: int = MAX_HEALTH

func _ready():
	player.received_damage.connect(deal_damage)
	pass

func deal_damage(fish: Fish)->void:
	blink_red()
	if current_health - fish.fish_data.damage < 0:
		current_health = 0
	else:
		current_health -= fish.fish_data.damage
	update_healthbar.emit()
	if current_health == 0:
		game_over()
	pass

func blink_red()->void:
	player.anim_player.play("Blink_Red")
	pass

func game_over()->void:
	player.set_physics_process(false)
	player.sprite.rotation_degrees -= 180
	player.sprite.offset.y -= 15
	$GameOver.play()
	await($GameOver.finished)
	
	

