extends Node2D
const CARD_SCENE_PATH = "res://objects/game/card.tscn"
const TOP_CARD_COUNT = 1

var cards_drawn = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var card_scene = preload(CARD_SCENE_PATH)
	for i in range(TOP_CARD_COUNT):
		var new_card = card_scene.instantiate()
		$"../CardManager".add_child(new_card)
		new_card.name = "Card"
		new_card.starting_position = Vector2(100 + (i * 110), 100)
		add_to_cards_drawn(new_card)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_to_cards_drawn(card):
	cards_drawn.insert(0, card)

func animate_card_to_position(card, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)