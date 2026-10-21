extends Node2D


signal hover_on
signal hover_off

var rank := 0
var suit := ""
var modifiers := []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().connect_card_signals(self)


func set_card_type(card_rank: int, card_suit: String, card_modifiers: Array):
	rank = card_rank
	suit = card_suit
	modifiers = card_modifiers

	var card_texture = [suit, suit.substr(0, suit.length() - 1), rank]

	$CardImage.texture = load("res://assets/card_art/%s/%s_%04d.png" % card_texture)


func _on_area_2d_mouse_entered() -> void:
	hover_on.emit(self)


func _on_area_2d_mouse_exited() -> void:
	hover_off.emit(self)
