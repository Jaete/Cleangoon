extends Label

@onready var fish = $"../.."

func _process(delta):
	set_text(str("Flip x: ", fish.sprite.flip_h, 
	"\nspeed x: ", fish.linear_velocity.x,
	"\nRotate: ", fish.sprite.rotation_degrees))
