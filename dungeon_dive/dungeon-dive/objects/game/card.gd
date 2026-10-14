extends Node


signal hover_on
signal hover_off

var starting_position


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = starting_position
	get_parent().connect_card_signals(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_mouse_entered() -> void:
	hover_on.emit(self)


func _on_area_2d_mouse_exited() -> void:
	hover_off.emit(self)
