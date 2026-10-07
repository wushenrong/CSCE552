extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_music_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		PlayerSettings.music_volume = %MusicSlider.value


func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		PlayerSettings.sfx_volume = %SFXSlider.value
