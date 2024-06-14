extends Label

@onready var pl: Player = $"../.."

func _process(_delta):
	set_text(str("player velocity: ", pl.linear_velocity.x,
	"\nmax speed: ", pl.physics.H_MAX_SPEED))
