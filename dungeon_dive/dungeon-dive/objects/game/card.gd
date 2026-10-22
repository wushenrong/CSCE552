extends Node2D


signal hover_on
signal hover_off

const CARD_ART_PATH = "res://assets/card_art/%s/%s_%04d.png"
const ACE_RANK = 14

var rank := 0
var suit := ""
var modifiers := []
# Index of the tile this card is placed on, -1 while it is still in hand
var tile_index := -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().connect_card_signals(self)


func set_card_data(new_rank: int, new_suit: String, new_modifiers := []) -> void:
	rank = new_rank
	suit = new_suit
	modifiers = new_modifiers

	# Card art is numbered Ace = 1 through King = 13, e.g. hearts/heart_0001.png
	var suit_folder = suit.to_lower()
	var art_number = 1 if rank == ACE_RANK else rank
	$CardImage.texture = load(CARD_ART_PATH % [suit_folder, suit_folder.trim_suffix("s"), art_number])


func _on_area_2d_mouse_entered() -> void:
	hover_on.emit(self)


func _on_area_2d_mouse_exited() -> void:
	hover_off.emit(self)
