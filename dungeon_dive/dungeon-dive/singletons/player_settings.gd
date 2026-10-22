extends Node


const SETTINGS_FILE = "user://settings.cfg"
const SETTINGS_KEY = "settings"


@export_range(0.0, 1.0, 0.01) var music_volume := 1.0
@export_range(0.0, 1.0, 0.01) var sfx_volume := 1.0


var _config := ConfigFile.new()


func _ready() -> void:
	var error = _config.load(SETTINGS_FILE)

	if error != OK:
		return

	music_volume = _config.get_value(SETTINGS_KEY, "music_volume", music_volume)
	sfx_volume = _config.get_value(SETTINGS_KEY, "sfx_volume", sfx_volume)


func save_settings():
	_config.set_value(SETTINGS_KEY, "music_volume", music_volume)
	_config.set_value(SETTINGS_KEY, "sfx_volume", sfx_volume)
	_config.save(SETTINGS_FILE)
