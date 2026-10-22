extends Node2D


signal hovered_over
signal hovered_off


var rank := 0
var suit := ""
var modifiers := []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("cards")


func set_card_type(card_rank: int, card_suit: String, card_modifiers: Array):
	rank = card_rank
	suit = card_suit
	modifiers = card_modifiers

	$CardImage.texture = load(
		"res://assets/card_art/%s/%s_%04d.png" % [suit, suit.left(-1), rank]
	)


func _on_area_2d_mouse_entered() -> void:
	hovered_over.emit(self)


func _on_area_2d_mouse_exited() -> void:
	hovered_off.emit(self)
