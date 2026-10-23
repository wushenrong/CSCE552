extends CanvasLayer


@export var music_volume_bus_name := "Music"
@export var sfx_volume_bus_name := "SoundEffects"


var _music_volume_bus := AudioServer.get_bus_index(music_volume_bus_name)
var _sfx_volume_bus := AudioServer.get_bus_index(sfx_volume_bus_name)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%MusicSlider.value = PlayerSettings.music_volume
	%SFXSlider.value = PlayerSettings.sfx_volume


func _on_music_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		PlayerSettings.music_volume = %MusicSlider.value


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_music_volume_bus, linear_to_db(value))


func _on_sfx_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		PlayerSettings.sfx_volume = %SFXSlider.value


func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(_sfx_volume_bus, linear_to_db(value))


func _on_back_button_pressed() -> void:
	PlayerSettings.save_settings()
	get_tree().root.remove_child(self)
