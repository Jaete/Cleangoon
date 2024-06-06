class_name CardUpgrade
extends Control

var card_name: String
var card_description: String
var card_price: String

# Called when the node enters the scene tree for the first time.
func _ready():
	$CardName.set_text(card_name) #$CardName
	$CardDescription.set_text(card_description)
	$CardPrice.set_text(card_price)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
