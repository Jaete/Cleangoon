extends Button

func _on_mouse_entered():
	$"Hover".play()
	pass

func _on_pressed():
	$"Click".play()
	get_tree().quit()
	pass # Replace with function body.
