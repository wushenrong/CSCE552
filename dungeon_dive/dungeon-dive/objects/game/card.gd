extends Node2D


signal hover_on
signal hover_off

var rank: int = 0
var suit: String = ""
var modifiers: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().connect_card_signals(self)


func _on_area_2d_mouse_entered() -> void:
	hover_on.emit(self)


func _on_area_2d_mouse_exited() -> void:
	hover_off.emit(self)
