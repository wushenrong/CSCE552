extends Node2D


var card_scene = preload("res://objects/game/card.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func draw_card():
	print("drawing card")

	# TODO: Create new card and handle available card in deck
