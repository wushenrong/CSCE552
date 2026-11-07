extends Node

const SETTINGS_FILE = "user://settings.cfg"
const VOLUME_KEY = "volume"

@export_range(0.0, 0.1, 0.01) var master_volume: float = 1.0
@export_range(0.0, 0.1, 0.01) var music_volume: float = 1.0
@export_range(0.0, 0.1, 0.01) var sfx_volume: float = 1.0

@export var master_bus_name := "Master"
@export var music_bus_name := "Music"
@export var sfx_bus_name := "SFX"

var config := ConfigFile.new()

@onready var _master_bus := AudioServer.get_bus_index(master_bus_name)
@onready var _music_bus := AudioServer.get_bus_index(music_bus_name)
@onready var _sfx_bus := AudioServer.get_bus_index(sfx_bus_name)


func _ready() -> void:
	var error = config.load(SETTINGS_FILE)

	if error != OK:
		return

	set_master_volume(config.get_value(VOLUME_KEY, master_bus_name.to_lower(), master_volume))
	set_music_volume(config.get_value(VOLUME_KEY, music_bus_name.to_lower(), music_volume))
	set_sfx_volume(config.get_value(VOLUME_KEY, sfx_bus_name.to_lower(), sfx_volume))


func save_settings():
	config.set_value(VOLUME_KEY, master_bus_name.to_lower(), master_volume)
	config.set_value(VOLUME_KEY, music_bus_name.to_lower(), music_volume)
	config.set_value(VOLUME_KEY, sfx_bus_name.to_lower(), sfx_volume)
	config.save(SETTINGS_FILE)


func set_master_volume(value):
	master_volume = value
	AudioServer.set_bus_volume_db(_master_bus, linear_to_db(master_volume))


func set_music_volume(value):
	music_volume = value
	AudioServer.set_bus_volume_db(_music_bus, linear_to_db(music_volume))


func set_sfx_volume(value):
	sfx_volume = value
	AudioServer.set_bus_volume_db(_sfx_bus, linear_to_db(sfx_volume))
