class_name CardUpgrade
extends Control

signal card_clicked()

var card_name: String
var card_description: String
var card_price: String
var upgrade_id: int

func _ready():
	$CardName.set_text(card_name)
	$CardDescription.set_text(card_description)
	$CardPrice.set_text("R$" + card_price + ",00")

func _on_mouse_entered():
	$Hover.play()
	pass

func _on_pressed():
	$Click.play()
	card_clicked.emit(int(card_price), upgrade_id)
	pass
