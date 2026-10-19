extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%MusicSlider.value = PlayerSettings.music_volume
	%SFXSlider.value = PlayerSettings.sfx_volume


func _on_music_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		PlayerSettings.music_volume = %MusicSlider.value


func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		PlayerSettings.sfx_volume = %SFXSlider.value


func _on_back_button_pressed() -> void:
	PlayerSettings.save_settings()
	get_tree().root.remove_child(self)
