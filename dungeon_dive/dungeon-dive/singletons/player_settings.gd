extends Node

const SETTINGS_FILE = "user://settings.cfg"
const SETTINGS_KEY = "settings"

var config := ConfigFile.new()

@export var music_volume := 1.0
@export var sfx_volume := 1.0

func _ready() -> void:
	var error = config.load(SETTINGS_FILE)

	if error != OK:
		return

	music_volume = config.get_value(SETTINGS_KEY, "music_volume", music_volume)
	sfx_volume = config.get_value(SETTINGS_KEY, "sfx_volume", sfx_volume)


func save_settings():
	config.set_value(SETTINGS_KEY, "music_volume", music_volume)
	config.set_value(SETTINGS_KEY, "sfx_volume", sfx_volume)
	config.save(SETTINGS_FILE)
