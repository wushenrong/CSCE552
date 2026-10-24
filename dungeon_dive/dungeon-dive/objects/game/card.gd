extends Node2D


signal hover_on
signal hover_off

const CARD_ART_PATH = "res://assets/card_art/%s/%s_%04d.png"
const ACE_RANK = 14
const IDLE_HOVER_HEIGHT = 8.0
const IDLE_HOVER_TIME = 0.8

var rank := 0
var suit := ""
var modifiers := []
# Index of the tile this card is placed on, -1 while it is still in hand
var tile_index := -1
var idle_hover_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("cards")


func set_card_data(new_rank: int, new_suit: String, new_modifiers := []) -> void:
	rank = new_rank
	suit = new_suit
	modifiers = new_modifiers

	# Card art is numbered Ace = 1 through King = 13, e.g. hearts/heart_0001.png
	var art_number = 1 if rank == ACE_RANK else rank
	$CardImage.texture = load(CARD_ART_PATH % [suit, suit.trim_suffix("s"), art_number])


# Bobs the CardImage while the card waits in the HandSlot, the Area2D stays put so dragging is not affected
func start_idle_hover() -> void:
	stop_idle_hover()

	idle_hover_tween = create_tween().set_loops().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	idle_hover_tween.tween_property($CardImage, "position:y", -IDLE_HOVER_HEIGHT, IDLE_HOVER_TIME)
	idle_hover_tween.tween_property($CardImage, "position:y", 0.0, IDLE_HOVER_TIME)


func stop_idle_hover() -> void:
	if idle_hover_tween:
		idle_hover_tween.kill()

	$CardImage.position.y = 0


# Same shape as the card data in the Deck, so a saved card can be spawned again
func get_card_data() -> Dictionary:
	return {
		"suit": suit,
		"rank": rank,
		"modifiers": modifiers
	}


func _on_area_2d_mouse_entered() -> void:
	hover_on.emit(self)


func _on_area_2d_mouse_exited() -> void:
	hover_off.emit(self)
