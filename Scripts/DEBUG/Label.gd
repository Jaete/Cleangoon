extends Label

@onready var pl: Player = $"../.."

func _process(_delta):
	set_text(str("Jumping: ", Input.is_action_pressed("Rise"),
	"\ncarring?: ", pl.carrying_trash))
