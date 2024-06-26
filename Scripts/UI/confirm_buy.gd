extends Control

signal player_bought
signal player_canceled()

var price: int
var upgrade_id: int

func _ready():
	$AnimationPlayer.play("Grow")
	$Background/Yes.grab_focus()

func _on_yes_pressed():
	$ConfirmBuy.play()
	$AnimationPlayer.play("Shrink")
	await($AnimationPlayer.animation_finished)
	visible = false
	player_bought.emit(upgrade_id, price)
	await($ConfirmBuy.finished)
	queue_free()
	pass

func _on_no_pressed():
	close()
	pass

func close():
	$No_Audio.play()
	$AnimationPlayer.play("Shrink")
	await($AnimationPlayer.animation_finished)
	visible = false
	var shop: UpgradeShop = get_node("/root/Game/UpgradeShop")
	shop.opened_card = false
	player_canceled.emit()
	await($ConfirmBuy.finished)
	queue_free()

func _input(event):
	if event.is_action_pressed("Cancel"):
		close()
