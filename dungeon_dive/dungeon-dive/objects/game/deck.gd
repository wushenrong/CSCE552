extends Node2D


const CARD_SCENE = preload("res://objects/game/card.tscn")


const TOP_CARD_COUNT = 1


const SUITS = ["Hearts", "Clubs", "Spades", "Diamonds"]
# 11 = Jack, 12 = Queen, 13 = King, 14 = Ace (matches ScoreManager and RewardData)
const RANKS = [
    14, 2, 3, 4, 5, 6, 7,
    8, 9, 10, 11, 12, 13
]


var deck := []
var cards_drawn := []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_deck()

	for i in range(TOP_CARD_COUNT):
		draw_card()


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
	# Only TOP_CARD_COUNT cards can wait on the deck at once
	if deck.is_empty() or get_unplaced_card_count() >= TOP_CARD_COUNT:
		return

	var card_data = deck.pop_back()
	var new_card = CARD_SCENE.instantiate()
	$"../CardManager".add_child(new_card)
	new_card.name = "Card"
	new_card.set_card_data(card_data["rank"], card_data["suit"], card_data["modifiers"])
	new_card.position = position
	add_to_cards_drawn(new_card)


func reset_deck():
	for card in cards_drawn:
		if is_instance_valid(card) and card.tile_index == -1:
			card.queue_free()

	cards_drawn.clear()
	create_deck()

	for i in range(TOP_CARD_COUNT):
		draw_card()


func get_unplaced_card_count() -> int:
	return cards_drawn.filter(func(card): return card.tile_index == -1).size()


func add_to_cards_drawn(card):
	cards_drawn.insert(0, card)


func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)
