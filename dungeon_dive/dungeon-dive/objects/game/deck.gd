extends Node2D


const TOP_CARD_COUNT = 1


var card_scene = preload("res://objects/game/card.tscn")
var deck = []
var cards_drawn = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(TOP_CARD_COUNT):
		var new_card = card_scene.instantiate()
		$"../CardManager".add_child(new_card)
		new_card.name = "Card"
		new_card.position = $"../Deck".position
		add_to_cards_drawn(new_card)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

const SUITS = ["Hearts", "Clubs", "Spades", "Diamonds"]
const RANKS = [
    "Ace", "2", "3", "4", "5", "6", "7",
    "8", "9", "10", "Jack", "Queen", "King"
]

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


func draw_card():
	print("drawing card")

	# TODO: Create new card and handle available card in deck


func add_to_cards_drawn(card):
	cards_drawn.insert(0, card)


func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)
