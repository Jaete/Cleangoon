extends Control

signal player_canceled()

func _ready():
	$AnimationPlayer.play("Grow")
	$Background/OK.grab_focus()

func _on_ok_pressed():
	close()
	pass # Replace with function body.

func close():
	$OK_Audio.play()
	$AnimationPlayer.play("Shrink")
	await($AnimationPlayer.animation_finished)
	visible = false
	await($OK_Audio.finished)
	var shop: UpgradeShop = $/root/Game/UpgradeShop
	shop.opened_card = false
	player_canceled.emit()
	queue_free()

func _input(event):
	if event.is_action_pressed("Cancel"):
		close()
