class_name HealthBar
extends TextureProgressBar

@onready var player: Player = get_node("/root/Game/LevelManager/Level/Player")
@onready var health_manager: HealthManager = get_node("/root/Game/HealthManager")

# Called when the node enters the scene tree for the first time.
func _ready():
	health_manager.update_healthbar.connect(update)
	max_value = health_manager.MAX_HEALTH
	pass # Replace with function body.

func update()->void:
	value = health_manager.current_health
