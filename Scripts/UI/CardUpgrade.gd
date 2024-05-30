class_name CardUpgrade
extends Control

var card_name: String
var card_description: String

# Called when the node enters the scene tree for the first time.
func _ready():
	$CardName.set_text(card_name)
	$CardDescription.set_text(card_description)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
