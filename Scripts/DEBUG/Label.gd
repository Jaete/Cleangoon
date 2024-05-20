extends Label

@onready var pl: Player = $".."

func _process(delta):
	set_text(str("Jumping: ", Input.is_action_pressed("Rise"),
	"\nVelocity: ", pl.linear_velocity.y))
