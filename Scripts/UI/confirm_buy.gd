extends Control

signal player_bought

var price: int
var upgrade_id: int

func _ready():
	$AnimationPlayer.play("Grow")

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
	await($OK_Audio.finished)
	queue_free()
