extends Node2D


var is_card_in_slot := false


# Called by the Boss, the marker is drawn above any card on the tile
func set_affected(affected: bool) -> void:
	$AffectedMarker.visible = affected


func reset_tile():
	is_card_in_slot = false
