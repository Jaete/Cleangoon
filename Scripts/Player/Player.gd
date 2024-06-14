class_name Player
extends RigidBody2D

signal player_grabbed_trash()
signal player_released_trash()
signal player_delivered_trash()
signal player_opened_shop()

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
@export_category("Player Data")
@export var data: PlayerData

var nearby_trash: bool = false
var carrying_trash: bool = false
var trash_carried: Trash
var about_to_deliver: bool
var about_to_open_shop: bool

var is_boosting: bool = false

func _ready():
	mass = 0.5
	gravity_scale = 0.3

func _physics_process(_delta):
	controller.get_input()
	animation.check_direction(self, sprite, strong_arm, lantern_light, lantern_occlusion)
	handle_physics()
	rotate_player()
	check_for_actions()
	pass

func rotate_player():
	if controller.vertical_movement < 0:
		animation.rise(sprite)
	elif controller.vertical_movement > 0 && linear_velocity.y > 0:
		animation.fall(sprite)
	else:
		animation.align(sprite)

func handle_physics():
	physics.move(self, is_boosting, controller.horizonal_movement, controller.vertical_movement)
	if controller.is_stopped() && abs(linear_velocity.x) >= 0.1 && get_contact_count() > 0:
		sleeping = true
	else:
		sleeping = false

func check_for_actions():
	if controller.input_action == controller.GRAB && carrying_trash:
		carrying_trash = false
		player_released_trash.emit(trash_carried)
	elif controller.input_action == controller.GRAB && !carrying_trash && nearby_trash:
		player_grabbed_trash.emit()
		carrying_trash = true
		controller.get_input()
	if about_to_deliver && controller.input_action == controller.GRAB:
		player_delivered_trash.emit()
	if about_to_open_shop && controller.input_action == controller.GRAB:
		player_opened_shop.emit()
	if controller.is_boosting == true && boost_time.is_stopped() && data.current_upgrades.find(data.Upgrades.BOOST) != -1:
		boost()

func _process(_delta):
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
		print("quantity ", data.boost_quantity)
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
		if data.boost_quantity < 3:
			recovery_timer.start(data.boost_recovery)
	pass # Replace with function body.

func _on_boost_timeout():
	print("boost ended")
	is_boosting = false
	if Input.is_action_pressed("Boost"):
		boost()
	pass # Replace with function body.
