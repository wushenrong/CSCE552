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
	# A continued run replaces this deck in load_save_data
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
	# One drawn card at a time, it has to be placed before the next draw
	if deck.is_empty() or $"../HandSlot".is_holding_card():
		return

	var card_data = deck.pick_random()
	deck.erase(card_data)

	$"../HandSlot".hold_card(spawn_card(card_data))


# Creates a drawn card on top of the deck, also used by the CardManager to restore saved cards
func spawn_card(card_data: Dictionary) -> Node2D:
	var new_card = CARD_SCENE.instantiate()

	new_card.position = position
	new_card.set_card_data(card_data["rank"], card_data["suit"], card_data["modifiers"])

	$"../CardManager".add_child(new_card)
	$"../CardManager".connect_card_signals(new_card)

	cards_drawn.append(card_data)

	return new_card


func reset_deck():
	get_tree().call_group("cards", "queue_free")

	for i in range(cards_drawn.size()):
		var card = cards_drawn.pop_back()
		deck.append(card)


func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)


# Drawn cards are saved by the CardManager, they are added back to cards_drawn as they are spawned
func get_save_data() -> Dictionary:
	return {"deck": deck}


func load_save_data(data: Dictionary) -> void:
	deck = data["deck"]
	cards_drawn.clear()
