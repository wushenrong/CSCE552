extends VBoxContainer


func _ready() -> void:
	%MasterSlider.set_value_no_signal(SettingsManager.master_volume)
	%MusicSlider.set_value_no_signal(SettingsManager.music_volume)
	%SFXSlider.set_value_no_signal(SettingsManager.sfx_volume)


func _on_master_slider_value_changed(value: float) -> void:
	SettingsManager.set_master_volume(value)


func _on_music_slider_value_changed(value: float) -> void:
	SettingsManager.set_music_volume(value)


func _on_sfx_slider_value_changed(value: float) -> void:
	SettingsManager.set_sfx_volume(value)
