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
	match(card_name):
		"Modo TURBO":
			$Background.texture = preload("res://Assets/UI/boost-card.png")
		"GINSU 2000":
			$Background.texture = preload("res://Assets/UI/ginsu-2000-card.png")
		"Lanterna":
			$Background.texture = preload("res://Assets/UI/lantern-card.png")
		"Compartimento especial":
			$Background.texture = preload("res://Assets/UI/special-storage.png")

func _on_mouse_entered():
	$Hover.play()
	grab_focus()
	pass

func _on_pressed():
	$Click.play()
	card_clicked.emit(int(card_price), upgrade_id)
	pass
