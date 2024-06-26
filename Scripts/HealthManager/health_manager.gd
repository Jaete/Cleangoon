class_name HealthManager
extends Node

signal update_healthbar()

var player: Player
@onready var ui: CanvasLayer = get_node("/root/Game/UI")

const MAX_HEALTH: int = 100
var current_health: int = MAX_HEALTH

var is_game_over: bool

func _ready():
	initialize()
	pass

func initialize():
	is_game_over = false
	player = get_node("/root/Game/LevelManager/Level/Player")
	player.received_damage.connect(deal_damage)
	current_health = MAX_HEALTH
	var health_bar: TextureProgressBar = get_node("/root/Game/UI/Control/HP")
	health_bar.value = current_health

func deal_damage(fish: Fish)->void:
	if !is_game_over:
		blink_red()
		if current_health - fish.fish_data.damage < 0:
			current_health = 0
		else:
			current_health -= fish.fish_data.damage
		update_healthbar.emit()
		if current_health == 0 && !is_game_over:
			game_over()
		pass

func blink_red()->void:
	player.anim_player.play("Blink_Red")
	pass

func game_over()->void:
	is_game_over = true
	player.set_physics_process(false)
	player.sprite.rotation_degrees -= 180
	player.sprite.offset.y -= 15
	$GameOver.play()
	await(get_tree().create_timer(2).timeout)
	var level_manager: LevelManager = get_node("/root/Game/LevelManager")
	level_manager.game_over()
	
	

