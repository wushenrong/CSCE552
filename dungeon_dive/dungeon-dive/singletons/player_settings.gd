extends Node

const SETTINGS_FILE = "user://settings.cfg"
const SETTINGS_KEY = "settings"
const PROGRESS_KEY = "progress"

var config := ConfigFile.new()

@export var music_volume := 100
@export var sfx_volume := 100

var highest_wave := 0

func _ready() -> void:
	var error = config.load(SETTINGS_FILE)

	if error != OK:
		return

	music_volume = config.get_value(SETTINGS_KEY, "music_volume", music_volume)
	sfx_volume = config.get_value(SETTINGS_KEY, "sfx_volume", sfx_volume)
	highest_wave = config.get_value(PROGRESS_KEY, "highest_wave", highest_wave)


func save_settings():
	config.set_value(SETTINGS_KEY, "music_volume", music_volume)
	config.set_value(SETTINGS_KEY, "sfx_volume", sfx_volume)
	config.save(SETTINGS_FILE)


func update_highest_wave(wave: int):
	if wave <= highest_wave:
		return

	highest_wave = wave
	config.set_value(PROGRESS_KEY, "highest_wave", highest_wave)
	config.save(SETTINGS_FILE)
