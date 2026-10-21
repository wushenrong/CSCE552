extends Node2D


const CARD_SCENE = preload("res://objects/game/card.tscn")


const TOP_CARD_COUNT = 1


const SUITS = ["hearts", "clubs", "spades", "diamonds"]
const RANKS = [
	14, 2, 3, 4, 5, 6, 7,
	8, 9, 10, 11, 12, 13
]


var deck := []
var cards_drawn := []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# TODO: Load deck from save
	create_deck()


func create_deck():
	deck.clear()

	for suit in SUITS:
		for rank in RANKS:
			var card = {
				"suit": suit,
				"rank": rank,
				"modifiers": []
			}
			deck.append(card)

	deck.shuffle()


func draw_card():
	if deck.is_empty():
		return

	var new_card = CARD_SCENE.instantiate()
	var card_data = deck.pick_random()
	deck.erase(card_data)

	new_card.position = position
	new_card.set_card_data(card_data["rank"], card_data["suit"], card_data["modifiers"])

	$"../CardManager".add_child(new_card)
	$"../CardManager".connect_card_signals(new_card)

	cards_drawn.append(card_data)


func reset_deck():
	get_tree().call_group("cards", "queue_free")

	for i in range(cards_drawn.size()):
		var card = cards_drawn.pop_back()
		deck.append(card)


func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)
