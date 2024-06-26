class_name Player
extends RigidBody2D

signal player_grabbed_trash()
signal player_released_trash()
signal player_delivered_trash()
signal player_opened_shop()

signal received_damage()

@export_category("Physics Movement")
@export var physics: PlayerPhysics
@export var recovery_timer: Timer
@export var boost_time: Timer
@export_category("Player Controller")
@export var controller: PlayerController
@export_category("Animation Helper")
@export var animation: AnimationHelper
@export var sprite: Sprite2D
@export var strong_arm: Sprite2D
@export var anim_player: AnimationPlayer
@export var lantern_light: PointLight2D
@export var lantern_occlusion: LightOccluder2D

@onready var data: PlayerData = get_node("/root/Game/PlayerData")

var nearby_trash: bool = false
var carrying_trash: bool = false

var trash_carried: Trash
		
var about_to_deliver: bool
var about_to_open_shop: bool
var showing_button: bool

var is_boosting: bool = false

@onready var game: Game = get_node("/root/Game")

func _ready():
	mass = 0.5
	gravity_scale = 0.3
	get_node("/root/Game/UpgradeShop").player_bought.connect(check_new_upgrade)
	if get_signal_connection_list("joy_connection_changed").size() != 0:
		Input.joy_connection_changed.connect(controller.joypad_active)

func _physics_process(_delta):
	if get_node("/root/Game").on_ui:
		controller.get_vertical_movement()
	else:
		controller.get_input()
	animation.check_direction(self, sprite, strong_arm, lantern_light, lantern_occlusion)
	handle_physics()
	rotate_player()
	check_for_actions()
	if controller.vertical_movement == controller.UP && $Engine.playing == false:
		$Engine2.stop()
		$Engine.play()
		$GPUParticles2D.emitting = true
	if controller.vertical_movement == controller.DOWN && !$Engine2.playing:
		$Engine.stop()
		$Engine2.play()
		$GPUParticles2D.emitting = false
	pass

func rotate_player():
	if controller.vertical_movement < 0:
		animation.rise(sprite, strong_arm)
	elif controller.vertical_movement > 0 && linear_velocity.y > 0:
		animation.fall(sprite, strong_arm)
	else:
		animation.align(sprite, strong_arm)

func handle_physics():
	physics.move(self, is_boosting, controller.horizonal_movement, controller.vertical_movement)
	if controller.is_stopped() && abs(linear_velocity.x) >= 0.1 && get_contact_count() > 0:
		sleeping = true
	else:
		sleeping = false

func check_for_actions():
	if game.game_started && !game.on_cutscene:
		if controller.input_action == controller.GRAB && carrying_trash && !about_to_deliver:
			player_released_trash.emit(trash_carried)
		elif controller.input_action == controller.GRAB && !carrying_trash && nearby_trash:
			player_grabbed_trash.emit()
			controller.get_input()
		if about_to_deliver && controller.input_action == controller.GRAB:
			player_delivered_trash.emit()
		if about_to_open_shop && controller.input_action == controller.GRAB:
			player_opened_shop.emit()
		if controller.is_boosting == true && boost_time.is_stopped() && data.current_upgrades.find(data.Upgrades.BOOST) != -1:
			boost()

func _process(_delta):
	if get_node_or_null("Grabbed_Trash") != null && !carrying_trash:
		carrying_trash = true
		trash_carried = get_node("Grabbed_Trash")
		pass
	pass

func check_new_upgrade(upgrade: int):
	match upgrade:
		data.Upgrades.BOOST:
			for i in 3:
				get_node("/root/Game/UI/Control/Boost").add_child(data.boost_ui.instantiate())
		data.Upgrades.STRONG_ARM:
			$"Strong-arm".visible = true
		data.Upgrades.FLASHLIGHT:
			$Lantern.visible = true
			pass

func boost():
	if data.boost_quantity > 0:
		is_boosting = true
		data.decrement_boost_quantity()
		boost_time.start(data.boost_time)
		if recovery_timer.is_stopped():
			recovery_timer.start(data.boost_recovery)
		get_node("/root/Game/UI/Control/Boost").get_child(0).queue_free()
	pass

func _on_recovery_timeout():
	if data.boost_quantity != 3:
		data.increment_boost_quantity()
		get_node("/root/Game/UI/Control/Boost").add_child(data.boost_ui.instantiate())
		if data.boost_quantity < 3 && recovery_timer.is_stopped():
			recovery_timer.start(data.boost_recovery)
	pass # Replace with function body.

func _on_boost_timeout():
	is_boosting = false
	if Input.is_action_pressed("Boost"):
		boost()
	pass # Replace with function body.

func _on_hurtbox_area_entered(area):
	var parent: Node2D = area.get_parent()
	if area.name == "Mouth" && parent is Fish:
		received_damage.emit(parent as Fish)

func _on_body_entered(body):
	if body is Fish:
		received_damage.emit(body as Fish)
	pass


func _on_child_exiting_tree(node):
	if node is Trash:
		carrying_trash = false
	pass # Replace with function body.

