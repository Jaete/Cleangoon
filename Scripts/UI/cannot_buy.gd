extends Control

func _ready():
	$AnimationPlayer.play("Grow")

func _on_ok_pressed():
	$OK_Audio.play()
	$AnimationPlayer.play("Shrink")
	await($AnimationPlayer.animation_finished)
	visible = false
	await($OK_Audio.finished)
	queue_free()
	pass # Replace with function body.
