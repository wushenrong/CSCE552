extends Node2D


const Card = preload("res://objects/game/card.tscn")


const SUITS = ["hearts", "clubs", "spades", "diamonds"]
const RANKS = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]


var add_card_to_scene: Callable


var deck := []
var cards_drawn := []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: Load deck from save
	create_deck()


func create_deck():
	for suit in SUITS:
		for rank in RANKS:
			var card = {
				"suit": suit,
				"rank": rank,
				"modifiers": []
			}
			deck.append(card)


func reset_deck():
	for i in range(cards_drawn.size()):
		var card = cards_drawn.pop_back()
		deck.append(card)


func draw_card():
	var card = deck.pick_random()
	var card_obj = Card.instantiate()

	card_obj.position = position
	card_obj.set_card_type(card.rank, card.suit, card.modifiers)

	add_card_to_scene.call(card_obj)

	deck.erase(card)
	cards_drawn.append(card)


func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)
