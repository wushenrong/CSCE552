extends Marker2D
## Invisible spot under the board where the drawn card waits, the cross only shows in the editor


var held_card: Node2D = null


# Slides the drawn card into the slot, it hovers there until it is placed on a tile
func hold_card(card) -> void:
	held_card = card
	$"../Deck".animate_card_to_position(card, position)
	card.start_idle_hover()


# The held card leaves the slot once it is placed on a tile, or freed at the end of a wave
func is_holding_card() -> bool:
	return is_instance_valid(held_card) and held_card.tile_index == -1
