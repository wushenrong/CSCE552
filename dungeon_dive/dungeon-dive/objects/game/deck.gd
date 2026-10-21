extends Node2D


const CARD_SCENE = preload("res://objects/game/card.tscn")


const TOP_CARD_COUNT = 1


const SUITS = ["Hearts", "Clubs", "Spades", "Diamonds"]
const RANKS = [
	"Ace", "2", "3", "4", "5", "6", "7",
	"8", "9", "10", "Jack", "Queen", "King"
]


var deck := []
var cards_drawn := []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(TOP_CARD_COUNT):
		var new_card = CARD_SCENE.instantiate()
		$"../CardManager".add_child(new_card)
		new_card.name = "Card"
		new_card.position = $"../Deck".position
		add_to_cards_drawn(new_card)

	# # TODO: Load deck from save
	# create_deck()


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
	print("drawing card")

	var card = deck.pick_random()

	var card_obj = CARD_SCENE.instantiate()

	card_obj.rank = card.rank
	card_obj.suit = card.suit

	deck.erase(card)
	cards_drawn.append(card)


func add_to_cards_drawn(card):
	cards_drawn.insert(0, card)


func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)
